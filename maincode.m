clc;
close all;
clear all;

% Closing a port that is being used
if ~isempty(instrfind)
fclose(instrfind);
delete(instrfind);
end

% Reading values from serial port
x = serial('COM5','BAUD',9600);
fopen(x);
% Creating an empty matrix to store the readings
mData = [];
% Angle to be covered 
angle = 90;
% At each position/angle 20 readings are taken. The serial monitor prints
% the angle, the distances measured by Ultrasonic and SharpIR sensors. So
% at each angle 60(=20*3) values are printed.
for a = 1:60*angle
readData = fscanf(x);
t = strsplit(readData,'\t'); 
% The values from the serial monitor are in the order 'Angle, Distance
% measured by Ultrassonic sensor and Distance measured by SharpIR sensor'.
% Seperating them into seperate rows.
if rem(a,3) == 1
mData(1,(a+2)/3) = str2double(t(1));
elseif rem(a,3) == 2
mData(2,(a+1)/3) = str2double(t(1));
elseif rem(a,3) == 0
mData(3,a/3) = str2double(t(1));
end
% Angle covered is printed.
if rem(a,60) == 0
    a/60
end
end
% Readings are printed
mData
um = 1;       
im = 1;
k = 1;
y = [1;1];
% Covarience matrix(r) is calculated
r = [0.0086 0;0 0.16556];
h = [1;1];
q = 1e-5;
x_kal = 1;
p_kal = 1;
% Estimated distance can be anything because we apply Kalman filter 20
% times at each position. So the distance converges to the actual value.
x_est = 15;
p_est = 1+q ;
for i = 0:(angle-1)
    % Kalman filter is applied 20 times
    for a = 1+(20*(i)):20*(i+1)
        um = mData(2,a);
        im = mData(3,a);
        y = [um;im];
        % Kalman gain is calculated
        k = (p_est*h')*(inv(((h*p_est)*h')+r));
        % Kalman distance and Process covarience matrix are calculated calculated
        x_kal = x_est+k*(y-h*x_est);
        p_kal = (1-k*h)*p_est;
        x_est = x_kal;
        p_est = p_kal +q;
        dist(a) = x_kal;
        err(a) = p_kal;
    end
    final_x(1,i+1) = x_kal
    final_p(2,i+1) = p_kal
    
end
polarpattern(1:angle,final_x);

