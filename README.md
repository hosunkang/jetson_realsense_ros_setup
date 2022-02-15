# jetson_realsense_ros

### Ver. 1
- Jetson Xavier NX, Nano Test complete(2022.02.04)
- Jetpack 4.5.1 (+ Jetpack 4.6.0 Test complete)
    - ubuntu 18.04
    - L4T 32.5.1
    - TensorRT 7.1.3
    - cuDNN 8.0
    - CUDA 10.2
    - OpenCV 4.1.1
- ROS Melodic
    - python2
    

### USAGE

- **Caution : Don’t upgrade software, when you get upgrade message**
1. Prepare SD card with Jetpack installed
    
    [JetPack Archive](https://developer.nvidia.com/embedded/jetpack-archive)
    
2. Download the bash file in your home directory
3. Run this command (Need the password) → Authority permission command
    
    ```bash
    sudo chmod +x jetson_rs_setup.sh
    ```
    
4. Run the bash file
    - It needs a lot of time, So, I recommend you changing power saving mode setting longer on your board
    - You may need to enter your password once, please check it.
    
    ```bash
    ./jetson_rs_setup.sh
    ```
    
5. (If “Command 6” doesn’t work,) Reboot the terminal or Run below command
    
    ```bash
    source ~/.bashrc
    ```
    
6. Run the realsense2_camera launch file
    
    ```bash
    # Just RGB, Depth image
    roslaunch realsense2_camera rs_camera.launch
    
    # Pointcloud2 data together
    roslaunch realsense2_camera rs_camera.launch filters:=pointcloud
    ```
    
7. Check the topic message on the another terminal
    
    ```python
    rviz
    #or
    rostopic list
    ```
