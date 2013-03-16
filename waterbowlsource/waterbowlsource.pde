//Water Bowl Auto-Filler
//By: Nate Hodge
//Date: 11-9-11
//
//Note: The project design was taken from http://www.avbrand.com/projects/dogdish/code.asp

// Pin identifications
#define PIN_LOW_SENSOR 5    // The sensor at the bottom of the dish
#define PIN_HIGH_SENSOR 9   // The sensor at the top of the dish
#define PIN_WATER_FLOW 12   // The irrigation valve that regulates water flow - with a positive voltage, the water will flow
#define PIN_BUZZER 6        // The buzzer that gives an audible notification to the user
#define PIN_SENSOR_POWER 8  // The power for the water sensors - is only turned on for brief periods to prevent corrosion
#define PIN_LED 13          // The default LED pin on the board

//state machine
enum WaterBowlState
{
  WaterInBowl,
  NoWaterDetected,
  FillingBowl,
  ErrorDetected
};

WaterBowlState bowlState = WaterInBowl;

#define SENSOR_READING_COUNT 10
byte lowSensorReadings[SENSOR_READING_COUNT];
byte highSensorReadings[SENSOR_READING_COUNT];
int currentReadingIndex = 0;

byte currentLowReading = 0;
byte currentHighReading = 0;

//standard startup method
void setup() 
{                
  //setup the pin modes
  pinMode(PIN_LED, OUTPUT);     
  pinMode(PIN_LOW_SENSOR, INPUT);
  pinMode(PIN_HIGH_SENSOR, INPUT);
  pinMode(PIN_WATER_FLOW, OUTPUT);
  pinMode(PIN_BUZZER, OUTPUT);
  pinMode(PIN_SENSOR_POWER, OUTPUT);
  
  //just double-check that the important ports are turned off
  digitalWrite(PIN_WATER_FLOW, LOW);
  digitalWrite(PIN_SENSOR_POWER, LOW);
  
  //startup sound
  buzz(230);
  buzz(270);
  buzz(320);
  
  //start with assuming that water is in the bowl and waiting until it is empty
  bowlState = WaterInBowl;
  
  resetReadings();
  
  //serial port is opened for debugging
  Serial.begin(9600);
}

//this method is called consecutively as quickly as possible by the board
void loop()
{
  boolean newReadings = updateSensors();
  
  switch (bowlState)
  {
    case WaterInBowl:
    {
      Serial.println("Water in bowl.");
      if (newReadings && currentLowReading == 0)
      {
        bowlState = NoWaterDetected;
        resetReadings();
      }
    } break;
    case NoWaterDetected:
    {
      Serial.println("No water detected.");
      if (newReadings)
      {
        if (currentLowReading == 0)
        {
          //verified - proceed to filling bowl
          bowlState = FillingBowl; 
        }
        else
        {
          //we had a false positive
          bowlState = WaterInBowl;
        }
      }
    } break;
    case FillingBowl:
    {
      Serial.println("Filling bowl.");
      
      // Alert that we have entered this state via buzzer.
      buzz(230);
      delay(200);
      buzz(230);
      
      if (fillWater())
      {
        bowlState = WaterInBowl;
      }
      else
      {
        bowlState = ErrorDetected;
      }
    } break;
    default: //the default should fall into the error case, since it's an unrecognized state
    case ErrorDetected:
    {
      Serial.println("Error detected.");
      
      //just in case - since we're in this state, make sure we're not spilling water or ruining our sensors
      digitalWrite(PIN_WATER_FLOW, LOW);
      digitalWrite(PIN_SENSOR_POWER, LOW);
  
      do
      {
        buzz(230);
        buzz(270);
      } while(true);
    } break;
  }
  
  //wait 10 seconds between each reading
  delay(10000);
}

//this method fills the water bowl
//returns true if it successfully filled the bowl
boolean fillWater()
{
  boolean fillSuccess = true;
  unsigned long shutoffTimer = millis();
  
  digitalWrite(PIN_WATER_FLOW, HIGH);

  Serial.println("Monitoring water levels.");
  do 
  {
    delay(20);
    updateSensors();
    
    
    if (millis() - shutoffTimer > 35000 || millis() < shutoffTimer) 
    {
      Serial.println("Water should be full by now. Detection failure.");
          
      fillSuccess = false;
      break;  
    }  
  } while (currentHighReading == 0);
   
  //stop the water flow!
  digitalWrite(PIN_WATER_FLOW, LOW);
      
  Serial.println("Fill level reached.");
  buzz(230);
  buzz(270);
  
  return fillSuccess;
}

//this method reads the water sensors
//returns true if it updated the current values for the sensors
boolean updateSensors()
{
  boolean updatedSensors = false;
  
  digitalWrite(PIN_SENSOR_POWER, HIGH);
  delay(1);
  
  byte readingLow = digitalRead(PIN_LOW_SENSOR);
  byte readingHigh = digitalRead(PIN_HIGH_SENSOR);
  
  //the sensors should only be on for brief periods to prevent corrosion
  digitalWrite(PIN_SENSOR_POWER, LOW);
  
  lowSensorReadings[currentReadingIndex] = readingLow;
  highSensorReadings[currentReadingIndex] = readingHigh;
  
  ++currentReadingIndex;
  if (currentReadingIndex >= SENSOR_READING_COUNT)
  {
    boolean allSame = true;
    for(int i = 0; i < SENSOR_READING_COUNT; ++i)
    {
       if (lowSensorReadings[i] != lowSensorReadings[0])
       {
         allSame = false;
         break; 
       }
    }
    
    if (allSame)
    {
      currentLowReading = lowSensorReadings[0];
      updatedSensors = true; 
    }
    
    allSame = true;
    for(int i = 0; i < SENSOR_READING_COUNT; ++i)
    {
       if (highSensorReadings[i] != highSensorReadings[0])
       {
         allSame = false;
         break; 
       }
    }
    
    if (allSame)
    {
      currentHighReading = highSensorReadings[0];
      updatedSensors = true; 
    }
  }
  
  return updatedSensors;
}

void resetReadings()
{
  currentReadingIndex = 0;
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
