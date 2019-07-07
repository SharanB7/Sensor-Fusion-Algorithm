#include <SharpIR.h>
#include <Servo.h>
// SharpIR is coonected to pin A0
SharpIR sensor( SharpIR::GP2Y0A21YK0F, A0 );
// For sharp IR : black-signal,brown-ground,red-vcc
// For servo : white-signal,red-vcc,black-ground
Servo myservo1,myservo2;
// Declaring variables
const int trigPin=5;
const int echoPin=6;
long duration;
int i,pos1 = 0,pos2 = 0; 
double usdistance,irdistance,ir_axis,us_axis;

void setup() 
{
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
  // Servos are coonected to pins 9 and 10
  myservo1.attach(9);
  //myservo2.attach(10);
}

void loop() 
{
    // Servo1 covering 0 to 180 degrees with an increment of 1 degree 
    for (pos1; pos1 <= 180; pos1 += 1) 
    {
      myservo1.write(pos1);             
      // Taking 20 readings from the sensors at each position
      for (i = 1; i<21; i +=1)
      {
        // Taking reading from SharpIR sensor
        int irdistance = sensor.getDistance();
        // Taking reading from Ultrasonic sensor
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);
        duration = pulseIn(echoPin,HIGH);
        usdistance = duration*0.034/2;
        // Calculating distance wrt axis of rotation
        us_axis = sqrt(1+sq(usdistance+1.5));
        ir_axis = sqrt(1+sq(irdistance+2.5));
        // Printing the readings in serial monitor  
        Serial.println(pos1);
        Serial.println(us_axis);
        delay(50);
        Serial.println(ir_axis);
        delay(50);
      }
    }
    //// Servo2 covering 180 to 360 degrees with an increment of 1 degree
    //for (pos2; pos2 <= 180; pos2 += 1) 
    //{
    //  myservo2.write(pos2);
    //  // Taking 20 readings from the sensors at each position
    //  for (i = 1; i<21; i +=1)
    //  {
    //    // Taking reading from SharpIR sensor
    //    int irdistance = sensor.getDistance();
    //    // Taking reading from Ultrasonic sensor
    //    digitalWrite(trigPin, LOW);
    //    delayMicroseconds(2);
    //    digitalWrite(trigPin, HIGH);
    //    delayMicroseconds(10);
    //    duration = pulseIn(echoPin,HIGH);
    //    usdistance = duration*0.034/2;
    //    // Calculating distance wrt axis of rotation
    //    us_axis = sqrt(1+sq(usdistance+1.5));
    //    ir_axis = sqrt(1+sq(irdistance+2.5));  
    //    // Printing the readings in serial monitor 
    //    Serial.println(pos1);
    //    Serial.println(us_axis);
    //    delay(50);
    //    Serial.println(ir_axis);
    //  }
    //}
}
