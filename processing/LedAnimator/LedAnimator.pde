
import java.util.*;
import java.lang.reflect.InvocationTargetException;

import processing.video.*;
import controlP5.*;
import processing.serial.*;

import screenCapture.*;

public static final int BAUD_RATE = 57600;
public static final char HEADER    = 'H';

public static final int RECT = 1;
public static final int POINT = 2;

PFont fontIcon;

Serial serialPort;
boolean doSendSerial = false;

Movie movie;
String movieFileName;
float movieFrameRate;

ScreenCapture screenCapture;
Capture camera;


int[] inputPixels;
int inputImageWidth, inputImageHeight;
float inputImageX, inputImageY;
int colorSamplingMode = RECT;

PShape ledLayout;
float ledLayoutX, ledLayoutY;
int nrOfLeds;
int[] ledArr;
int currentLedTarget = -1;
PGraphics imageOutput;

ControlP5 cp5;
boolean showHelp = true;
int helpAreaWidth = 240;

InputStream reader;
byte[] readerBuffer;
OutputStream output;
byte[] outputBuffer = new byte[3];
boolean doRecordToFile = false;
boolean playFile = false;
String datFileName;
boolean doSaveImagesToFile = false;
String outputFolderName, outputFileName;


float frameRateNumberBox = 30.0f;

void setup() {
  size(880, 600);
  //pixelDensity(displayDensity());
  surface.setResizable(true);
  background(255);
  
  //frameRate(frameRateNumberBox);
  
  // http://fontawesome.io/
  fontIcon = createFont("fontawesome-webfont.ttf", 20);
  setupControls();
  showVideoControls(false);
  showDatControls(false);
}


void draw() {
  background(255);
  
  drawVideo();
  
  drawLedLayout();
  
  showLedColors();
  
  sendColorsToSerialPort();
  
  drawHelp();
}

void drawVideo() {
  if(movie != null) {
    image(movie, ((width-helpAreaWidth)*0.5-movie.width*0.5)+helpAreaWidth, height*0.5-movie.height*0.5);
  }else if(screenCapture != null && screenCapture.getImage() != null) {
    screenCapture.getImage().loadPixels();
    arrayCopy(screenCapture.getImage().pixels, inputPixels);
    screenCapture.getImage().updatePixels();
    image(screenCapture.getImage(), ((width-helpAreaWidth)*0.5-screenCapture.getWidth()*0.5)+helpAreaWidth, height*0.5-screenCapture.getHeight()*0.5);
  }else if(camera != null) {
    image(camera, ((width-helpAreaWidth)*0.5-camera.width*0.5)+helpAreaWidth, height*0.5-camera.height*0.5);  
  }
}

void drawLedLayout() {
  if(ledLayout != null) {
    noFill();
    noStroke();
    ledLayoutX = ((width-helpAreaWidth)*0.5-ledLayout.getWidth()*0.5)+helpAreaWidth;
    ledLayoutY = height*0.5-ledLayout.getHeight()*0.5;
    shape(ledLayout, ledLayoutX, ledLayoutY);
  }
}

void showLedColors() {
  if((!isImageInputLoaded() && reader == null) && ledLayout == null) {return;};
  
  if(isImageInputLoaded()) {
    sampleColorsForLeds();
  }
  
  if(doRecordToFile) {
    saveColorsToFile();
    if(hasVideoEnded()) {
      stopFileOutput();
      doRecordToFile = false;
      rewindButtonMovie();
    }
  }else if(playFile && reader != null) {
    readFile();
    if(doSaveImagesToFile) {
      imageOutput.beginDraw();
      imageOutput.background(0);
      imageOutput.shape(ledLayout, 0, 0, imageOutput.width, imageOutput.height);
      imageOutput.endDraw();
      String fileName = getFolderName()+File.separator+getFileName()+"-"+nf(frameCount,5)+".png";
      imageOutput.save(fileName);  
    }
  }
}

void drawHelp() {
  if(showHelp) {
    fill(0, 220);
    noStroke();
    rect(0, 0, 240, height);
    cp5.draw();
    cp5.show();
  }else {
    cp5.hide();  
  }  
}

