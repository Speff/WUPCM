import processing.serial.*;

// Global serial interface
Serial myPort;

// Constants used to communicate WUPCM button contact codes
// Synchronized with WUPCM Arduino firmware codes
static final int SERIALCODE_START = 50;
static final int SERIALCODE_SELECT = 51;
static final int SERIALCODE_DPAD_UP = 52;
static final int SERIALCODE_DPAD_DOWN = 53;
static final int SERIALCODE_DPAD_LEFT = 54;
static final int SERIALCODE_DPAD_RIGHT = 55;
static final int SERIALCODE_A = 56;
static final int SERIALCODE_B = 57;
static final int SERIALCODE_X = 58;
static final int SERIALCODE_Y = 59;
static final int SERIALCODE_L = 60;
static final int SERIALCODE_R = 61;
static final int SERIALCODE_ZL = 62;
static final int SERIALCODE_ZR = 63;

String[] buttonString = {"SERIALCODE_START", "SERIALCODE_SELECT", "SERIALCODE_DPAD_UP", "SERIALCODE_DPAD_DOWN", "SERIALCODE_DPAD_LEFT", "SERIALCODE_DPAD_RIGHT", "SERIALCODE_A", "SERIALCODE_B", "SERIALCODE_X", "SERIALCODE_Y", "SERIALCODE_L", "SERIALCODE_R", "SERIALCODE_ZL", "SERIALCODE_ZR"};
int[] buttonCode = {SERIALCODE_START, SERIALCODE_SELECT, SERIALCODE_DPAD_UP, SERIALCODE_DPAD_DOWN, SERIALCODE_DPAD_LEFT, SERIALCODE_DPAD_RIGHT, SERIALCODE_A, SERIALCODE_B, SERIALCODE_X, SERIALCODE_Y, SERIALCODE_L, SERIALCODE_R, SERIALCODE_ZL, SERIALCODE_ZR};
boolean[] buttonState = {false, false, false, false, false, false, false, false, false, false, false, false, false, false};
char[] buttonKeys = {'1', '2', '3', '4', '5', '6', 'a', 'b', 'x', 'y', 'l', 'r', 'q', 'e'}; 

// 1 = Pressed. 0 = Depressed 
static final int BUTTON_DOWN = 1;
static final int BUTTON_UP = 0;

// setup Function
// Run once upon startup. Used to initialize serial port.
// Notes:
// --- Check console output to select the WUPCM com port
// ---- Adjust the second argument in the myPort intialization accordingly
// --- 2 second delay is necessary to give the serial port to initialize properly
void setup(){
  size(250, 220);
  background(0);
  
  printArray(Serial.list()); // List all the available serial ports
  myPort = new Serial(this, Serial.list()[0], 28800); // Opens port
  
  // Used if recieving serial information
  //myPort.buffer(1); // 1 byte until serialEvent is tripped
  
  delay(2000); // Wait 2 seconds for serial interface to initialize
}

// draw Function
// Main function looping indefinitely
void draw(){
  // Button communication done through UI code.
  // Example code on sending a button manually (following 3 lines)
  // sendButton(SERIALCODE_START, BUTTON_DOWN);
  // delay(100);
  // sendButton(SERIALCODE_START, BUTTON_UP);
  //sendButton(SERIALCODE_ZR, BUTTON_DOWN);
  //delay(500);
  //sendButton(SERIALCODE_ZR, BUTTON_UP);
  //delay(500);
  drawText();
}

// sendButton Function
// Called to send information via serial interface to WUPCM
// Globals:
// --- Serial myPort: Serial interface set to COM port corresponding to WUPCM
// Inputs:
// --- int button: Serial code corresponding to button
// --- int state: Desired button state
// Returns: None
void sendButton(int button, int state){
  // 3 byte packet of information to send to controller
  myPort.write(button); // Contact to press
  myPort.write(state); // 1 = Pressed. 0 = Depressed 
  myPort.write('\n'); // Termination byte
  
  // Code for UI - Toggles global button state
  for(int i = 0; i < buttonCode.length; i++)
    if(buttonCode[i] == button) buttonState[i] = !buttonState[i];
}

// --------------------------------------------------------------------------
// Everything below is UI stuff.
// Uncommented because it doesn't need to be analyzed

void drawText(){
  background(0);
  
  for(int i = 0; i < buttonString.length; i++){
    if(buttonState[i]){
      fill(200);
      text("(" + buttonKeys[i] + ") " + buttonString[i], 10, 15*i+15);
    }
    else{
      fill(75);
      text("(" + buttonKeys[i] + ") " + buttonString[i], 10, 15*i+15);
    }
  }
}

void keyPressed(){ 
  for(int i = 0; i < buttonKeys.length; i++){
    if(key == buttonKeys[i]){
      sendButton(buttonCode[i], BUTTON_DOWN); 
      buttonState[i] = true;
    }
  }   
}

void keyReleased() {
  for(int i = 0; i < buttonKeys.length; i++){
    if(key == buttonKeys[i]){
      sendButton(buttonCode[i], BUTTON_UP); 
      buttonState[i] = false;
    }
  }  
}
