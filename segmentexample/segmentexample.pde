void setup()
{
  setupDisplayPorts(2, 3, 4, 5, 6, 7, 8);
}

void loop()
{
  for(int i=0; i<10; ++i)
 {
    printNumber(i);
    delay(1000);
 } 
 clearDisplay();
 delay(1000);
}
