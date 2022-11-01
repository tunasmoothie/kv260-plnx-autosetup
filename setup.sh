#!/bin/bash
BASEDIR=$(dirname "$0")
PATH_CONF_FILE="$BASEDIR/paths.conf"
PLNX_VERSION=0

cd $BASEDIR

echo "Creating project for KV260..."
echo "Choose petalinux build version:"
echo "1: 2020.2"
echo "2: 2021.1"
echo "3: 2022.2" 
echo "*MAKE SURE TO SET TOOL PATHS IN ENV.SH FIRST*"

read ver

case ${ver} in
	1) PLNX_VERSION=2020_2
	;;
	2) PLNX_VERSION=2021_1
	;;
	3) PLNX_VERSION=2022_2
	;;
	*) PLNX_VERSION=0
		echo "Not a valid version."
	    exit 
	;;
esac


echo "==== Starting Petalinux setup for KV260 version $PLNX_VERSION ===="

echo "Sourcing Xilinx tools and other related files"
VV=VIVADO_PATH_$PLNX_VERSION
VT=VITIS_PATH_$PLNX_VERSION
PP=PLNXSDK_PATH_$PLNX_VERSION
source ${!VV}/settings64.sh
source ${!VT}/settings64.sh
source ${!PP}/settings.sh

echo "Checking for pre-existing BSP"

if [ ! -f cache/v$PLNX_VERSION.bsp ]; then
	echo "BSP not found, downloading from web..."
	mkdir -p cache
		case ${PLNX_VERSION} in
		1) 2020_2
	    	wget -O cache/v$PLNX_VERSION.bsp "https://xilinx-ax-dl.entitlenow.com/dl/ul/2021/04/23/R210425118/xilinx-k26-starterkit-v2020.2.2-final.bsp?hash=isxHEDsxXdFtsJQSmUjPUQ&expires=1667217742&filename=xilinx-k26-starterkit-v2020.2.2-final.bsp"
			;;
		2) 2021_1
	    	wget -O cache/v$PLNX_VERSION.bsp "https://xilinx-ax-dl.entitlenow.com/dl/ul/2021/08/27/R210443573/xilinx-k26-starterkit-v2021.1-final.bsp?hash=aGxNI1GDEaDNifalXtx7zQ&expires=1666974996&filename=xilinx-k26-starterkit-v2021.1-final.bsp"
			;;
		3) 2022_2
	    	wget -O cache/v$PLNX_VERSION.bsp "https://xilinx-ax-dl.entitlenow.com/dl/ul/2022/10/17/R210702237/xilinx-kv260-starterkit-v2022.2-10141622.bsp?hash=krc0GyRk7u3zGKeFQ7UCTQ&expires=1667217663&filename=xilinx-kv260-starterkit-v2022.2-10141622.bsp"
			;;
		*)
	    	echo "Not a valid version."
	    	exit
		esac
else
	echo "Found pre-exisiting BSP download"
   
fi

ans='n'

if [ -d build_v$PLNX_VERSION ]; then
	echo "Found pre-existing build for v$PLNX_VERSION!"
	echo "Force creation and overwrite? (y/n)"
	read ans
else
	petalinux-create -t project -s cache/v$PLNX_VERSION.bsp -n "build_v$PLNX_VERSION"
fi

if (ans == 'y') 
then
	petalinux-create -t project -s cache/v$PLNX_VERSION.bsp -n "build_v$PLNX_VERSION" --force
fi

if [ PLNX_VERSION=2021_1 ]; then
	sed -i 's/ misc-config//' build_v2021_1/project-spec/meta-user/conf/petalinuxbsp.conf
fi

if ! grep -Fxq 'BOARD_VARIANT = "kv"' build_v$PLNX_VERSION/project-spec/meta-user/conf/petalinuxbsp.conf
then
	echo 'BOARD_VARIANT = "kv"' >>  build_v$PLNX_VERSION/project-spec/meta-user/conf/petalinuxbsp.conf
fi

echo "======== Performing default build ========"
sed -i 's/# CONFIG_xrt is not set/CONFIG_xrt=y/' build_v$PLNX_VERSION/project-spec/configs/rootfs_config
echo "Enabled xrt package in rootfs"

petalinux-build -p build_v${PLNX_VERSION} 
echo "========= Default build complete ========="

