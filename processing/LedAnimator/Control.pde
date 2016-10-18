

ColorPicker cp;
Println console;

void setupControls() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  int xPos = 15;
  int yPos = 40;
  
  cp5.addTab("playback")
    //.setColorBackground(color(0, 160, 100))
    .setColorLabel(color(255))
    //.setColorActive(color(255,128,0))
    .setWidth(75)
    .setHeight(30)
    .getCaptionLabel().getStyle().setPaddingLeft(12)
    ;
  
  cp5.addTab("calibrate")
    .setColorLabel(color(255))
    .setWidth(77)
    .setHeight(30)
    .getCaptionLabel().getStyle().setPaddingLeft(12)
    ;
    
  cp5.getTab("default").getCaptionLabel().getStyle().setPaddingLeft(18);  
    
  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("Convert")
    .setWidth(76)
    .setHeight(30)
    .setId(1)
    ;
  
  cp5.getTab("playback")
    .activateEvent(true)
    .setId(2)
    ; 
    
  cp5.getTab("calibrate")
    .activateEvent(true)
    .setId(3)
    ;
    
  Textarea helpText1 = cp5.addTextarea("txt")
    .setPosition(xPos,yPos)
    .setSize(200,60)
    //.setFont(createFont("",8))
    //.setLineHeight(15)
    .setColor(color(255))
    //.setColorBackground(color(0))
    //.setColorForeground(color(255,100));
    ;
  helpText1.setText(
    "How to make a led animation file: \n"
    +"1 ;  Open Led layout \n"
    +"2;  Open Movie, Screen capture or Camera \n"
    +"3;  Preview movie and animation \n"
    +"4;  Press Make animation to save file \n"
    );
    
  yPos += helpText1.getHeight(); 
  
  cp5.addButton("openLedLayoutFileButton")
   .setPosition(xPos, yPos)
   .setSize(100,20)
   .setLabel("Open Led Layout File")
   ;
  
  cp5.addButton("openMovieFileButton")
   .setPosition(xPos, yPos+=30)
   .setSize(50,20)
   .setLabel("Movie")
   ;
   
  cp5.addButton("openScreenCaptureButton")
   .setPosition(xPos+70, yPos)
   .setSize(50,20)
   .setLabel("Screen")
   ;
   
  cp5.addButton("openCameraButton")
   .setPosition(xPos+140, yPos)
   .setSize(50,20)
   .setLabel("Camera")
   ;
   
  cp5.addRadioButton("colorSamplingMode")
   .setPosition(xPos,yPos+=35)
   .setSize(15,15)
   //.setColorForeground(color(120))
   //.setColorActive(color(255))
   .setColorLabel(color(255))
   .setItemsPerRow(5)
   .setSpacingColumn(30)
   .addItem("Rect",1)
   .addItem("Point",2)
   .activate(0)
   //.hideLabels()
   .setLabel("Color sampling mode")
   .getCaptionLabel().align(CENTER,CENTER)
   ; 
   
  cp5.addToggle("showSamplingBoundingBox")
    .setPosition(xPos,yPos+=25)
    .setSize(20,20)
    .setValue(showSamplingBoundingBox)
    .setLabel("Show bounding box")
    ;
   
  cp5.addIcon("rewindButtonMovie", 10)
   .setPosition(xPos+3,yPos+=45)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f049,#00f049,#00f049)
   .setScale(0.9,1)
   .setSwitch(false)
   ; 
   
  cp5.addIcon("playButtonMovie", 10)
   .setPosition(xPos+35,yPos)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f01d,#00f01d,#00f01d)
   .setScale(0.9,1)
   .setSwitch(false)
   ;
   
  cp5.addIcon("pauseButtonMovie", 10)
   .setPosition(xPos+65,yPos)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f28c,#00f28c,#00f28c)
   .setScale(0.9,1)
   .setSwitch(false)
   ;
   
  cp5.addBang("makeAnimation")
   .setPosition(xPos, yPos+=30)
   .setSize(100, 20)
   .setTriggerEvent(Bang.RELEASE)
   .setLabel("Make Animation")
   .getCaptionLabel().align(CENTER,CENTER)
   ;
   
   yPos = 40;
   
   // Playback tab
   
   Textarea helpText2 = cp5.addTextarea("txt2")
    .setPosition(xPos,yPos)
    .setSize(200,70)
    .setColor(color(255))
    ;
  helpText2.setText(
    "Play a led animation file: \n"
    +"1 ;  Open Led layout \n"
    +"2;  Open animation (.dat-file) \n"
    +"3;  Preview animation \n"
    +"4;  Press Make Images to save each frame as an image \n"
    );
    
  yPos += helpText2.getHeight(); 
   
   cp5.addButton("openLedLayoutFileButton2")
   .setPosition(xPos, yPos)
   .setSize(100,20)
   .setLabel("Open Led Layout File")
   ;
   
   cp5.addButton("openMovieFileButton2")
   .setPosition(xPos, yPos+=30)
   .setSize(100,20)
   .setLabel("Open Dat File")
   ; 
   
  cp5.addIcon("rewindButtonDat", 10)
   .setPosition(xPos+3,yPos+=30)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f049,#00f049,#00f049)
   .setScale(0.9,1)
   .setSwitch(false)
   ; 
   
  cp5.addIcon("playButtonDat", 10)
   .setPosition(xPos+35,yPos)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f01d,#00f01d,#00f01d)
   .setScale(0.9,1)
   .setSwitch(false)
   ;
   
  cp5.addIcon("pauseButtonDat", 10)
   .setPosition(xPos+65,yPos)
   .setSize(20,20)
   .setFont(fontIcon)
   .setFontIcons(#00f28c,#00f28c,#00f28c)
   .setScale(0.9,1)
   .setSwitch(false)
   ;
   
  cp5.addBang("makeImages")
   .setPosition(xPos, yPos+=30)
   .setSize(100, 20)
   .setTriggerEvent(Bang.RELEASE)
   .setLabel("Make Images")
   .getCaptionLabel().align(CENTER,CENTER)
   ;   
   
  // Calibrate tab
  yPos = 40;
  Textarea helpText3 = cp5.addTextarea("txt3")
    .setPosition(xPos,yPos)
    .setSize(200,60)
    .setColor(color(255))
    ;
  helpText3.setText(
    "Send the led colors to an Arduino through the serial port \n"
    +"1 ;  Select the serial port \n"
    +"     Select a led target and set the color with the color wheel  \n"
    );
    
  yPos += helpText3.getHeight(); 
   
  List l = Arrays.asList(Serial.list());
  cp5.addScrollableList("serialPortDropdown")
   .setPosition(xPos, yPos)
   .setSize(200, ((l.size()+1)*20))
   .setBarHeight(20)
   .setItemHeight(20)
   .addItems(l)
   .setLabel("Select serial port")
   .setType(ScrollableList.DROPDOWN)
  ;
  yPos += cp5.getController("serialPortDropdown").getHeight();
  
  cp5.addToggle("doSendSerial")
    .setPosition(xPos,yPos+=15)
    .setSize(20,20)
    .setValue(false)
    //.setMode(ControlP5.SWITCH)
    .setLabel("Send to serial port")
    ;
  
  cp5.addScrollableList("ledTargetDropdown")
   .setPosition(xPos, yPos+=40)
   .setSize(200, 100)
   .setBarHeight(20)
   .setItemHeight(20)
   //.addItems(l)
   .setLabel("Select led target")
   .setType(ScrollableList.LIST)
  ;
  
  cp = cp5.addColorPicker("colorPicker", 0, 0, 200, 10)
    .setPosition(xPos, yPos+=120)
    .setColorValue(color(255, 255, 255, 255))
    //.setSize(200, 200)
    //.setBarHeight(200)
    //.setBackgroundHeight(200)
    ;
    
    
  // global
  cp5.addNumberbox("frameRateNumberBox")
    .setPosition(xPos, height-150)
    .setSize(100,20)
    .setRange(1,60)
    //.setMultiplier(0.1) // set the sensitifity of the numberbox
    .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
    .setValue(frameRateNumberBox)
    .setLabel("Set FrameRate")
    ;
    
  Textarea consoleText = cp5.addTextarea("consoleText")
    .setPosition(xPos, height-110)
    .setSize(200, 100)
    .setLineHeight(14)
    .setColor(color(0))
    .setColorBackground(color(255))
    ;
    
  console = cp5.addConsole(consoleText);
  console.setMax(10);
  
  helpText2.moveTo("playback");
  cp5.getController("openMovieFileButton2").moveTo("playback");
  cp5.getController("openLedLayoutFileButton2").moveTo("playback");
  cp5.getController("rewindButtonDat").moveTo("playback");
  cp5.getController("playButtonDat").moveTo("playback");
  cp5.getController("pauseButtonDat").moveTo("playback");
  cp5.getController("makeImages").moveTo("playback");
  
  helpText3.moveTo("calibrate");
  cp5.getController("serialPortDropdown").moveTo("calibrate");
  cp5.getController("doSendSerial").moveTo("calibrate");
  cp5.getController("ledTargetDropdown").moveTo("calibrate");
  cp5.get(ControllerGroup.class, "colorPicker").moveTo("calibrate");
  
  cp5.getController("frameRateNumberBox").moveTo("global");
  consoleText.moveTo("global");
  
}

