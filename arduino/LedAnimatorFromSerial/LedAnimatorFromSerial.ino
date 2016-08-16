#include <FastLED.h>

#define LED_PIN     9
#define NUM_LEDS    19
#define BRIGHTNESS  64
#define LED_TYPE    WS2812B
#define COLOR_ORDER GRB
#define CMD_NEW_DATA 1
#define BAUD_RATE 57600

// Data pin that led data will be written out over (yellow cable)
#define DATA_PIN 3
// Clock pin only needed for SPI based chipsets when not using hardware SPI (green cable)
#define CLOCK_PIN 8

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
  delay( 3000 );
  //FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection( TypicalLEDStrip );
  //FastLED.addLeds<WS2801, DATA_PIN, CLOCK_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  FastLED.setTemperature(TEMPERATURE);
  //set_max_power_in_volts_and_milliamps(5, 500); // FastLED Power management set at 5V, 500mA.
  
  for(int y=0; y<NUM_LEDS; y++) {
    leds[y] = CRGB::Black;
  }
  FastLED.show();

  Serial.begin(BAUD_RATE);
  while(!Serial) { ; }
}

char serialGlediator (){
  while (!Serial.available()) {}
  return Serial.read();
}

void loop() {
  
  while (serialGlediator() != HEADER) {}
  
  Serial.readBytes((char*)leds, NUM_LEDS*3);
  
  //show_at_max_brightness_for_power();
  FastLED.show();
  
  //FastLED.delay(1000/UPDATES_PER_SECOND); 
}

