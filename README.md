# DCI
Deploy Cloud Image - bash scripts which deploy cloud images to Nutanix based on recipes 

It makes use of recipes which are pre-defined. The recipes are simple text files residing in /recipes folder
MAKE sure you edit the config file with your seetings IP/DNS/USER/PASSWORD...

# Installing

Supported OSes:  UBUNTU / DEBIAN / MAC OS / REDHAT / CENTOS

Make sure "git" is installed 

# git clone https://github.com/Tfindelkind/DCI

DCI makes use of genisoiamge/mkisofs and tries to install it if not installed

Prebuild recipes:

1. NTNX-AVM - The Nutanix Automation VM is a cloud image based on Centos 7 with a fixed IP and ready to use for scripting 
2. NTNX-AVM-UBUNTU -The Nutanix Automation VM is a cloud image based on Ubuntu with a fixed IP and ready to use for scripting 

# Usage

Change the config files for your needs ->  /recipes/NTNX-AVM/config to set IP, Nameserver etc.

./dci.sh --list        -> will list all valid recipes

./dci.sh --recipe NTNX-AVM  -> will create seed.iso for the Nutanix Automation VM based on Centos 7   


# Future
In the future this bash script should deploy the cloud images directly to different cloud platforms like Nutanix, AWS, Azure, VMware, and so on.
