#include <SoftwareSerial.h>

#define SERIALCODE_START      50
#define SERIALCODE_SELECT     51
#define SERIALCODE_DPAD_UP    52
#define SERIALCODE_DPAD_DOWN  53
#define SERIALCODE_DPAD_LEFT  54
#define SERIALCODE_DPAD_RIGHT 55
#define SERIALCODE_A          56
#define SERIALCODE_B          57
#define SERIALCODE_X          58
#define SERIALCODE_Y          59
#define SERIALCODE_L          60
#define SERIALCODE_R          61
#define SERIALCODE_ZL         62
#define SERIALCODE_ZR         63

#define APORT_START      9
#define APORT_SELECT     10
#define APORT_DPAD_UP    11
#define APORT_DPAD_DOWN  12
#define APORT_DPAD_LEFT  13
#define APORT_DPAD_RIGHT 14
#define APORT_A          2
#define APORT_B          3
#define APORT_X          5
#define APORT_Y          6
#define APORT_L          16
#define APORT_R          7
#define APORT_ZL         17
#define APORT_ZR         8

 
#define ON HIGH;
#define OFF LOW;

boolean stringComplete = false;
char inputPacket[3];
int packetChunkCounter = 0;
int buttonArray[14][2] = 
  {{SERIALCODE_START, APORT_START},
   {SERIALCODE_SELECT, APORT_SELECT},
   {SERIALCODE_DPAD_UP, APORT_DPAD_UP},
   {SERIALCODE_DPAD_DOWN, APORT_DPAD_DOWN},
   {SERIALCODE_DPAD_LEFT, APORT_DPAD_LEFT},
   {SERIALCODE_DPAD_RIGHT, APORT_DPAD_RIGHT},
   {SERIALCODE_A, APORT_A},
   {SERIALCODE_B, APORT_B},
   {SERIALCODE_X, APORT_X},
   {SERIALCODE_Y, APORT_Y},
   {SERIALCODE_L, APORT_L},
   {SERIALCODE_R, APORT_R},
   {SERIALCODE_ZL, APORT_ZL},
   {SERIALCODE_ZR, APORT_ZR}};

// the setup function runs once when you press reset or power the board
void setup() {
  Serial.begin(28800);  
  
  initPorts();
}
// the loop function runs over and over again forever
void loop() {
  // Check for completed data packet
  if(stringComplete){
    //Serial.write(inputPacket[0]); // Send recieved serial data back out
    digitalWrite(returnPort(inputPacket[0]), inputPacket[1]);
    stringComplete = false; // Done with this information packet
  }
}

// Wait for 3 bytes comprising of command to send to WUPC
// First byte: Contact to press
// Second byte: State to put contact in (pressed/depressed)
// '\n' char to indicate end of information packet
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inputByte = (char)Serial.read();
    // add it to the inputPacket:
    inputPacket[packetChunkCounter] = inputByte;
    ++packetChunkCounter;
    
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inputByte == '\n' && packetChunkCounter == 3) { // End of packet. Flag stringComplete
      stringComplete = true;
      packetChunkCounter = 0;
    }
    else if ((inputByte == '\n' && packetChunkCounter != 3) || packetChunkCounter > 3){ // Invalid states
      inputPacket[0] = -1;
      stringComplete = true;
      packetChunkCounter = 0;
    }
  }
}

int returnPort(int buttonCode){
  for(int i = 0; i < sizeof(buttonArray)/(2*sizeof(buttonArray[0][0])); i++){
    if(buttonArray[i][0] == buttonCode) return buttonArray[i][1];
  }
}

int returnButtonCode(int buttonPort){
  for(int i = 0; i < sizeof(buttonArray)/(2*sizeof(buttonArray[0][0])); i++){
    if(buttonArray[i][1] == buttonPort) return buttonArray[i][0];
  }
}

void initPorts(){
  for(int i = 0; i < sizeof(buttonArray)/(2*sizeof(buttonArray[0][0])); i++){
    pinMode(buttonArray[i][1], OUTPUT);
    digitalWrite(buttonArray[i][1], LOW);
  }
}

