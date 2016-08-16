#include <FastLED.h>
#include <SPI.h>
#include <SD.h>

#define NUM_LEDS      19
#define LED_PIN       9
#define DATA_PIN      3
#define CLOCK_PIN     8
#define BRIGHTNESS    64
#define LED_TYPE      WS2812B
#define COLOR_ORDER   GRB
#define CMD_NEW_DATA  1
#define BAUD_RATE     500000
#define CHIP_SELECT   10

const char HEADER = 'H';
CRGB leds[NUM_LEDS];

File file;

#define UPDATES_PER_SECOND 30

void setup() {
  delay( 3000 ); // power-up safety delay
  FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  //FastLED.addLeds<WS2801, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
  //FastLED.setTemperature(Candle);
  FastLED.setBrightness(BRIGHTNESS);

  for(int n=0; n<NUM_LEDS; n++) {
    leds[n] = CRGB::Black;
  }
  FastLED.show();
  delay(2000);

  //Serial.begin(BAUD_RATE);
  Serial.begin(9600);
  while(!Serial) { ; }

  pinMode(CHIP_SELECT, OUTPUT);
  digitalWrite(CHIP_SELECT, HIGH);
  if(!SD.begin(CHIP_SELECT)) {
    Serial.println("sd-card init fail");
    return;
  }
  Serial.println("sd-card init done");

  openFile("led2.dat");
}


void loop() {

  if(file.available()) {
    file.readBytes((char*)leds, NUM_LEDS*3);
  }else {
    rewindFile();
  }
  
  FastLED.delay(1000/UPDATES_PER_SECOND);
}

void rewindFile() {
  Serial.println("rewindFile");
  file.seek(0);
}

boolean openFile(String fileName) {
  file = SD.open(fileName);
  if(file) {
    Serial.println(fileName+" opened");
    return true;
  }
  return false;
}

