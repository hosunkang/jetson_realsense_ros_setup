# jetson_realsense_ros
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
    - If you get connection error with teger.nividia sever, you need to wait or inquire
    
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
