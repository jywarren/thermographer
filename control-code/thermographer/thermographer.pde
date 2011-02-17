/////////////////////////////////////////////////
// Thermographer control code - Public Laboratory
/////////////////////////////////////////////////

// http://publiclaboratory.org/tool/thermographer
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

//                                            pin - first ribbon - second ribbon
// connect MLX90614 pin 1 SCL to Arduino pin analog 5 - green - green
// connect MLX90614 pin 2 SDA to Arduino pin analog 4 - blue - black
// connect MLX90614 pin 3 Vdd to Arduino pin +5V - purple - red
// connect MLX90614 pin 4 Vss to Arduino pin GND - grey - white
// solder 100n capacitor between Vdd and Vss

// Melexis code based on example by:
// KHM 2010 /  Martin Nawrath
// Kunsthochschule fuer Medien Koeln
// Academy of Media Arts Cologne
// http://interface.khm.de/index.php/lab/experiments/infrared-thermometer-mlx90614/

#include <i2cmaster.h>

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
//  float stepperdeg = 0.55*modeType*40;     // steps, half steps, quarter or microsteps per degree
  float stepperdeg = 0.55*modeType*40;     // steps, half steps, quarter or microsteps per degree
  int degx = 16;          // degrees of field of view in x
  int degy = 12;          // degrees of field of view in y
  int degperpixel = 3;  // how many degrees wide each pixel should be 
                          // (based on how narrow the beam is focused)
  int lineheight = 1;
  
  //String imagestring = String(100);
  //char imagecol[480];
  char reading[100];
  
  int trigger = 0;
  
//  I am using a Duemilanove, so I changed the twimaster.c to reflect the 16MHz clock, and changed the bus frequency to 50Khz: 
//
//#ifndef F_CPU 
//#define F_CPU 16000000UL 
//#endif 
//
///* I2C clock in Hz */ 
//#define SCL_CLOCK 50000L 

//  This simple code uses Peter Fleurys libray here: 
//  http://homepage.hispeed.ch/peterfleury/ ... tware.html 
//  Scroll down and download the i2c master libraries. 
//  Create a folder in /{arduino root}/hardware/libraries and copy the 
//  i2cmaster.h and twimaster.c, renaming the .c file to .cpp 


void setup() {
  
  Serial.begin(9600);     // open the serial connection at 9600bps
//  Serial.begin(115200);     // open the serial connection at 9600bps
  Serial.println("Beginning setup");

  PORTC = (1 << PORTC4) | (1 << PORTC5);  //enable internal pullup resistors on i2c ports (for the melexis)

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
  Serial.println("Ending setup");
}

