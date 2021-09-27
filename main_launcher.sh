#!/bin/bash

NUMID_DRONE=1
UAV_MASS=1.5

export APPLICATION_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# alphanumeric_viewer                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "alphanumeric_viewer"  --command "bash -c \"
roslaunch alphanumeric_viewer alphanumeric_viewer.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    my_stack_directory:=${AEROSTACK_PROJECT};
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# keyboard_teleoperation_with_pid_control                                                     ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "keyboard_teleoperation_with_pid_control"  --command "bash -c \"
roslaunch keyboard_teleoperation_with_pid_control keyboard_teleoperation_with_pid_control.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Pixhawk Interface                                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Pixhawk Interface" --command "bash -c \"
roslaunch pixhawk_interface pixhawk_interface.launch \
--wait drone_id_namespace:=drone$NUMID_DRONE acro_mode:=false simulation_mode:=true;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Basic Behaviors                                                                             ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Basic Behaviors" --command "bash -c \"
roslaunch basic_quadrotor_behaviors basic_quadrotor_behaviors.launch --wait \
  namespace:=drone$NUMID_DRONE;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With PID Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With PID Control" --command "bash -c \"
roslaunch quadrotor_motion_with_pid_control quadrotor_motion_with_pid_control.launch --wait \
    namespace:=drone$NUMID_DRONE \
    robot_config_path:=${APPLICATION_PATH}/configs/drone$NUMID_DRONE \
    uav_mass:=$UAV_MASS;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Throttle Controller                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Throttle Controller" --command "bash -c \"
roslaunch thrust2throttle_controller thrust2throttle_controller.launch --wait \
  namespace:=drone$NUMID_DRONE \
  uav_mass:=$UAV_MASS;
exec bash\""  &

rosrun topic_tools relay /drone${NUMID_DRONE}/mavros/local_position/pose /drone${NUMID_DRONE}/self_localization/pose &
rosrun topic_tools relay drone${NUMID_DRONE}/mavros/local_position/velocity_local /drone${NUMID_DRONE}/self_localization/speed &

sleep 5
rosservice call /drone$NUMID_DRONE/basic_quadrotor_behaviors/behavior_self_localize_with_ground_truth/activate_behavior "timeout: 10000" &
rosservice call /drone$NUMID_DRONE/quadrotor_motion_with_pid_control/behavior_quadrotor_pid_motion_control/activate_behavior "timeout: 10000" &
rosservice call /drone$NUMID_DRONE/quadrotor_motion_with_pid_control/behavior_quadrotor_pid_thrust_control/activate_behavior "timeout: 10000" &
