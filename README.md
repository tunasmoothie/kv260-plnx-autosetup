# KV260 Autosetup Script Package

#### BEFORE STARTING:
- Please update 'env.sh' with the appropriate paths to your Xilinx tool installations.


## Instructions
Run 'setup.sh'. Petalinux build will be located in './build_v[selected build version]'



## Common Problems
- If petalinux-build fails due to fetcher failure, manually delete 'components' folder inside the corresponding build folder.
