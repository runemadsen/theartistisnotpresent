// Imports
//----------------------------------------------------------------

import toxi.color.*;
import toxi.util.datatypes.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import geomerative.*;

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
  art = new ArtWork(svgWidth, svgHeight);
}

void draw()
{
  background(1);
  art.display();
}

// Events
//----------------------------------------------------------------

void keyPressed()
{
  if(key == 'r')
  {
    art = new ArtWork(svgWidth, svgHeight);
  }
}