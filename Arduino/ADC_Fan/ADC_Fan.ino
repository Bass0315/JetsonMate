int analogPin[] = {14, 15, 16, 17, 18, 19};  //A0(1V8), A1(2V5), A2(1V2), A3(3V3), A4(5 V), A5(12V)

unsigned char FanCtrlPin_Tach_mini = 7;
unsigned char FanCtrlPin_Pwm_mini = 6;
unsigned char FanCtrlPin_Tach_big = 5;
unsigned char FanCtrlPin_Pwm_big = 3;
/*
  enum ADC
  {
      1V8=0, 2V5, 1V2, 3V3, 5 V, 12V
  } analogADC;
*/

void ADC_Power(void)
{
  int val = 0;
  char buf[20];
  float analogValue = 0;

  for (unsigned char i = 0; i < 6; i++)
  {
    for (unsigned char j = 0; j < 5; j++) //if j=10,
    {
      val += analogRead(analogPin[i]);
    }
    analogValue = val / 5 / 1023.0 * 3.3 * (1.8 / 0.3);
    Serial.print(analogValue);
    switch (i)
    {
      case 0:
        {
          if (1.8 - 1.8 * 0.05 < analogValue && analogValue < 1.8 + 1.8 * 0.05)
          {
            Serial.println("   1V8 OK");
          }
          else
          {
            Serial.println("   1V8 Error");
          }
          break;
        }
      case 1:
        {
          if (2.5 - 2.5 * 0.05 < analogValue && analogValue < 2.5 + 2.5 * 0.05)
          {
            Serial.println("   2V5 OK");
          }
          else
          {
            Serial.println("   2V5 Error");
          }
          break;
        }
      case 2:
        {
          if (1.2 - 1.2 * 0.05 < analogValue && analogValue < 1.2 + 1.2 * 0.05)
          {
            Serial.println("   1V2 OK");
          }
          else
          {
            Serial.println("   1V2 Error");
          }
          break;
        }
      case 3:
        {
          if (3.3 - 3.3 * 0.05 < analogValue && analogValue < 3.3 + 3.3 * 0.05)
          {
            Serial.println("   3V3 OK");
          }
          else
          {
            Serial.println("   3V3 Error");
          }
          break;
        }
      case 4:
        {
          if (5 - 5 * 0.05 < analogValue && analogValue < 5 + 5 * 0.05)
          {
            Serial.println("   5 V OK");
          }
          else
          {
            Serial.println("   5 V Error");
          }
          break;
        }
      case 5:
        {
          if (12 - 12 * 0.05 < analogValue && analogValue < 12 + 12 * 0.05)
          {
            Serial.println("  12V OK");
          }
          else
          {
            Serial.println("  12V Error");
          }
          break;
        }

    }
    //    sprintf(buf, "A%d: %f", i, analogValue);
    //    Serial.println(buf);          // debug value
    val = 0;
    delay(20);
  }
  Serial.println();
}


void Fan_mini(void)
{
  digitalWrite(FanCtrlPin_Tach_mini, HIGH);
  digitalWrite(FanCtrlPin_Pwm_mini, HIGH);
  digitalWrite(FanCtrlPin_Tach_big, LOW);
  digitalWrite(FanCtrlPin_Pwm_big, LOW);
}

void Fan_big(void)
{
  digitalWrite(FanCtrlPin_Tach_mini, LOW);
  digitalWrite(FanCtrlPin_Pwm_mini, LOW);
  digitalWrite(FanCtrlPin_Tach_big, HIGH);
  digitalWrite(FanCtrlPin_Pwm_big, HIGH);
}

void setup()
{
  Serial.begin(115200);           //  setup serial

  pinMode(FanCtrlPin_Tach_mini, OUTPUT);
  pinMode(FanCtrlPin_Pwm_mini, OUTPUT);

  pinMode(FanCtrlPin_Tach_big, OUTPUT);
  pinMode(FanCtrlPin_Pwm_big, OUTPUT);

  digitalWrite(FanCtrlPin_Tach_mini, HIGH);
  digitalWrite(FanCtrlPin_Pwm_mini, HIGH);
  digitalWrite(FanCtrlPin_Tach_big, LOW);
  digitalWrite(FanCtrlPin_Pwm_big, LOW);
}

String rec_string = "";

void loop()
{
  //recive commamd
  while (Serial.available() > 0)
  {
    rec_string += char(Serial.read());
    delay(2);
  }

  //funtion
  if (rec_string.length() > 0)
  {
    //Serial.println(rec_string);
    //Serial.println(strcmp(rec_string.c_str(), "ADC_Power\n"));  //debug
    if (strcmp(rec_string.c_str(), "ADC_Power\n") == 0)
    {
      ADC_Power();
    }

    if (strcmp(rec_string.c_str(), "Fan_big\n") == 0)
    {
      Fan_big();
    }

    if (strcmp(rec_string.c_str(), "Fan_mini\n") == 0)
    {
      Fan_mini();
    }
    rec_string = "";
  }
}
