# DCI
Deploy Cloud Image - bash scripts which generates Cloud-Init meta-data and user-data to deploy cloud images

It makes use of recipes which are defined before used. The recipes are simple text files right now because they are easy to use and enable me to reduce the over in the beginning. This may change in the future.

So basically it only helps to store predefined configs which I hope will help others as well as examples to create their own.

Prebuild recipes:

1. NTNX-AVM - The Nutanix Automation VM is a cloud image based on Ubuntu with a fixed IP and ready to use for scripting 


Future:
In the future this bash script should deploy the cloud images directly to a cloud platform like Nutanix, AWS, Azure, VMware, and so on. This may be difficult because bash may be not the best scripting language for this task.
