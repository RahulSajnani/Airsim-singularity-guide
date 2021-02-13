# Airsim-singularity-guide
Instructions and code to run AirSim binaries on singularity.

This README assumes you have singularity v3.7.1 configured on your system. Ever wondered how to run AirSim binaries in a singularity container with GPUs? If so, then you are in the right location.



### Steps to follow

1. Clone the repo and change working directory

   ```bash
   # Clone the repo
   git clone https://github.com/RahulSajnani/Airsim-singularity-guide
   
   # Change directory
   cd Airsim-singularity-guide
   ```

2. Pull the AirSim image from dockerhub

   ```bash
   # Pull the AirSim image from dockerhub
   singularity pull docker://rahulsajnani/airsim_binary:10.0-devel-ubuntu18.04
   ```

3. Download the appropriate environment binary from the AirSim release page [here](https://github.com/microsoft/AirSim/releases/tag/v1.4.0-linux)

   ```bash
   # For demonstration we will download Blocks.zip
   wget https://github.com/microsoft/AirSim/releases/download/v1.4.0-linux/Blocks.zip
   
   # Unzip Blocks environment
   unzip Blocks.zip
   
   
   ```

   





### Version

- Singularity: 3.7.1
- AirSim: 1.4.0