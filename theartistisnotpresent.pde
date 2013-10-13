// Imports
//----------------------------------------------------------------

import toxi.color.*;
import toxi.util.datatypes.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import geomerative.*;

// Constants
//----------------------------------------------------------------

int HORIZONTAL = 0;
int GRID = 1;
int CENTER = 2;
int ROTATION = 3;

int TRIANGLE = 0;
int ELLIPSE = 1;
int RECTANGLE = 2;

int DARKEST = 0;
int BRIGHTEST = 1;
int RANDOM = 2;
int DARKGRAY = 3;
int WHITE = 4;

int BRI = 0;
int SAT = 1;
int BRISAT = 2;

// Setup
//----------------------------------------------------------------

String svgRoot = "/Users/rmadsen/Dropbox/Public";
int svgWidth = 480;
int svgHeight = 288;

// Properties
//----------------------------------------------------------------

ArtWork art;
RandomForest forest;

// Setup and Draw
//----------------------------------------------------------------

void setup()
{
  size(1000, 700);
  colorMode(HSB, 1, 1, 1, 1);
  background(0);
  smooth();
  noStroke();
  
  RG.init(this);
  OpenCV opencv = new OpenCV(this, "test.jpg");

  forest = new RandomForest();
  testNew();
}

void draw()
{
  background(1);
  art.display();
}

void testNew()
{
  Sample sample = new Sample();
  art = new ArtWork(sample, svgWidth, svgHeight);
}

// Events
//----------------------------------------------------------------

void keyPressed()
{
  if(key == 'r')
  {
    testNew();
  }
}