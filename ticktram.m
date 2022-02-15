%Developed by Patrick and Ed

motorPins = {'D5','D6','D8','D9','D7','D10'};%{Ain1,Ain2,Bin1,Bin2,PWMA,PWMB}
bumpSwitch1 = 'D50';
bumpSwitch2 = 'D48';
onOffSwitch = 'D3';
configurePin(a,onOffSwitch,'pullup');
configurePin(a,bumpSwitch1,'pullup');
configurePin(a,bumpSwitch2,'pullup');       
%ultrasonicObj1 = ultrasonic(a,'D45','D44'); % trigger pin = D45 ; echo pin = D44
%ultrasonicObj2 = ultrasonic(a,'D25','D24'); % trigger pin = D25 ; echo pin = D24

forward = [1 0 1 0 1];    %
back = [0 1 0 1 1];       %   vectors to send to motorControl 
stop = [0 0 0 0 0];       %

% variables for easy adjustment
direction = 'f';
runTime = 1000; %seconds         
restTime = 5;   %seconds
speed = 5; %  must be 0-5

while(1) 
   switchState = readDigitalPin(a,onOffSwitch);
   motorControl(a,motorPins,stop,speed)
    tic
   while(switchState == 1)
        
         if toc>runTime
        motorControl(a,motorPins,stop,speed) % every 'runTime' seconds pause for 'restTime'
        pause(restTime)
        tic
         end
         
     if direction == 'f'  % if moving forward 
         motorControl(a,motorPins,forward,speed)% both motors forward and on
         % while moving forward read forward facing ultrasonic and bump
         % switches to check for obstacles
         distance = readDistance(ultrasonicObj1)
         bump = readDigitalPin(a,bumpSwitch1);
         if distance <.2 && distance >.01 || bump == 0 % 
            motorControl(a,motorPins,stop,speed)         %If sensors tripped stop and pause  
           pause(.5)
           distance = readDistance(ultrasonicObj1);
            bump = readDigitalPin(a,bumpSwitch1);
           if  distance <.2 && distance >.01 || bump == 0 % check sensors again to filter out false readings
           direction = 'b'; % switch to backward 
           end
          end

      elseif direction == 'b'    % if moving backward
              motorControl(a,motorPins,back,speed)% both motors backwards and on
              % read back facing sensors
              distance = readDistance(ultrasonicObj2) 
              bump = readDigitalPin(a,bumpSwitch2);  
        if distance <.2 && distance >.01 || bump == 0 % if sensors tripped
            motorControl(a,motorPins,stop,speed)      % stop motor
           pause(.5)                                  % and pause
           distance = readDistance(ultrasonicObj2);   
           bump = readDigitalPin(a,bumpSwitch2)   ;
           if  distance <.2 && distance >.01 || bump == 0 % check sensor again to filter out false readings
           direction = 'f';                               % change direction
           end
       
        end

      else
               motorControl(a,motorPins,stop,speed)% both motors stop
     end
     switchState = readDigitalPin(a,onOffSwitch); 
    end
    motorControl(a,motorPins,stop,speed)   % stop motors if on/off switch is off
    
end
 


%   Function to control speed and direction of motors
function   motorControl(a,motorPins,pinState,speed)
%  motorControl(a,motorPins,onOff,speed)
% motorControl(a,motorPins,[1 0 1 0 1],speed)   both motors forward and PWM
%     on at speed 
%  enter motor pins in order, Ain1 Ain2  Bin1 Bin2 PWMB pwma
% onOff is 5 character vector with zero's and ones, first four direction,
% 5th is PWM speed control pin on or off

for k = 1:4
    writeDigitalPin(a,motorPins{k},pinState(k));
end
 writePWMVoltage(a,motorPins{5},pinState(5).*speed);
 writePWMVoltage(a,motorPins{6},pinState(5).*speed);
end