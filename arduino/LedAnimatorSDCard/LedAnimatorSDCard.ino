#include <FastLED.h>
#include <SPI.h>
#include <SD.h>

// Data pin that led data will be written out over
#define DATA_PIN 9
// Clock pin only needed for SPI based chipsets when not using hardware SPI
#define CLOCK_PIN 8
// Number of leds
#define NUM_LEDS    19
// Set overall brightness 
#define BRIGHTNESS  64
// Set which type of leds are being used
#define LED_TYPE    WS2812B
// Set the color order for (R)ed, (G)reen and (B)lue channel
#define COLOR_ORDER GRB

#define CMD_NEW_DATA  1
#define BAUD_RATE     500000
#define CHIP_SELECT   10

/*
FastLED provides these pre-conigured incandescent color profiles:
  Candle, Tungsten40W, Tungsten100W, Halogen, CarbonArc,
  HighNoonSun, DirectSunlight, OvercastSky, ClearBlueSky,

FastLED provides these pre-configured gaseous-light color profiles:
  WarmFluorescent, StandardFluorescent, CoolWhiteFluorescent,
  FullSpectrumFluorescent, GrowLightFluorescent, BlackLightFluorescent,
  MercuryVapor, SodiumVapor, MetalHalide, HighPressureSodium,

FastLED also provides an "Uncorrected temperature" profile
  UncorrectedTemperature;
*/
#define TEMPERATURE UncorrectedTemperature

const char HEADER = 'H';
CRGB leds[NUM_LEDS];

File file;

#define UPDATES_PER_SECOND 30

void setup() {
  delay( 3000 ); // power-up safety delay
  //FastLED.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  FastLED.addLeds<WS2801, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  FastLED.setTemperature(TEMPERATURE);

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

  openFile("anim.dat");
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

