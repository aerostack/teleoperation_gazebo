# teleoperation_gazebo

In this project, the user can use the keyboard to teleoperate a drone using the simulator Gazebo.

- Change directory to this project:

        $ cd /teleoperation_gazebo

- Execute the script that launches Gazebo:

        $ ./launcher_gazebo.sh

- Wait until the following window is presented:

![Gazebo simulator interface with drone ](https://i.ibb.co/XV1hYDy/Captura-de-pantalla-de-2021-06-07-11-16-42.png)

- Open a new terminal and change directory to the project:

        $ cd /teleoperation_gazebo

- Execute the script that launches the Aerostack components for this project:
 
        $ ./main_launcher.sh

- Click on the window corresponding to the keyboard teleoperation interface and teleoperate the drone using the appropriate keys.

![Alphanumeric interface view](https://i.ibb.co/yXWbMSz/Captura-de-pantalla-de-2021-06-08-13-00-52.png)

- To stop the processes execute the following script:

        $ ./stop.sh

- To close the inactive terminals:

        $ killall bash

## Video demo:

[ ![Basic Tello Mission](https://img.youtube.com/vi/8RhyvMiy8PU/0.jpg)](https://www.youtube.com/watch?v=8RhyvMiy8PU)
