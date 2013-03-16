//Food Bowl Auto-Filler
//By: Nate Hodge
//Date: 11-9-11

#include <Servo.h>

// Pin identifications
#define PIN_SERVO 3         // The servo that that distributes the food
#define PIN_BUZZER 6        // The buzzer that gives an audible notification to the user
#define PIN_LED 13          // The default LED pin on the board

//servo positions
#define SERVO_POS_FILL 155  // The position at which the hopper is filled with food (the ready position)
#define SERVO_POS_POUR 20   // The position at which the hopper pours its contents into the bowl
Servo hopperServo;

#define MINUTES_BETWEEN_POURS 720 //12 hours
int minutesUntilPour = 1; //pour one minute after the program starts

//standard setup method
void setup()
{
  //setup the pin modes
  pinMode(PIN_LED, OUTPUT);     
  pinMode(PIN_BUZZER, OUTPUT);
  
  hopperServo.attach(PIN_SERVO);
  hopperServo.write(SERVO_POS_FILL);
  
  //startup sound
  buzz(230);
  buzz(270);
  buzz(320);
  
  //serial port is opened for debugging
  Serial.begin(9600);
}

//standard loop
void loop()
{
  Serial.println(minutesUntilPour);
  
  if (minutesUntilPour <= 0)
  {
    pourFood();
    minutesUntilPour = MINUTES_BETWEEN_POURS;
  }
  else
  {
    --minutesUntilPour; 
  }
  
  //wait a minute
  delay(60000); 
}

//this method actually pours the food
void pourFood()
{
  // Alert that we have entered this state via buzzer.
  buzz(230);
  delay(200);
  buzz(230);
  
  hopperServo.write(SERVO_POS_POUR);
  delay(1000);
  hopperServo.write(SERVO_POS_FILL);
}

void buzz(long nFreq)
{
  for (long i = 0; i < 1000; i++ )
  {
    // 1 / 2048Hz = 488uS, or 244uS high and 244uS low to create 50% duty cycle
    digitalWrite(PIN_BUZZER, HIGH);
    delayMicroseconds(nFreq);
    digitalWrite(PIN_BUZZER, LOW);
    delayMicroseconds(nFreq);
  }
}
