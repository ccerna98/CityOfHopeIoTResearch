/*
Basic_SPI.ino
Brian R Taylor
brian.taylor@bolderflight.com

Copyright (c) 2017 Bolder Flight Systems

Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
and associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, 
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "MPU9250.h"
#include <math.h>

MPU9250 IMU0(SPI,5);
MPU9250 IMU1(SPI,2);
MPU9250 IMU2(SPI,3);

int status0;
int status1;
int status2;

double omega[][3] = { {0,0,0}, {0,0,0}, {0,0,0} }; // imu, axis
double accel[][3] = { {0,0,0}, {0,0,0}, {0,0,0} };
double theta[][3] = { {0,0,0}, {0,0,0}, {0,0,0} };

long newTime = 0;
long lastTime = 0;

const double rad2deg = 180 / PI;

void setup() {
  
  Serial.begin(38400);
  while(!Serial) {}

  status0 = IMU0.begin();
  if (status0 < 0) {
    Serial.println("IMU initialization unsuccessful");
    Serial.println("Check IMU1 wiring or try cycling power");
    Serial.print("Status 0: ");
    Serial.println(status0);
    while(1) {}
  }
 
//  status1 = IMU1.begin();
//  if (status1 < 0) {
//    Serial.println("IMU initialization unsuccessful");
//    Serial.println("Check IMU1 wiring or try cycling power");
//    Serial.print("Status 1: ");
//    Serial.println(status1);
//    while(1) {}
//  }

//  status2 = IMU2.begin();
//  if (status2 < 0) {
//    Serial.println("IMU initialization unsuccessful");
//    Serial.println("Check IMU1 wiring or try cycling power");
//    Serial.print("Status 2: ");
//    Serial.println(status2);
//    while(1) {}
//  }
  
}

void loop() {

  newTime=millis();

  float delta = (newTime - lastTime) / 1000.0;

  for(int imu = 0; imu < 1; imu++){
    
    updateIMU(imu);
    
    for(int axis = 0; axis < 3; axis++){
      
      theta[imu][axis] = theta[imu][axis] + omega[imu][axis] * delta;
      theta[imu][axis] = imposeRange(theta[imu][axis]);

      Serial.print(theta[imu][axis], 6);
      Serial.print("\t");
      
    }
  }
  
  Serial.print("\n");
  
  delay(100);

  lastTime = newTime;
}

void updateIMU(int imu){

  if (imu == 0){
    IMU0.readSensor();

    omega[0][0] = IMU0.getGyroX_rads() * rad2deg; //gyro X
    omega[0][1] = IMU0.getGyroY_rads() * rad2deg; //gyro Y
    omega[0][2] = IMU0.getGyroZ_rads() * rad2deg; //gyro Z

    accel[0][0] = IMU0.getAccelX_mss(); //accl X
    accel[0][1] = IMU0.getAccelY_mss(); //accl Y
    accel[0][2] = IMU0.getAccelZ_mss(); //accl Z

  } else if (imu == 1){
    IMU1.readSensor();
    
    omega[1][0] = IMU1.getGyroX_rads() * rad2deg; //gyro X
    omega[1][1] = IMU1.getGyroY_rads() * rad2deg; //gyro Y
    omega[1][2] = IMU1.getGyroZ_rads() * rad2deg; //gyro Z
  
    accel[1][0] = IMU1.getAccelX_mss(); //accl X
    accel[1][1] = IMU1.getAccelY_mss(); //accl Y
    accel[1][2] = IMU1.getAccelZ_mss(); //accl Z
    
  } else if (imu == 2){
    IMU2.readSensor();
    
    omega[2][0] = IMU2.getGyroX_rads() * rad2deg; //gyro X
    omega[2][1] = IMU2.getGyroY_rads() * rad2deg; //gyro Y
    omega[2][2] = IMU2.getGyroZ_rads() * rad2deg; //gyro Z
  
    accel[2][0] = IMU2.getAccelX_mss(); //accl X
    accel[2][1] = IMU2.getAccelY_mss(); //accl Y
    accel[2][2] = IMU2.getAccelZ_mss(); //accl Z
    
  }
}

double imposeRange(double value){ //imposes -180 to 180 range
  if(value > 180 || value < -180){
    value *= -1;
  }
  return value;
}
