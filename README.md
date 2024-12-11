# OSRM Installation Notes for v5.28.0-unreleased

1. Compiler and Flags

- Compiler: gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
- CMake Version: 3.22
  
2. Key Dependencies

    Boost:

    - Version: 1.81.0
    - Minimum Required: 1.70
    - Installation Path: $HOME/boost_1_81_0

    EXPAT:

    - Version: 2.4.7
    - Library Path: /usr/lib/x86_64-linux-gnu/libexpat.so

    BZip2:

    - Version: 1.0.8
    - Library Path: /usr/lib/x86_64-linux-gnu/libbz2.so

    Lua:

    - Version: 5.2.4
    - Library Path: /usr/lib/x86_64-linux-gnu/liblua5.2.so
    - Minimum Required: 5.2

    Doxygen:

    - Version: 1.9.1
    - Components Found: doxygen, dot

    ZLIB:

    - Version: 1.2.11
    - Library Path: /usr/lib/x86_64-linux-gnu/libz.so

## Fast-track Installation

### To install system dependencies

```bash
sudo bash install-deps.sh
```

### To clone and install OSRM engine

```bash
bash install-osrm.sh
```

Note: This automation script adds the OSRM executables path to your system path. Please see logs for more information.

If necessary, modify the location of boost installation and gcc version in `install-osrm.sh`.

### Run OSRM engine on Africa-Ethiopia map

```bash
bash download-run.sh africa ethiopia-latest
```

Note: The automation script is designed to download `ethiopia-latest.osm.pbf`, create associated osm files, and run OSRM engine for query into the map.

The REGION (e.g., africa) argument is for one of the region's names from <http://download.geofabrik.de/>

Please click on the desired region on this page to locate the map FILENAME.osm.pbf file(e.g., ethiopia-latest)

If the OSRM executables are not added to your system path, please run the command below in osrm-tutorial/ directory:

```bash
export PATH=${PATH}:$(realpath ./osrm-install/bin)
```
  
Or permanently add the path to your .bashrc file by adding the line below:

```bash
export PATH=/home/$whoami/<path to>/osrm-tutorial/osrm-install/bin:$PATH
```

### Check if OSRM engine is running

```bash
ps -aux | grep "osrm-routed"
```

if not, you can run it by:

```bash
osrm-routed --algorithm=MLD ethiopia-latest
```

Note: Ensure the OSM files are already generated and exist in the current directory. If the OSRM files are in different directory, use the command below:

```bash
osrm-routed --algorithm=MLD /path/to/ethiopia-latest
```

Set the path relative to where osm files are stored.

## Missing Libraries and Packages, possibly

### Update gcc (system), if required

```bash
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

sudo apt update

sudo apt install gcc-12 g++-12

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12 --slave /usr/bin/g++ g++ /usr/bin/g++-12

sudo update-alternatives --config gcc

gcc --version
```

### Update user Boost (user), if required

```bash
wget https://sourceforge.net/projects/boost/files/boost/1.81.0/boost_1_81_0.tar.gz

tar -xvzf boost_1_81_0.tar.gz

cd boost_1_81_0

./bootstrap.sh --prefix=$HOME/boost_1_81_0

./b2 install

dpkg -l | grep libboost
```

## Manual Colonning, Installation and Running

### OSRM repository is divided into two sections

 1. OSRM Advanced Tutorial:
 A comprehensive step-by-step guide for new users.

 2. OSRM Expert Usage:
    A compilation of code and snippets for expert use.

### OSRM Advanced Tutorial

An OSRM tutorial serves as a valuable resource for individuals, including students who may have limited coding knowledge.

This comprehensive guide offers a systematic approach to understanding the fundamental principles and features of OSRM.

By following the tutorial, users can gain proficiency in installing, configuring, and effectively utilising OSRM to compute routes and accomplish diverse routing tasks.

The tutorial presents clear instructions and practical examples that enable users to swiftly grasp the core concepts of OSRM and effectively leverage its capabilities to fulfil their specific routing requirements.

The instructions provided in the OSRM tutorial are thoughtfully designed to follow a sequential order, where each task builds upon the previous one. It is crucial to go through the steps systematically, ensuring that each task is completed before moving on to the next. This structured approach allows users to gradually progress and develop a solid understanding of OSRM's functionalities and how they are interconnected.

### Clone OSRM Tutorial Repo

```bash
git clone https://github.com/mzrghorbani/osrm-tutorial.git
```

### Instructions

Even though OSRM installation no longer depends on sudoer, the Ubuntu system still needs admin access to install prerequisite software packages.

There are two methods of installing the required packages:

 1. Following the instructions in 'osrm-tutorial.ipynb' to install them, or

 2. Executing automated script `install-deps.sh` with sudo:

```bash
sudo bash install-deps.sh
```

If you encounter issues when running this command such as "install-deps.sh: line 2: $'\r': command not found", "install-deps.sh: line 46: syntax error: unexpected end of file", or "sudo: unable to execute ./install-deps.sh: No such file or directory"

Please run the command below and repeat the execution.

```bash
dos2unix install-deps.sh
```

Then, install OSRM software:

1. Following the instructions in 'osrm-tutorial.ipynb', or

