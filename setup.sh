#!/bin/bash
PLNX_VERSION=2021.1
PLNX_SDK_PATH="~/Documents/plnxSDK2021.1"
ENV_SETUP_SCRIPT="env.sh"


echo "Creating project for KV260..."
echo "Choose petalinux build version:"
echo "1: 2020.2"
echo "2: 2021.1"
echo "3: 2022.2" 
echo "*MAKE SURE TO SET TOOL PATHS IN ENV.SH FIRST*"
read ver

cd .

echo "==== Starting Petalinux setup for KV260 version $PLNX_VERSION ===="
echo "Checking for pre-existing BSP"

mkdir -p cache

if[ ! -f cache/v$PLNX_VERSION.bsp ]; then
   echo "BSP not found, downloading from web..."
   
   case ${ver} in
	  1) PLNX_VERSION=2020.2
	     echo "Downloading KV260 2020.2 BSP"
		 ;;
	  2) PLNX_VERSION=2021.1
	     wget -O cache/v2021.1.bsp "https://xilinx-ax-dl.entitlenow.com/dl/ul/2021/08/27/R210443573/xilinx-k26-starterkit-v2021.1-final.bsp?hash=aGxNI1GDEaDNifalXtx7zQ&expires=1666974996&filename=xilinx-k26-starterkit-v2021.1-final.bsp"
		 ;;
	  3) PLNX_VERSION=2022.2
	     echo "Downloading KV260 2022.2 BSP"
		 ;;
	  *) PLNX_VERSION=2021.1
	     echo "Not a valid version."
	     exit
   esac
   
else
   echo "Found pre-exisiting download"
   
fi


echo Setting up environment
source $ENV_SETUP_SCRIPT

petalinux-create -t project -s cache/v$PLNX_VERSION.bsp -n "build_v2021.1"

if [ PLNX_VERSION=2021.1 ]; then
   sed -i 's/ misc-config//' build_v2021.1/project-spec/meta-user/conf/petalinuxbsp.conf
fi

petalinux-build -p build_v$PLNX_VERSION 