/*
void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id "+theEvent.getId()+" and controller and name "+theEvent.getName());
  
  switch(theEvent.getName()) {
    case("damping"):
      //DAMPING = theEvent.getController().getValue();
      break;
  }
}
*/

void showVideoControls(boolean show) {
  String[] controls = {"rewindButtonMovie", "playButtonMovie", "pauseButtonMovie", "makeAnimation"};
  for(String c : controls) {
    if(show) {
      cp5.getController(c).show();
    }else {
      cp5.getController(c).hide();
    }
  }
}
void showDatControls(boolean show) {
  println("showDatControls: "+show);
  String[] controls = {"rewindButtonDat", "playButtonDat", "pauseButtonDat", "makeImages"};
  for(String c : controls) {
    if(show) {
      cp5.getController(c).show();
    }else {
      cp5.getController(c).hide();
    }
  }
}

void serialPortDropdown(int n) {
  /* request the selected item based on index n */
  //println(n, cp5.get(ScrollableList.class, "serialPortDropdown").getItem(n));
  String portName = Serial.list()[n];
  println("serialPortDropDown: "+portName);
  serialPort = new Serial(this, portName, BAUD_RATE);
}

void setLedTargetDropdown(int nrOfLeds) {
  String[] items = new String[nrOfLeds];
  for(int i=0; i<items.length; i++) {
    items[i] = "Led " + str(i+1);  
  }
  List l = Arrays.asList(items);
  cp5.get(ScrollableList.class, "ledTargetDropdown").addItems(l);
}
void ledTargetDropdown(int n) {
  currentLedTarget = n;
  setColorPickerColor(ledArr[currentLedTarget]);
}