2. Executing automated script `install-osrm.sh` to install OSRM

```bash
bash install-osrm.sh
```

If you encounter issues like "-bash: ./install-osrm.sh: /bin/bash^M: bad interpreter: No such file or directory", please run dos2unix command on the file and repeat the installation process.

If OSRM executables are not added to your system path, please run the command below in osrm-tutorial/ directory:

```bash
export PATH=${PATH}:$(realpath ./osrm-install/bin)
```

You can check if the executable path is successfully added by entering "osrm-" and DOUBLE-TAB. This should return all executables:

```bash
osrm-components osrm-contract osrm-customize osrm-datastore osrm-extract osrm-partition osrm-routed#
```

Please, see the printouts while the installation is in progress for further instructions.

If you like to add the OSRM executables path to your system path, permanently, execute the command below in osrm-tutorial directory:

```bash
echo "export PATH=\"\$PATH:$(realpath ./osrm-install/bin)\"" >> ~/.bashrc
source ~/.bashrc
```

During the execution of bash automation scripts, if the software installation fails for any reason (e.g., invalid URL), please execute the commands in the `install-osrm.sh` or osrm-tutorial.ipynb manually.

All commands in the bash script are also available in the notebook with descriptions.

### Good practice

It is practical to open two terminals. One for running the Jupyter Notebook, and one for running the bash installation script or commands.

### Required files

The `osrm-tutorial` repository contains all the required files and scripts used in the tutorial.

## OSRM Expert Usage

Following the initial installation and setup, please use `osrm-expert.ipynb` for experimenting and creating map networks for different regions.

Before executing jupyter notebook codes, please make sure the OSRM engine is running in the background as a process.

You can check if the engine is running by executing the command below:

```bash
pgrep -x "osrm-routed"
```

Executing the command will return a process ID if the engine is running.

If you like to see which map OSRM is running with, please execute the command below:

```bash
ps -aux | grep "osrm-routed"
```

## Setting Up Overpass API

### Installation

Download the Overpass API: You can obtain the source code from the Overpass API GitHub repository.

```bash
git clone https://github.com/drolbr/Overpass-API
```

### Compile the source code

```bash
cd Overpass-API
./configure CXXFLAGS="-O2" --prefix=/home/$whoami/<path to>/osrm-tutorial/overpass
make install
```

### Make Directory for database

```bash
mkdir /home/$whoami/<path to>/osrm-tutorial/overpass/db
```

### Importing Data

Download a <region>.osm.bz2 file of your desired region, for example, from Geofabrik.

### Initialize the database with the OSM data after installation

```bash
export db_dir = "/home/$whoami/<path to>/osrm-tutorial/overpass/db"
export exec_dir = "/home/$whoami/<path to>/osrm-tutorial/overpass/bin"

nohup ./bin/init_osm3s.sh <region>-latest.osm.bz2 $db_dir $exec_dir --meta &
```

### Make inquiries into the  database

```bash
$exec_dir/osm3s_query --db-dir $db_dir
```

### A Simple Overpass API inqury

```bash
query = f"""
    <osm-script output="xml">
      <union>
        <query type="node">
          <around radius="{search_radius}" lat="{lat}" lon="{lon}"/>
          <has-kv k="amenity" v="{amenity}"/>
        </query>
        <query type="way">
          <around radius="{search_radius}" lat="{lat}" lon="{lon}"/>
          <has-kv k="amenity" v="{amenity}"/>
        </query>
      </union>
      <print mode="body"/>
      <recurse type="down"/>
      <print mode="meta"/>
    </osm-script>
    """
```

### See in-code inquiry in osrm-location-graph.ipynb:run_overpass_query() function

Note: If you are interested in several maps like a country with its neighbouring countires, download PBF (for OSRM) or BZ2 (for Overpass API), and merge them using

```bash
osmium merge <region1>.latest.osm.bz2 <region2>.latest.osm.bz2 -o <region1&2>-merged-latest.osm.bz2
```

## Using Public OSRM and Overpass API Services

If you have not set up OSRM and Overpass API servers locally yet, you can use the public services provided by these platforms. To do this, you need to replace the local server URLs in the code with the public HTTP addresses provided below:

## OSRM Public Server

Replace the local OSRM server URL in your code with <http://router.project-osrm.org/>. For example, change the osrm_url in the request_osrm_route function to:

osrm_url = f"<http://router.project-osrm.org/route/v1/driving/{source_coords[0]},{source_coords[1]};{dest_coords[0]},{dest_coords[1]}?geometries=geojson&overview=full>"

## Overpass API Public Server

Replace the local Overpass API server URL with <http://overpass-api.de/api/>. Ensure that your queries are correctly formatted for the public Overpass API endpoint. Modify the endpoint in the run_overpass_query function as needed:

```bash
command = ["http://overpass-api.de/api/interpreter", "--db-dir=" + db_dir]
```

Please remember that using public servers may come with limitations on the rate of requests and data size, which could impact the performance and feasibility of your tasks. Always check the terms of use and consider setting up local instances for extensive or frequent querying needs.

In this tutorial, we will install and configure OSRM Engine for route constructions.
  