void movieEvent(Movie m) {
  m.read();
  if(isMovieLoaded() && inputPixels != null) {
    movie.loadPixels();
    arrayCopy(movie.pixels, inputPixels);
    movie.updatePixels();
  }
}
void captureEvent(Capture c) {
  c.read();
  if(camera != null && inputPixels != null) {
    camera.loadPixels();
    arrayCopy(camera.pixels, inputPixels);
    camera.updatePixels();
  }
}

void sampleColorsForLeds() {
  for(int i = 0; i < nrOfLeds; i++) {
    String ledName = "led"+str(i+1);
    color sample = getLedColor(ledName, colorSamplingMode);
    ledArr[i] = sample;
  }
}

color getLedColor(String ledName, int mode) {
  PShape led = ledLayout.getChild(ledName); //<>//
  float[] p;
  try {
    p = led.getParams();    
  }catch(Exception e) {
    p = getShapeParams(led);
  }
  int pw = ceil(p[2]);
  int ph = ceil(p[3]);
  int px = ceil(p[0] + pw*0.5);
  int py = ceil(p[1] + ph*0.5);
  PVector size = new PVector(1,1);
  if(mode == RECT) {
    size.set(pw, ph);
  }
  //println(ledName+", px:"+px+", py:"+py+", pw:"+pw+", ph:"+ph);
  //color sample = color(255, 60, 0);
  color sample = getColorFromInputImage(new PVector(px, py), size);
  led.setFill(sample);
  /*fill(sample);
  stroke(255);
  ellipseMode(CENTER);
  ellipse(px+ledLayoutX, py+ledLayoutY, pw, ph);*/
  return sample;
}
  
color getColorFromInputImage(PVector pos, PVector size) {
  int mx = (int)pos.x;
  int my = (int)pos.y;
  int mw = ceil(size.x * 0.5);
  int mh = ceil(size.y * 0.5);
  int yStart = my-mh;
  int yEnd = my+mh;
  int xStart = mx-mw;
  int xEnd = mx+mw;
  if(yStart < 0) { yStart = 0; }
  if(yStart >= inputImageHeight) { yStart = inputImageHeight-1; }
  if(yEnd < 0) { yEnd = 0; }
  if(yEnd >= inputImageHeight) { yEnd = inputImageHeight; }
  if(xStart < 0) { xStart = 0; }
  if(xStart >= inputImageHeight) { xStart = inputImageHeight-1; }
  if(xEnd < 0) { xEnd = 0; }
  if(xEnd >= inputImageHeight) { xEnd = inputImageHeight; }
  int r = 0;
  int g = 0;
  int b = 0;
  int index = 0;
  for(int y = yStart; y < yEnd; y++) {
    for(int x = xStart; x < xEnd; x++) {
      int pixelColor = inputPixels[y*inputImageWidth+x];
      r += (pixelColor >> 16) & 0xff;
      g += (pixelColor >> 8) & 0xff;
      b += pixelColor & 0xff;
      index++;
    }
  }
  index = max(1, index);
  r = r / index;
  g = g / index;
  b = b / index;
  return color(r,g,b);
}


void sendColorsToSerialPort() {
  if(serialPort == null || doSendSerial == false) {return;};
  serialPort.write(HEADER);
  for(int i = 0; i < nrOfLeds; i++) {
    int rgb = ledArr[i];
    serialPort.write((rgb >> 16) & 0xFF);
    serialPort.write((rgb >> 8) & 0xFF);
    serialPort.write(rgb& 0xFF);
  }
}

