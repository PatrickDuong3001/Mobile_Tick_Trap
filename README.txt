This group project contains multiple files: MATLAB file, OnShape files, and pdf files. 
I co-developed the MATLAB file with Ed Kelly.
In and Zak created 3D designs.
Orian prepared final documentation and poster. 

Functionality: 
- The tick trap is able to move back and forth (on a steel cable) between two points thanks to a motor driver
  that controls two gear motors. 
- Two ultrasonic sensors attached to the two sides of the trap will detect the distance between
  the trap and the endpoints. If the trap is about to collide with one of the endpoint, 
  the motor driver will rotate the gear motors in the opposite direction. 
- Two push buttons attached below the sensors serve as the failsafe in case the sensors do 
  not work properly and the trap crashes the endpoint. If that happens, the push button will send
  a signal to the motor driver so that the motor driver reverse the rotation of the gear motors. 

Components: 
- 2 ultrasonic sensors
- 2 gear motors
- 2 push buttons (bump switches)
- 1 motor driver
- 1 Arduino microcontroller