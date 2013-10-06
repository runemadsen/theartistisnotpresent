// Imports
//----------------------------------------------------------------

import toxi.color.*;
import toxi.util.datatypes.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import geomerative.*;

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
  art = new ArtWork();
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
    art = new ArtWork();
  }
}