void colorPicker(int pcolor) {
  color c = color(red(pcolor), green(pcolor), blue(pcolor));
  if(ledArr != null && currentLedTarget != -1) {
    ledArr[currentLedTarget] = c;
    setLedShapeColor(currentLedTarget+1, c);
  }
}
void setColorPickerColor(int pcolor) {
  cp.setColorValue(pcolor);
}

void openMovieFileButton2() {
  selectInput("Select a .dat-file", "setMovieFile");  
}
void openMovieFileButton() {
  selectInput("Select a file", "setMovieFile");  
}
void openLedLayoutFileButton2() {
  openLedLayoutFileButton();
}
void openLedLayoutFileButton() {
  selectInput("Select a file", "setLedLayoutFile");  
}
void openScreenCaptureButton() {
  int w = 320;
  int h = 240;
  if(ledLayout != null) {
    w = (int)ledLayout.getWidth();
    h = (int)ledLayout.getHeight();
  }
  setupInputPixels(w, h);
  screenCapture = new ScreenCapture(w, h, frameRate);
  cp5.getController("makeAnimation").show();
}
void openCameraButton() {
  int w = 320;
  int h = 240;
  if(ledLayout != null) {
    w = (int)ledLayout.getWidth();
    h = (int)ledLayout.getHeight();
  }
  setupInputPixels(w, h);
  camera = new Capture(this, w, h);
  camera.start();
  cp5.getController("makeAnimation").show();
}
void colorSamplingMode(int value) {
  colorSamplingMode = value;  
}

void setFrameRate(float value) {
  cp5.getController("frameRateNumberBox").setValue(value);  
}
void frameRateNumberBox(float value) {
  frameRate(value);
}