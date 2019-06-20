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
A=[1];
B=[0];
C=[1 1];
Uk=[0];
Wk=[0];
H=[1; 1]
Zk=[0];
I=[1 0;0 1]
mData
um = 1;       
im = 1;
K = 1;
Xkm = [1;1];
% Covarience matrix(r) is calculated
R = [0.0086 0;0 0.16556];
Qk = 1e-5;
Xk = 1;
Pk = 1;
% Estimated distance can be anything because we apply Kalman filter 20
% times at each position. So the distance converges to the actual value.
X_est = 15;
P_est = 1+Qk ;
for i = 0:(angle-1)
    % Kalman filter is applied 20 times
    for a = 1+(20*(i)):20*(i+1)
        um = mData(2,a);
        im = mData(3,a);
        Xkm = [um;im];
        
        %New state
        Xkp=A*X_est+B*Uk+Wk;
        Pkp=A*P_est*A'+Qk;
        %Kalman gain
        K=(Pkp*H)*inv(H*Pkp*H'+R);
        %measurement state
        Y=C*Xm+Zk;
        %kalman state
        Xk=Xkp+K*(Y-H*Xkp);
        Pk=(I-K*H)*Pkp;
        %updating
        Xkp=Xk;
        Pkp=Pk;
        
    end
    final_x(1,i+1) = Xk
    final_p(2,i+1) = Pk
    
end
polarpattern(1:angle,final_x);
