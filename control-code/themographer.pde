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

// Set up digital pins for issuing commands to the motor controllers.

// x-axis stepper motor 
int DIRX = 3;          // PIN  3 = DIR (direction)
int STEPX = 2;        // PIN  2 = STEP (step the motor: typical resolution 200 steps/360 degrees)
int MS1X = 13;        // PIN 13 = MS
int MS2X = 9;         // PIN  9 = MS2
int SLEEPX = 12;      // PIN 12 = SLP (sleep)

// y-axis stepper motor
int DIRY = 4;          // PIN  4 = DIR
int STEPY = 5;        // PIN  5 = STEP
int MS1Y = 13;        // PIN 13 = MS
int MS2Y = 10;         // PIN  10 = MS2
int SLEEPY = 12;      // PIN 12 = SLP

void setup() {
  Serial.begin(9600);     // open the serial connection at 9600bps

  // here we set all the pins we need to control the 2 motors to OUTPUT
  // since we are going to send commands FROM them, not read data INTO them

  pinMode(DIRX, OUTPUT);   // set pin 3 to output
  pinMode(STEPX, OUTPUT);  // set pin 2 to output
  pinMode(MS1X, OUTPUT);   // set pin 13 to output
  pinMode(MS2X, OUTPUT);   // set pin 9 to output
  pinMode(SLEEPX, OUTPUT); // set pin 12 to output

  pinMode(DIRY, OUTPUT);   // set pin 4 to output
  pinMode(STEPY, OUTPUT);  // set pin 5 to output
  pinMode(MS1Y, OUTPUT);   // set pin 13 to output
  pinMode(MS2Y, OUTPUT);   // set pin 10 to output
  pinMode(SLEEPY, OUTPUT); // set pin 12 to output
}

void loop()
{
  int modeType = 1;                         // This number increases by multiple of 2 each through the while loop..
                                            // ..to identify our step mode type.                                            
  while (modeType<=8){                      // loops the following block of code 4 times before repeating .
    digitalWrite(DIR, LOW);                 // Set the direction change LOW to HIGH to go in opposite direction
    digitalWrite(MS1, MS1_MODE(modeType));  // Set state of MS1 based on the returned value from the MS1_MODE() switch statement.
    digitalWrite(MS2, MS2_MODE(modeType));  // Set state of MS2 based on the returned value from the MS2_MODE() switch statement.
    digitalWrite(SLEEP, HIGH);              // Set the Sleep mode to AWAKE.
    
    int i = 0;                              // Set the counter variable.     
    while(i<(modeType*200))                 // Iterate for 200, then 400, then 800, then 1600 steps. 
                                            // Then reset to 200 and start again.
    {
      digitalWrite(STEP, LOW);              // This LOW to HIGH change is what creates the..
      digitalWrite(STEP, HIGH);             // .."Rising Edge" so the easydriver knows to when to step.
      delayMicroseconds(1600/modeType);     // This delay time determines the speed of the stepper motor. 
                                            // Delay shortens from 1600 to 800 to 400 to 200 then resets  
                                                 
      i++;                      
    }                              
    modeType = modeType * 2;                // Multiply the current modeType value by 2 and make the result the new value for modeType.
                                            // This will make the modeType variable count 1,2,4,8 each time we pass though the while loop.
   
    delay(500);
  }
  digitalWrite(SLEEP, LOW);                 // switch off the power to stepper
  Serial.print("SLEEPING..");
  delay(1000);
  Serial.print("z");
  delay(1000);
  Serial.print("z");
  delay(1000);
  Serial.print("z");
  delay(1000);
  Serial.println("");
  digitalWrite(SLEEP, HIGH);
  Serial.println("AWAKE!!!");                // Switch on the power to stepper
  delay(1000);
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
