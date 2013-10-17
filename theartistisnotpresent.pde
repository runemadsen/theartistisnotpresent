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

int MONOCHROME = 0;
int TRIADIC = 1;
int COMPLEMENTARY = 2;
int TETRADIC = 3;
int ANALOGOUS = 4;
int ACCENTEDANALOGOUS = 5;

int DISTANCE_SORT = 0;
int RANDOM_SORT = 1;
int BRIGHTNESS_SORT = 2;
int SATURATION_SORT = 3;

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

RandomForest forest;

FSM fsm;
State defaultState = new State(this, "enterDefault", "drawDefault", "exitDefault");
State ratingState = new State(this, "enterRating", "drawRating", "exitRating");
State predictionState = new State(this, "enterPrediction", "drawPrediction", "exitPrediction");
State artistState = new State(this, "enterArtist", "drawArtist", "exitArtist");
State testState = new State(this, "enterTest", "drawTest", "exitTest");
State compareState = new State(this, "enterCompare", "drawCompare", "exitCompare");

int svgWidth = 480;
int svgHeight = 288;

int ledWidth = 215;
int ledHeight = 168;

float downScale =  (float) ledHeight / (float) svgHeight;

int smallWidth = int(svgWidth * downScale);
int smallHeight = int(svgHeight * downScale);

int smallWidthDiff =  smallWidth - ledWidth;

PImage maske;

// Rating Mode
//----------------------------------------------------------------

Sample rateSample;
ArtWork rateArtwork;
ArrayList<String> ratings = new ArrayList<String>();

// Prediction Mode
//----------------------------------------------------------------

float predictionSplit = 0.7;

// Artist Mode
//----------------------------------------------------------------

boolean saveImages = false;
String saveImagesPath = "/Users/rmadsen/Dropbox/Public";

// Test Mode
//----------------------------------------------------------------

ArtWork showArt;
ArtWork outArt;
long lastMillis = 0;
int timeOnScreen = 3000;

// Compare Mode
//----------------------------------------------------------------

ArtWork compare1;
ArtWork compare2;

// Setup and Draw
//----------------------------------------------------------------

