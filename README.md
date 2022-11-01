# KV260 Autosetup Script Package

#### BEFORE STARTING:
1. Update 'env.sh' with the appropriate paths to your Xilinx tool installations.
2. Install Device Tree Compiler Tool, available through ```apt```
  ```sudo apt install device-tree-compiler```


## Usage
Run 'setup.sh'. Petalinux build folder will be created and named **build_v[selected build version]**



## Common Problems
- If petalinux-build fails due to fetcher failure, manually delete 'components' folder inside the corresponding build folder.
