#include <FastLED.h>


// Data pin that led data will be written out over
#define DATA_PIN 3
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

#define CMD_NEW_DATA 1
#define BAUD_RATE 57600


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
  //FastLED.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection( TypicalLEDStrip );
  FastLED.addLeds<WS2801, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  FastLED.setTemperature(TEMPERATURE);
  
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
  while (serialInput() != HEADER) {}
  
  Serial.readBytes((char*)leds, NUM_LEDS*3);
  FastLED.delay(1000/UPDATES_PER_SECOND); 
}

