// Imports
//----------------------------------------------------------------

import toxi.color.*;
import toxi.util.datatypes.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import geomerative.*;
import controlP5.*;

// Constants
//----------------------------------------------------------------

int DEFAULTMODE = 0;
int RATINGMODE = 1;
int PREDICTIONMODE = 2;
int ARTISTMODE = 3;

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

// Shared
//----------------------------------------------------------------

int mode = DEFAULTMODE;

// Rating Mode
//----------------------------------------------------------------

Sample rateSample;
ArtWork rateArtwork;
ArrayList<String> ratings = new ArrayList<String>();

// Prediction Mode
//----------------------------------------------------------------

ControlP5 cp5;
DropdownList modeSelector;

// Artist Mode
//----------------------------------------------------------------

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
  
  // set list
  cp5 = new ControlP5(this);
  modeSelector = cp5.addDropdownList("modeSelector").setPosition(10, 20);
  modeSelector.addItem("Default Mode", DEFAULTMODE);
  modeSelector.addItem("Rating Mode", RATINGMODE);
  modeSelector.addItem("Prediction Mode", PREDICTIONMODE);
  modeSelector.addItem("Artist Mode", ARTISTMODE);
}

void draw()
{
  background(1);

  if(mode == RATINGMODE)            drawRatingMode();
  else if(mode == PREDICTIONMODE)   drawPredictionMode();
  else if(mode == ARTISTMODE)      drawArtistMode();
}

void drawRatingMode()
{
  pushMatrix();
  translate((width/2) - (svgWidth/2), (height/2) - (svgHeight/2));
  rateArtwork.display();
  popMatrix();
}

void drawPredictionMode()
{
  
}

void drawArtistMode()
{
  
}

// Events
//----------------------------------------------------------------

void keyPressed()
{
  if(mode == RATINGMODE)  keyPressedRatingMode();
}

void keyPressedRatingMode()
{
  if(keyCode >= 48 && keyCode <= 57)
  {
    int rating = keyCode - 48;
    rateSample.setLabel(rating);
    ratings.add(rateSample.toString());
    newRandom();
  }

  if(key == 's')
  {
    println("Saving CSV");
    String[] csvData = new String[ratings.size()];
    for(int i = 0; i < ratings.size(); i++)
    {
      csvData[i] = ratings.get(i);
    }

    String filename = year() + "-" + month()+ "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + "-" + millis();
    saveStrings("ratings/" + filename + ".csv", csvData);
    println("Saved CSV");
  }
}

void controlEvent(ControlEvent e) {
  
  if(e.isGroup() && e.getName() == "modeSelector")
  {
    int newMode = int(e.getGroup().getValue());
    
    if(newMode == RATINGMODE)
    {
      newRandom();
    }

    mode = newMode;
  } 
}

// New Random Artwork
//----------------------------------------------------------------

void newRandom()
{
  rateSample = new Sample();
  rateArtwork = new ArtWork(rateSample, svgWidth, svgHeight);
}