void saveColorsToFile() {
  if(output == null) {return;};
  
  if(doRecordToFile) {
    for(int i = 0; i < nrOfLeds; i++) {
      int rgb = ledArr[i];
      byte r = byte((rgb >> 16) & 0xFF);
      byte g = byte((rgb >> 8) & 0xFF);
      byte b = byte(rgb& 0xFF);
      outputBuffer[0] = r;
      outputBuffer[1] = g;
      outputBuffer[2] = b;
      try {
        output.write(outputBuffer);
      } catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
  
}

void playButtonMovie() {
  println("playButtonMovie: ");
  if(isMovieLoaded()) {
    movie.play();
  }
}
void playButtonDat() {
  println("playButtonDat: ");
  if(reader != null) {
    playFile = true;
  }
}
void pauseButtonMovie() {
  println("pauseButtonMovie: ");
  if(isMovieLoaded()) {
    movie.pause();
  }
}
void pauseButtonDat() {
  println("pauseButtonDat: ");
  if(reader != null) {
    playFile = false;
  }
}
void rewindButtonMovie() {
  println("rewindButtonMovie: ");
  if(isMovieLoaded()) {
    movie.jump(0);
    movie.play();
    movie.pause();
  }
}
void rewindButtonDat() {
  println("rewindButtonDat: ");
  if(reader != null) {
    startReadingFile(datFileName);
    readFile();
    playFile = false;
  }
}
void makeAnimation() {
  println("makeAnimation");
  if(isImageInputLoaded()) {
    if(!doRecordToFile) {
      createFileOutput();
      doRecordToFile = true;
      playButtonMovie();
      cp5.getController("makeAnimation").setLabel("Stop Animation");
    }else {
      stopFileOutput();
      doRecordToFile = false;
      rewindButtonMovie();
      cp5.getController("makeAnimation").setLabel("Make Animation");
    }
  }
}
void makeImages() {
  println("makeImages");
  if(reader != null) {
    //imageOutput = createGraphics(int(ledLayout.width/displayDensity()), int(ledLayout.height/displayDensity()), JAVA2D);
    imageOutput = createGraphics(int(ledLayout.width), int(ledLayout.height), JAVA2D);
    doSaveImagesToFile = true;
    playButtonDat();
  }
}

boolean hasVideoEnded() {
  if(isMovieLoaded()) {
    if(movie.time() == movie.duration()) {
      return true;  
    }
  }
  return false;  
}
boolean isMovieLoaded() {
  return movie != null;  
}
boolean isImageInputLoaded() {
  return (isMovieLoaded() || screenCapture != null || camera != null) && inputPixels != null;
}

void setMovieFile(File file) {
  if(file == null) { return; };
  String filePath = file.getAbsolutePath();
  movieFileName = file.getName();
  int pos = movieFileName.lastIndexOf(".");
  String fileExtension = null;
  if (pos > 0) {
    fileExtension = movieFileName.substring(pos+1);
    movieFileName = movieFileName.substring(0, pos);
  }
  if(fileExtension != null && fileExtension.equals("dat")) {
    datFileName = filePath;
    startReadingFile(datFileName);
    showDatControls(true);
  }else if(fileExtension != null) {
    movie = new Movie(this, filePath);
    movie.play();
    movie.jump(0);
    movie.pause();
    movieFrameRate = movie.frameRate;
    setupInputPixels(movie.width, movie.height);
    println("setMovieFile: movieFileName="+movieFileName+", fileExtension="+fileExtension+", movieFramerate="+movieFrameRate);
    setFrameRate(movieFrameRate);
    showVideoControls(true);
  }
}

void setupInputPixels(int w, int h) {
  inputImageWidth = w;
  inputImageHeight = h;
  println("inputImageWidth="+inputImageWidth+", inputImageHeight="+inputImageHeight);
  inputPixels = new int[inputImageWidth*inputImageHeight];  
}

void setLedLayoutFile(File file) {
  if(file == null) { return; }
  String shapeFileName = file.getAbsolutePath();
  ledLayout = loadShape(shapeFileName);
  PShape leds = ledLayout.getChild("leds");
  if(leds == null) {
    println("Could not find leds layer");
    ledLayout = null;
    return;
  }
  println("leds.getChildCount(): "+leds.getChildCount());
  nrOfLeds = leds.getChildCount();
  ledArr = new int[0];
  for(int i=0; i<nrOfLeds; i++) {
    PShape led = ledLayout.getChild("led"+str(i+1));
    if(led != null) {
      //println("led"+str(i+1)+", kind:"+led.getKind()+", family:"+led.getFamily()+", children:"+led.getChildCount());
      color fillColor = led.getFill(Integer.MAX_VALUE);
      ledArr = append(ledArr, fillColor);
    }
  }
  if(ledArr.length == 0) {
    println("Could not find any object with led id's");
    ledLayout = null;
    return;  
  }else if(ledArr.length != nrOfLeds) {
    println("Not all objects found were named with led#");
    nrOfLeds = ledArr.length;
  }
  setLedTargetDropdown(nrOfLeds);
  println("setLedLayoutFile: nrOfLeds="+nrOfLeds);
}

float[] getShapeParams(PShape shape) {
  float[] p = new float[4];
  float xMin = Float.MAX_VALUE;
  float xMax = Float.MIN_VALUE;
  float yMin = Float.MAX_VALUE;
  float yMax = Float.MIN_VALUE;
  for(int i=0; i<shape.getVertexCount(); i++) {
    PVector v = shape.getVertex(i);
    float x = v.x;
    float y = v.y;
    if(x < xMin) {
      xMin = x;  
    }
    if(x > xMax) {
      xMax = x;  
    }
    if(y < yMin) {
      yMin = y;  
    }
    if(y > yMax) {
      yMax = y;  
    }
  }
  float w = xMax - xMin;
  float h = yMax - yMin;
  p[0] = xMin;
  p[1] = yMin;
  p[2] = w;
  p[3] = h;
  return p;
}

void createFileOutput() {
  String fileName = getFolderName()+File.separator+getFileName()+".dat";
  output = createOutput(fileName);
  println("START RECORDING");
}
void stopFileOutput() {
  if(output != null) {
    try {
      output.flush();
      output.close();
    } catch(Exception e) {
      e.printStackTrace();  
    }
  }
  println("STOP RECORDING");
}
void startReadingFile(String file) {
  reader = createInput(file);
  readerBuffer = new byte[nrOfLeds*3];
  println("START READING FILE");
}

void readFile() {
  boolean canRead = true;
  try {
    int bytesRead = reader.read(readerBuffer, 0, nrOfLeds*3);
    if(bytesRead == -1) {
      canRead = false;
      reader.close();
    }
  } catch(IOException e) {
    e.printStackTrace();
    canRead = false;
  }
  if(canRead) {  
    setLedsShapeColorFromFile(readerBuffer);
  }else {
    playFile = false;
    doSaveImagesToFile = false;
    rewindButtonDat();
  }
}
void setLedsShapeColorFromFile(byte[] ledBuffer) {
  for(int i=0, n=1; i<nrOfLeds*3; i+=3, n++) {    
    int r = (ledBuffer[i] & 0xff);
    int g = (ledBuffer[i+1] & 0xff);
    int b = (ledBuffer[i+2] & 0xff);
    color c = color(r, g, b);
    setLedShapeColor(n, c);
  }
}
void setLedShapeColor(int ledNr, int shapeColor) {
  PShape led = ledLayout.getChild("led"+str(ledNr));
  ledArr[ledNr-1] = shapeColor;
  led.setFill(shapeColor);
}

String getFolderName() {
  if(outputFolderName == null) {
      if(movieFileName != null) {
        outputFolderName = movieFileName;  
      }else {
        outputFolderName = timestamp();
      }
      outputFolderName += "_"+str(nrOfLeds)+"-leds";
  }
  return outputFolderName;
}
String getFileName() {
  if(outputFileName == null) {
      if(movieFileName != null) {
        outputFileName = movieFileName;  
      }else {
        outputFileName = "anim_"+timestamp();
      }
  }else {
    if(movieFileName == null) {
      return "anim_"+timestamp();  
    }
  }
  return outputFileName;      
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td-%1$tH%1$tM%1$tS", Calendar.getInstance());
}

void keyPressed() {
  //println("keyPressed: key = "+key+", keyCode = "+keyCode);
  if (key=='h' || key=='H') {
    showHelp = !showHelp;
  }else if (key=='p' || key=='P') {
    playFile = !playFile;
  }else if (key=='f' || key=='F') {
    println("frameRate = "+frameRate);
  }
}