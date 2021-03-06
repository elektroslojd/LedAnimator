#include <FastLED.h>


// Data pin that led data will be written out over
#define DATA_PIN 9
// Clock pin only needed for SPI based chipsets when not using hardware SPI
#define CLOCK_PIN 8
// Number of leds
#define NUM_LEDS    19
// Set overall brightness 
#define BRIGHTNESS  90
// Set which type of leds are being used
#define LED_TYPE    WS2812B
// Set the color order for (R)ed, (G)reen and (B)lue channel
#define COLOR_ORDER GRB

#define CMD_NEW_DATA 1
#define BAUD_RATE 250000


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

#define UPDATES_PER_SECOND 60

void setup() {
  delay(3000);
  FastLED.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  //FastLED.addLeds<LED_TYPE, DATA_PIN, CLOCK_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  FastLED.setBrightness(BRIGHTNESS);
  FastLED.setTemperature(TEMPERATURE);

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  
  for(int y=0; y<NUM_LEDS; y++) {
    leds[y] = CRGB::Black;
  }
  FastLED.show();

  Serial.begin(BAUD_RATE);
  while(!Serial) { ; }
}

char serialInput (){
  while (!Serial.available()) {}
  return Serial.read();
}

void loop() {
  digitalWrite(13, LOW);
  
  if(serialInput() == HEADER) {
    digitalWrite(13, HIGH);
    int bytesRead = 0;
    while(bytesRead < (NUM_LEDS *3)) { 
      bytesRead += Serial.readBytes(((uint8_t*)leds) + bytesRead, (NUM_LEDS*3)-bytesRead);
    }
  }

  FastLED.show();
  while(Serial.available() > 0) { Serial.read(); } 
}

