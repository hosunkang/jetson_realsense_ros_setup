#!/bin/bash -i

echo -e "\e[32mStart Set up bash file for Realsense-ROS\e[0m"
echo -e "\e[31mThis script made by Hosun Kang\n\e[0m"

echo -e "\e[32m===Set up specification===\e[0m"
echo -e "\e[32mROS version : ROS1 Melodic\e[0m"
echo -e "\e[32mPython version : python2 (Default python version for ROS1 is python2)\e[0m"
echo -e "\e[32mJetpack version : 4.5.1 (L4T 32.5.1)\e[0m"

## First, install ROS Melodic

echo -e "\e[31m=======================\e[0m"
echo -e "\e[31m| Install ROS melodic |\e[0m"
echo -e "\e[31m=======================\e[0m"
sudo apt update -y
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt update -y

sudo apt install ros-melodic-desktop -y

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y
sudo rosdep init
rosdep update

## Second, install librealsense for Nvidia jetson devices (Be carefull!!)
## This process is different with installing to another devices such like laptop, desktop etc.

echo -e "\e[31m========================\e[0m"
echo -e "\e[31m| Install librealsense |\e[0m"
echo -e "\e[31m========================\e[0m"

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt-get install librealsense2-utils -y
sudo apt-get install librealsense2-dev -y

if [ -d librealsense ]
then 
    echo -e "\e[31mlibrealsense directory is already exist\e[0m"
else
    echo -e "\e[31m\nDownload librealsense\e[0m"
    git clone https://github.com/IntelRealSense/librealsense.git
fi

cd librealsense/scripts/Tegra
sudo sed -i 's/git:\/\//https:\/\//g' source_sync.sh

cd ..
sudo sed -i 's/git:\/\/nv-tegra.nvidia.com\/linux-${KERNEL_RELEASE}/https:\/\/nv-tegra.nvidia.com\/r\/linux-${KERNEL_RELEASE}/g' patch-realsense-ubuntu-L4T.sh

cd ..
./scripts/patch-realsense-ubuntu-L4T.sh

sudo apt-get install git libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev -y
./scripts/setup_udev_rules.sh

if [ -d build ]
then
    echo -e "\e[31m\nbuild directory in librealsense is already exist\e[0m"
else
    echo -e "\e[31m\nMake build directory\e[0m"
    mkdir build
fi
cd build

echo "export CUDA_HOME=/usr/local/cuda" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" >> ~/.bashrc
echo "export PATH=\$PATH:\$CUDA_HOME/bin" >> ~/.bashrc
source ~/.bashrc

cmake .. -DBUILD_EXAMPLES=true -DCMAKE_BUILD_TYPE=release -DFORCE_RSUSB_BACKEND=false -DBUILD_WITH_CUDA=true && make -j$(($(nproc)-1)) && sudo make install

## Third, install realsense-ros

echo -e "\e[31m=========================\e[0m"
echo -e "\e[31m| Install realsense-ros |\e[0m"
echo -e "\e[31m=========================\e[0m"

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src/

if [ -d realsense-ros ]
then
    echo -e "\e[31mrealsense-ros is already exist\e[0m"
else
    echo -e "\e[31m\nDownload realsense-ros\e[0m"
    git clone https://github.com/IntelRealSense/realsense-ros.git
fi

if [ -d ddynamic_reconfigure ]
then
    echo -e "\e[31mddynamic_reconfigure is already exist\e[0m"
else
    echo -e "\e[31m\nddynamic-reconfigure\e[0m"
    git clone https://github.com/pal-robotics/ddynamic_reconfigure.git
fi

cd realsense-ros/
git checkout `git tag | sort -V | grep -P "^2.\d+\.\d+" | tail -1`
cd ..

catkin_init_workspace
cd /opt/ros/melodic/share/cv_bridge/cmake
sudo sed -i 's/\/usr\/include\/opencv/\/usr\/include\/opencv4/' cv_bridgeConfig.cmake

cd ~/catkin_ws
catkin_make clean
catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release
catkin_make install

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
echo "alias cs='cd ~/catkin_ws/src'" >> ~/.bashrc
echo "alias cw='cd ~/catkin_ws'" >> ~/.bashrc
echo "alias cm='cd ~/catkin_ws & catkin_make'" >> ~/.bashrc
source ~/.bashrc

echo -e "\e[31mSet up is finished\e[0m"

