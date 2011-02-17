/* Melexis MLX90614 infrared non contact temperature sensor
 *
 * connect MLX90614 pin 1 SCL to Arduino pin analog 5
 * connect MLX90614 pin 2 SDA to Arduino pin analog 4
 * connect MLX90614 pin 3 Vdd to Arduino pin +5V
 * connect MLX90614 pin 4 Vss to Arduino pin GND
 solder 100n capacitor between Vdd and Vss

 * KHM 2010 /  Martin Nawrath
 * Kunsthochschule fuer Medien Koeln
 * Academy of Media Arts Cologne
 */

#include <i2cmaster.h>

char st1[30];

void setup()
{
  Serial.begin(115200);
  Serial.println("Melexis MLX90614 temperature Sensor");

  PORTC = (1 << PORTC4) | (1 << PORTC5);  //enable internal pullup resistors on i2c ports

}
void loop()
{

  long int tpl;

  tpl=readMLXtemperature(0); // read sensor object temperature
  tpl = tpl *10;
  tpl = tpl / 5;
  tpl=tpl-27315;
  sprintf(st1,"object temp: %03li.%li",tpl/100, abs(tpl %100) );
  Serial.print(st1);
  Serial.print("   ");

  tpl=readMLXtemperature(1); // read sensor ambient temperature
  tpl = tpl *10;
  tpl = tpl / 5;
  tpl=tpl-27315;
  sprintf(st1,"ambient temp: %03li.%li",tpl/100, tpl %100 );
  Serial.print(st1);
  Serial.print("   ");
  Serial.println("");
  delay(100);

}
//****************************************************************
// read MLX90614 i2c ambient or object temperature
long int readMLXtemperature(int TaTo) {
    long int lii;
    int dlsb,dmsb,pec;
    int dev = 0x5A<<1;

  i2c_init();
  i2c_start_wait(dev+I2C_WRITE);  // set device address and write mode
  if (TaTo) i2c_write(0x06); else i2c_write(0x07);                // or command read object or ambient temperature

  i2c_rep_start(dev+I2C_READ);    // set device address and read mode
  dlsb = i2c_readAck();       // read data lsb
  dmsb = i2c_readAck();      // read data msb
  pec = i2c_readNak();
  i2c_stop();

  lii=dmsb*0x100+dlsb;
  return(lii);
}