void setup()
{
  size(1200, 800);
  colorMode(HSB, 1, 1, 1, 1);
  background(0);
  //smooth();
  noStroke();
  
  fsm = new FSM(defaultState);
  RG.init(this);
  Ani.init(this);
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
  if(key == 't')  fsm.transitionTo(testState);
  if(key == 'c')  fsm.transitionTo(compareState);

  if(fsm.currentState == ratingState)            keyPressedRatingMode();
  else if(fsm.currentState == predictionState)   keyPressedPredictionMode();
  else if(fsm.currentState == artistState)       keyPressedArtistMode();
  else if(fsm.currentState == compareState)      keyPressedCompareMode();
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

void newRandom()
{
  rateSample = new Sample();
  rateArtwork = new ArtWork(rateSample, svgWidth, svgHeight, 0, 0);
}

// Prediction Mode
//----------------------------------------------------------------

void enterPrediction()
{
  selectInput("Select a file to process:", "parsePredictionSCV");
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

void parsePredictionSCV(File selection)
{
  if (selection != null)
  {
    //--> Split up data

    String[] csvData = loadStrings(selection.getAbsolutePath());
    ArrayList<Sample> trainingSamples = new ArrayList<Sample>();
    ArrayList<Sample> predictionSamples = new ArrayList<Sample>();

    println("length: " + csvData.length);
    int splitInteger = round(predictionSplit * csvData.length);
    println("splitInteger: " + splitInteger);

    for(int i = 0; i < csvData.length; i++)
    {
      Sample sample = new Sample(csvData[i]);

      if(i < splitInteger)      trainingSamples.add(sample);
      else                      predictionSamples.add(sample);
    }
    
    //--> Train

    for(int i = 0; i < trainingSamples.size(); i++)
    {
      forest.addTrainingSample(trainingSamples.get(i));
    }
    forest.train();

    //--> Predict

    int correctAnswers = 0;
    int wrongAnswers = 0;
    int combinedDiff = 0;
    int[] diffByrating = new int[10];
    int[] missesByrating = new int[10];

    for(int i = 0; i < predictionSamples.size(); i++)
    {
      Sample sample = predictionSamples.get(i);
      double prediction = forest.predict(sample);
      println("Prediction: " + prediction + ", Label: " + sample.label);

      int diff = abs(((int) prediction) - sample.label);

      if(diff > 0)
      {
        wrongAnswers++;
        combinedDiff += diff;
        missesByrating[sample.label]++;
        diffByrating[sample.label] += diff;
      }
      else
      {
        correctAnswers++;
      }
    }

    println("**************************************************");
    println("Overall Results of Prediction");

    for (int i = 0; i < diffByrating.length; i++)
    {
      if(missesByrating[i] > 0)
        println("The rating " + i + " had " + missesByrating[i] + " wrong predictions with an average of " + (diffByrating[i] / missesByrating[i]));
    }

    println("Overall prediction difference average: " + (combinedDiff/predictionSamples.size()));
    println("Overall correct answers: " + correctAnswers + " (" + (double) correctAnswers*100/predictionSamples.size() + " percent)");
    println("Overall Wrong answers: " + wrongAnswers + " (" + (double) wrongAnswers*100/predictionSamples.size() + " percent)");
    println("**************************************************");
  }
}

// Artist Mode
//----------------------------------------------------------------

void enterArtist()
{
  selectInput("Select a file to process:", "parseArtistSCV");
}

void parseArtistSCV(File selection)
{
  if (selection != null)
  {
    String[] csvData = loadStrings(selection.getAbsolutePath());
    
    for(int i = 0; i < csvData.length; i++)
    {
      Sample sample = new Sample(csvData[i]);
      forest.addTrainingSample(sample);
    }

    forest.train();

    // generate first generation
  }
}

void drawArtist()
{
  // MAKE SURE THAT WHEN I GENERATE A NEW POPULATION, AND I WEIGH THEM WITH RANDOM FOREST, THAT GOES IN THE LABEL

  // show generation

  // after millis
    // new generation based on weight of parents from the old generation
}

void exitArtist()
{

}

void keyPressedArtistMode()
{

}

// Test Mode
//----------------------------------------------------------------

void enterTest()
{
  lastMillis = millis();
  maske = loadImage("mask.png");
  showArt = new ArtWork(new Sample(), smallWidth, smallHeight, -(smallWidthDiff/2), 0);
}

void drawTest()
{
  showArt.display();

  if(outArt != null)
  {
    outArt.display();
  }

  fill(0);
  noStroke();
  rect(215, 0, width-215, height);
  rect(0, 168, width, height-168);
  image(maske, 0, 0);

  if(millis() - lastMillis > timeOnScreen)
  {
    lastMillis = millis();
    
    outArt = showArt;
    outArt.moveTo(-(smallWidthDiff/2), int(svgHeight * downScale), 1);
    
    showArt = new ArtWork(new Sample(), smallWidth, smallHeight, -(smallWidthDiff/2), -smallHeight);
    showArt.moveTo(-(smallWidthDiff/2), 0, 1);
  }
}

void exitTest()
{

}

// Compare Mode
//----------------------------------------------------------------

void enterCompare()
{
  compareTwo();
}

void drawCompare()
{
  compare1.display();
  compare2.display();
}

void exitCompare()
{

}

void keyPressedCompareMode()
{
  if(key == 'n')
  {
    compareTwo();
  }
}

void compareTwo()
{
  Sample sample1 = new Sample();
  sample1.label = 9;
  compare1 = new ArtWork(sample1, svgWidth, svgHeight, 0, 0);

  Sample sample2 = new Sample(sample1.toString());
  compare2 = new ArtWork(sample2, svgWidth, svgHeight, svgWidth, 0);
}