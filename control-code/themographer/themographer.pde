///////////////////////////////////////////////////////////
// Thermographer control code - Citizen Cartography Lab
///////////////////////////////////////////////////////////

// http://grassrootsmapping.org (for now)
//
// This code is very thoroughly documented/commented to help beginners get a foothold. 
// 	Please comment your code accordingly.
//
// Stepper motor control code based on Dan Thompson's 2010 tutorial:
//  http://danthompsonsblog.blogspot.com/search/label/EasydriverTutorials
//
// For details on the EasyDriver stepper motor controller visit:
// 	http://www.schmalzhaus.com/EasyDriver/
// Melexis IR non-contact thermometer datasheet available at:
// 	http://www.melexis.com/Sensor_ICs_Infrared_and_Optical/Infrared/Digital_plug__play_infrared_thermometer_in_a_TO-can_615.aspx
// (Melexis MLX90614 infrared non contact temperature sensor)

//Thermometer setup:

// pin numbering -- looking down from above, 1-4 counter-clockwise starting to the CCW side of the marker
/*
    ___|___
   / 1   4 \
  (         )
   \ 2   3 /
    \_____/
*/

// connect MLX90614 pin 1 SCL to Arduino pin analog 5
// connect MLX90614 pin 2 SDA to Arduino pin analog 4
// connect MLX90614 pin 3 Vdd to Arduino pin +5V
// connect MLX90614 pin 4 Vss to Arduino pin GND
// solder 100n capacitor between Vdd and Vss

// KHM 2010 /  Martin Nawrath
// Kunsthochschule fuer Medien Koeln
// Academy of Media Arts Cologne
//

  // Set up digital pins for issuing commands to the motor controllers.

  // x-axis stepper motor 
  int DIRX = 3;          // PIN  3 = DIR (direction)
  int STEPX = 2;        // PIN  2 = STEP (step the motor: typical resolution 200 full steps/360 degrees)
  int MS1X = 13;        // PIN 13 = MS
  int MS2X = 9;         // PIN  9 = MS2
  int SLEEPX = 12;      // PIN 12 = SLP (sleep)

  // y-axis stepper motor
  int DIRY = 5;          // PIN  5 = DIR
  int STEPY = 4;        // PIN  4 = STEP
  int MS1Y = 7;        // PIN 7 = MS
  int MS2Y = 8;         // PIN 8 = MS2
  int SLEEPY = 6;      // PIN 6 = SLP

  int dirx = 1;           // dir 0 = left, dir 1 = right
  int diry = 1;           // dir 0 = down, dir 1 = up

  int modeType = 8;       // modeType 1: Full, 2: Half, 4: Quarter, 8: Eighth
  float stepperdeg = 22.2222*modeType;     // steps, half steps, quarter or microsteps per degree
  int degx = 40;          // degrees of field of view in x
  int degy = 30;          // degrees of field of view in y
  void setup() {
  Serial.begin(9600);     // open the serial connection at 9600bps

  // here we set all the pins we need to control the 2 motors to OUTPUT
  // since we are going to send commands FROM them, not read data INTO them

  pinMode(DIRX, OUTPUT);   // set pin 3 to output
  pinMode(STEPX, OUTPUT);  // set pin 2 to output
  pinMode(MS1X, OUTPUT);   // set pin 13 to output
  pinMode(MS2X, OUTPUT);   // set pin 9 to output
  pinMode(SLEEPX, OUTPUT); // set pin 12 to output

  pinMode(DIRY, OUTPUT);   // set pin 5 to output
  pinMode(STEPY, OUTPUT);  // set pin 4 to output
  pinMode(MS1Y, OUTPUT);   // set pin 13 to output
  pinMode(MS2Y, OUTPUT);   // set pin 10 to output
  pinMode(SLEEPY, OUTPUT); // set pin 12 to output
}

