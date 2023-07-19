# OSRM repository is divided into two sections:

	1. OSRM Advanced Tutorial:
	A comprehensive step-by-step guide for new users.

	2. OSRM Expert Usage:
    A compilation of code and snippets for expert use.


## OSRM Advanced Tutorial

An OSRM tutorial serves as a valuable resource for individuals, including students who may have limited coding knowledge. 

This comprehensive guide offers a systematic approach to understanding the fundamental principles and features of OSRM. 

By following the tutorial, users can gain proficiency in installing, configuring, and effectively utilising OSRM to compute routes and accomplish diverse routing tasks. 

The tutorial presents clear instructions and practical examples that enable users to swiftly grasp the core concepts of OSRM and effectively leverage its capabilities to fulfil their specific routing requirements.

The instructions provided in the OSRM tutorial are thoughtfully designed to follow a sequential order, where each task builds upon the previous one. It is crucial to go through the steps systematically, ensuring that each task is completed before moving on to the next. This structured approach allows users to gradually progress and develop a solid understanding of OSRM's functionalities and how they are interconnected.


### Clone OSRM Tutorial Repo

git clone https://github.com/mzrghorbani/osrm-tutorial.git


### Instructions

Even though OSRM installation no longer depends on sudoer, the Ubuntu system still needs admin access to install prerequisite software packages.

There are two methods of installing the required packages:

	1. Following the instructions in 'osrm-tutorial.ipynb' to install them, or

	2. Executing automated script `install-deps.sh` with sudo:

		sudo ./install-deps.sh

Then, install OSRM software and setup the OSRM engine by:

	1. Following the instructions in 'osrm-tutorial.ipynb', or

	2. Executing automated script `install-osrm.sh`:

		./install-osrm.sh

Please, see the printouts while the installation is in progress for further instructions.

If you like to add the OSRM executables path to your system path, permanently, execute the command below in osrm-tutorial directory:

	echo "export PATH=\"\$PATH:$(realpath ./osrm-install/bin)\"" >> ~/.bashrc
	source ~/.bashrc

By default, the tutorial is set to download `great-britain-latest.pbf` from http://download.geofabrik.de/ website. 

If you like to download and experiment with different maps, please set the `REGION` and `FILENAME` variables in osrm-install.sh or manually download the desired region from http://download.geofabrik.de/

For instance, for Ethiopia map (ethiopia-latest.osm.pbf) with the file located at: 

http://download.geofabrik.de/africa/ethiopia-latest.osm.pbf,

modify `install-osrm.sh` corresponding lines:

	from:
	REGION="europe"
    FILENAME="great-britain-latest"

	to:
    REGION="africa"
    FILENAME="ethiopia-latest"

During the execution of bash automation scripts, if the software installation failed for any reason (e.g., invalid url), please execute the commands in the `install-osrm.sh` or osrm-tutorial.ipynb manually.

All commands in the bash script are also available in the notebook with descriptions.


### Good practice: 

It is practical to open two terminals. One for running the Jupyter Notebook, and one for running the bash installation script or commands.


### Required files

The `osrm-tutorial` repository contains all the required files and scripts used in the tutorial.

# OSRM Expert Usage

Following the initial installation and setup, please use `osrm-expert.ipynb` for experimenting and creating map networks for different regions.

Before executing jupyter notebook codes, please make sure the OSRM engine is running in the background as a process.

You can check if the engine is running by executing the command below:

	pgrep -x "osrm-routed"

Executing the command will return a process ID if the engine is running.

For experimenting with `osrm-expert.ipynb`, please make sure, the OSRM engine is running with the Ethiopia map. 

We have populated `ethiopia-locations.csv` with four town coordinates. Please add more as desired. 
  