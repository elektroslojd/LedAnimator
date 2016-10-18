# LedAnimator

is a set of tools for creating and displaying animations on programmable leds using an Arduino and a SD-card reader. 

It was developed during the Elektroslöjd-project at KKV Göteborg 2016.
[http://www.elektroslojd.kkvelectro.se/](http://www.elektroslojd.kkvelectro.se/)


It consists of:

* A program written in [Processing](https://processing.org/) for creating animations and also sending serial data to an [Arduino](https://www.arduino.cc/) board for fast prototyping. 

* An [Inkscape](https://inkscape.org) extension for helping creating the led layout file used in the Processing program. 

* A set of Arduino sketches for setting the color on the programmable leds with the help of the [FastLED](http://fastled.io/) library and the [SD](https://www.arduino.cc/en/Reference/SD) library. 



## Concept
The Processing program loads in a svg-file with all the leds drawn up as objects. Each object has it's `id` set as `led1`, `led2`, `led3`... in the same order as the leds are physically laid out. 

In the program you also load in an image source material, this can be either a movie, the built in screen capture, or a web camera. For each frame the program goes through all led objects defined in the svg-file and averages the pixels inside the corresponding pixel boundaries of the source image. The program can then either save this to a file for later playback or send it directly to an Arduino through the serial port. 


## Help
See the wiki for more help:

* [Processing](https://github.com/elektroslojd/LedAnimator/wiki/Processing)
* [Inkscape](https://github.com/elektroslojd/LedAnimator/wiki/Inkscape)
* [Arduino](https://github.com/elektroslojd/LedAnimator/wiki/Arduino)