void loop()
{
//  if (digitalRead(0) == HIGH) { // Only start imaging when you press the big button (not working)
  trigger = 1;
//  }
//  Serial.print("trigger: ");
//  Serial.println(trigger);

  Serial.println("Beginning loop");

  
  if (trigger == 1) {
    digitalWrite(MS1X, MS1_MODE(modeType));  // Set state of MS1 based on the returned value from the MS1_MODE() switch statement.
    digitalWrite(MS2X, MS2_MODE(modeType));  // Set state of MS2 based on the returned value from the MS2_MODE() switch statement.
    digitalWrite(SLEEPX, HIGH);              // Set the Sleep mode to AWAKE.

    digitalWrite(MS1Y, MS1_MODE(modeType));  // Set state of MS1 based on the returned value from the MS1_MODE() switch statement.
    digitalWrite(MS2Y, MS2_MODE(modeType));  // Set state of MS2 based on the returned value from the MS2_MODE() switch statement.
    digitalWrite(SLEEPY, HIGH);              // Set the Sleep mode to AWAKE.
  
    int stepx = 0;                              // Set the counter variable.     
    Serial.print("image size: ");
    Serial.print(stepperdeg*degx);
    Serial.print(" x ");
    Serial.println(stepperdeg*degy);

    while(stepx<(int)(stepperdeg*degx)) {

      Serial.print("Starting horizontal sweep ");
      Serial.println(stepx);
      move_x();
        
      //imagestring = String("/");
      //imagestring += "/";
//      reading += '/';

      int stepy = 0;                              // Set the counter variable.     
      while(stepy<(int)(stepperdeg*degy)) {
//        Serial.print("Starting vertical sweep ");
//          Serial.println(stepy);
        move_y();
  
        // Thermometer section:
        long int tpl;
  
        tpl=readMLXtemperature(0); // read sensor object temperature
        tpl = tpl *10;
        tpl = tpl / 5;
        tpl=tpl-27315;

        //sprintf(st1,"object temp: %03li.%li",tpl/100, abs(tpl %100) );
        sprintf(reading,"%03li.%li,",tpl/100, abs(tpl %100) );
        Serial.print(reading); // print one row of data

        stepy += 1;
      }                              
  
//      Serial.println(reading);
//      reading = '>';
        
      if (diry == 0) {
        digitalWrite(DIRY, LOW);                 // Set the direction change LOW to HIGH to go in opposite direction
        diry = 1;
      } else {
        digitalWrite(DIRY, HIGH);
        diry = 0;
      }
  
      stepx += 1;
    }                              
  
    //modeType = modeType * 2;                // Multiply the current modeType value by 2 and make the result the new value for modeType.
                                              // This will make the modeType variable count 1,2,4,8 each time we pass though the while loop.
     
    digitalWrite(SLEEPX, LOW);                 // switch off the power to stepper
    digitalWrite(SLEEPY, LOW);                 // switch off the power to stepper
  
  }
  
}


//
// A function which writes the temperature in degrees
// ( in C or F depending on configuration at the top)
// to the serial monitor (for debugging), types it as
// a USB keyboard (for camera setups with no flash memory
// to record to) or stores it on an SD card in a text file.
//
int write_image(float temp) {

  // For now we'll just write to serial monitor. Later we will implement other storage techniques.
  Serial.print(",");
  Serial.print(temp);
  
}

int move_x() {
      int i = lineheight;
      while (i > 0) {
        digitalWrite(STEPX, LOW);              // This LOW to HIGH change is what creates the..
        digitalWrite(STEPX, HIGH);             // .."Rising Edge" so the easydriver knows to when to step.
        delayMicroseconds(1600/modeType);      // This delay time determines the speed of the stepper motor. 
        i--;
      } 
}

int move_y() {
      int i = lineheight;
      while (i > 0) {
        digitalWrite(STEPY, LOW);              // This LOW to HIGH change is what creates the..
        digitalWrite(STEPY, HIGH);             // .."Rising Edge" so the easydriver knows to when to step.
        delayMicroseconds(1600/modeType);      // This delay time determines the speed of the stepper motor. 
        i--;
      } 
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
    Serial.println("Step Mode is .. Eighth...");
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

//****************************************************************
// read MLX90614 i2c ambient or object temperature
long int readMLXtemperature(int TaTo) {
    long int lii;
    int dlsb,dmsb,pec;
    int dev = 0x5A<<1;

  i2c_init();
  int connect;
  connect = i2c_start(dev+I2C_WRITE);  // set device address and write mode
//  Serial.print("connect:");
//  Serial.println(connect);
//  if (connect == 1) {
//    Serial.print("start,");
    if (TaTo) i2c_write(0x06); else i2c_write(0x07);                // or command read object or ambient temperature
//    Serial.print("write,");
    i2c_rep_start(dev+I2C_READ);    // set device address and read mode
//    Serial.print("repstart,");
    dlsb = i2c_readAck();       // read data lsb
//    Serial.print("readAck1,");
    dmsb = i2c_readAck();      // read data msb
//    Serial.print("readAck2,");
    pec = i2c_readNak();
//    Serial.print("readNak,");
    i2c_stop();
//    Serial.print("stop,");

    lii=dmsb*0x100+dlsb;
    return(lii);
//  } else {
//    return (0);
//  }
}