void loop()
{

    digitalWrite(MS1X, MS1_MODE(modeType));  // Set state of MS1 based on the returned value from the MS1_MODE() switch statement.
    digitalWrite(MS2X, MS2_MODE(modeType));  // Set state of MS2 based on the returned value from the MS2_MODE() switch statement.
    digitalWrite(SLEEPX, HIGH);              // Set the Sleep mode to AWAKE.

    digitalWrite(MS1Y, MS1_MODE(modeType));  // Set state of MS1 based on the returned value from the MS1_MODE() switch statement.
    digitalWrite(MS2Y, MS2_MODE(modeType));  // Set state of MS2 based on the returned value from the MS2_MODE() switch statement.
    digitalWrite(SLEEPY, HIGH);              // Set the Sleep mode to AWAKE.


  if (dirx == 0) {
    digitalWrite(DIRX, LOW);                 // Set the direction change LOW to HIGH to go in opposite direction
    dirx = 1;
  } else {
    digitalWrite(DIRX, HIGH);
    dirx = 0;
  }
  if (diry == 0) {
    digitalWrite(DIRY, LOW);                 // Set the direction change LOW to HIGH to go in opposite direction
    diry = 1;
  } else {
    digitalWrite(DIRY, HIGH);
    diry = 0;
  }


    
    Serial.print("Steps: ");
    int stepx = 0;                              // Set the counter variable.     
    while(stepx<(modeType*stepperdeg*degx))                 // Iterate for 200, 400, then 800, then 1600 steps, 
                                                // depending on full/half/quarter/eighth step mode
                                            // This guarantees one full rotation of the spindle.
    {
      digitalWrite(STEPX, LOW);              // This LOW to HIGH change is what creates the..
      digitalWrite(STEPX, HIGH);             // .."Rising Edge" so the easydriver knows to when to step.
      delayMicroseconds(1600/modeType);     // This delay time determines the speed of the stepper motor. 

      delay(0);
      stepx++;
    }                              

    Serial.println("Steps: ");
    int stepy = 0;                              // Set the counter variable.     
    while(stepy<(modeType*stepperdeg*degy))                 // Iterate for 200, 400, then 800, then 1600 steps, 
                                                // depending on full/half/quarter/eighth step mode
                                            // This guarantees one full rotation of the spindle.
    {
      digitalWrite(STEPY, LOW);              // This LOW to HIGH change is what creates the..
      digitalWrite(STEPY, HIGH);             // .."Rising Edge" so the easydriver knows to when to step.
      delayMicroseconds(1600/modeType);     // This delay time determines the speed of the stepper motor. 
                                                 
      delay(0);
      stepy++;
    }                              

    //modeType = modeType * 2;                // Multiply the current modeType value by 2 and make the result the new value for modeType.
                                            // This will make the modeType variable count 1,2,4,8 each time we pass though the while loop.
   
  digitalWrite(SLEEPX, LOW);                 // switch off the power to stepper
  digitalWrite(SLEEPY, LOW);                 // switch off the power to stepper

}



int MS1_MODE(int MS1_StepMode){              // A function that returns a High or Low state number for MS1 pin
  switch(MS1_StepMode){                      // Switch statement for changing the MS1 pin state
                                             // Different input states allowed are 1,2,4 or 8
  case 1:
    MS1_StepMode = 0;
    Serial.println("Step Mode is Full...");
    break;
  case 2:
    MS1_StepMode = 1;
    Serial.println("Step Mode is Half...");
    break;
  case 4:
    MS1_StepMode = 0;
    Serial.println("Step Mode is Quarter...");
    break;
  case 8:
    MS1_StepMode = 1;
    Serial.println("Step Mode is Eighth...");
    break;
  }
  return MS1_StepMode;
}



int MS2_MODE(int MS2_StepMode){              // A function that returns a High or Low state number for MS2 pin
  switch(MS2_StepMode){                      // Switch statement for changing the MS2 pin state
                                             // Different input states allowed are 1,2,4 or 8
  case 1:
    MS2_StepMode = 0;
    break;
  case 2:
    MS2_StepMode = 0;
    break;
  case 4:
    MS2_StepMode = 1;
    break;
  case 8:
    MS2_StepMode = 1;
    break;
  }
  return MS2_StepMode;
}
