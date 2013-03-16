int portAnodeA;
int portAnodeB;
int portAnodeC;
int portAnodeD;
int portAnodeE;
int portAnodeF;
int portAnodeG;

void setupDisplayPorts(
    int a, int b, int c, int d, int e, int f, int g)
{
  portAnodeA = a;
  portAnodeB = b;
  portAnodeC = c;
  portAnodeD = d;
  portAnodeE = e;
  portAnodeF = f;
  portAnodeG = g;
  pinMode(portAnodeA, OUTPUT);
  pinMode(portAnodeB, OUTPUT);
  pinMode(portAnodeC, OUTPUT);
  pinMode(portAnodeD, OUTPUT);
  pinMode(portAnodeE, OUTPUT);
  pinMode(portAnodeF, OUTPUT);
  pinMode(portAnodeG, OUTPUT);
}

void clearDisplay()
{
  digitalWrite(portAnodeA, LOW); 
  digitalWrite(portAnodeB, LOW); 
  digitalWrite(portAnodeC, LOW); 
  digitalWrite(portAnodeD, LOW); 
  digitalWrite(portAnodeE, LOW); 
  digitalWrite(portAnodeF, LOW); 
  digitalWrite(portAnodeG, LOW); 
}

void printNumber(int number)
{
  if (number < 0 || number > 10) return;
  
  clearDisplay();
  switch(number)
  {
    case 0:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeE, HIGH);
      digitalWrite(portAnodeF, HIGH);
      break;
    case 1:
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      break;
    case 2:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeE, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
    case 3:      
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
    case 4:
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeF, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
    case 5:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeF, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
    case 6:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeE, HIGH);
      digitalWrite(portAnodeF, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
    case 7:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      break;
    case 8:
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeE, HIGH);
      digitalWrite(portAnodeF, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
   case 9:      
      digitalWrite(portAnodeA, HIGH);
      digitalWrite(portAnodeB, HIGH);
      digitalWrite(portAnodeC, HIGH);
      digitalWrite(portAnodeD, HIGH);
      digitalWrite(portAnodeF, HIGH);
      digitalWrite(portAnodeG, HIGH);
      break;
  }
}
