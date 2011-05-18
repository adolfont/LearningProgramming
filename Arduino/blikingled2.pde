/* Blinking LED
 * ------------
 *
 * turns on and off a light emitting diode(LED) connected to a digital  
 * pin, in intervals of 2 seconds. Ideally we use pin 13 on the Arduino 
 * board because it has a resistor attached to it, needing only an LED

 *
 * Created 1 June 2005
 * copyleft 2005 DojoDave <http://www.0j0.org>
 * http://arduino.berlios.de
 *
 * based on an orginal by H. Barragan for the Wiring i/o board
 * 
 * Modified by Adolfo Neto in 18-05-2011 such that works with 2 leds.
 */

int ledPin = 12;                 // LED connected to digital pin 12
int ledPin2 = 13;                 // LED connected to digital pin 13

void setup()
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
}

void loop()
{
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
  digitalWrite(ledPin, HIGH);   // sets the LED on
  delay(1000);                  // waits for a second
  digitalWrite(ledPin, LOW);    // sets the LED off
  delay(1000);                  // waits for a second
  pinMode(ledPin2, OUTPUT);      // sets the digital pin as output
  digitalWrite(ledPin2, HIGH);   // sets the LED on
  delay(1000);                  // waits for a second
  digitalWrite(ledPin2, LOW);    // sets the LED off
  delay(1000);                  // waits for a second
}
