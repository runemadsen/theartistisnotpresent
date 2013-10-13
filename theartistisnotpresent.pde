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

FSM fsm;
State defaultState = new State(this, "enterDefault", "drawDefault", "exitDefault");
State ratingState = new State(this, "enterRating", "drawRating", "exitRating");
State predictionState = new State(this, "enterPrediction", "drawPrediction", "exitPrediction");
State artistState = new State(this, "enterArtist", "drawArtist", "exitArtist");

String svgRoot = "/Users/rmadsen/Dropbox/Public";
int svgWidth = 480;
int svgHeight = 288;

// Rating Mode
//----------------------------------------------------------------

Sample rateSample;
ArtWork rateArtwork;
ArrayList<String> ratings = new ArrayList<String>();

// Prediction Mode
//----------------------------------------------------------------

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
  
  fsm = new FSM(defaultState);
  RG.init(this);
  OpenCV opencv = new OpenCV(this, "test.jpg");
  forest = new RandomForest();
}

void draw()
{
  background(1);
  fsm.update();
}

void keyPressed()
{
  if(key == 'r')  fsm.transitionTo(ratingState);
  if(key == 'p')  fsm.transitionTo(predictionState);
  if(key == 'a')  fsm.transitionTo(artistState);

  if(fsm.currentState == ratingState)            keyPressedRatingMode();
  else if(fsm.currentState == predictionState)   keyPressedPredictionMode();
  else if(fsm.currentState == artistState)       keyPressedArtistMode();
}

// Default State
//----------------------------------------------------------------

void enterDefault()
{

}

void drawDefault()
{

}

void exitDefault()
{

}

// Rating Mode
//----------------------------------------------------------------

void enterRating()
{
  newRandom();
}

void drawRating()
{
  pushMatrix();
  translate((width/2) - (svgWidth/2), (height/2) - (svgHeight/2));
  rateArtwork.display();
  popMatrix();
}

void exitRating()
{

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

public void selectCSV(int theValue)
{
  println("Button clicked");
}

void selectedCSV(File selection)
{
  if (selection != null)
  {
    String[] csvData = loadStrings(selection.getAbsolutePath());
  }
}

void newRandom()
{
  rateSample = new Sample();
  rateArtwork = new ArtWork(rateSample, svgWidth, svgHeight);
}

// Prediction Mode
//----------------------------------------------------------------

void enterPrediction()
{

}

void drawPrediction()
{

}

void exitPrediction()
{

}

void keyPressedPredictionMode()
{

}

// Artist Mode
//----------------------------------------------------------------

void enterArtist()
{

}

void drawArtist()
{

}

void exitArtist()
{

}

void keyPressedArtistMode()
{

}