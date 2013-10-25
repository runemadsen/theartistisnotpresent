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

int STROKE = 0;
int FILL = 1;

int DISTANCE_SORT = 0;
int ODD_SORT = 1;
int BRIGHTNESS_SORT = 2;
int SATURATION_SORT = 3;

int LINEAR = 0;
int SINE_IN = 1;
int SINE_OUT = 2;
int QUAD_IN = 3;
int QUAD_OUT = 4;
int QUINT_IN = 5;
int QUINT_OUT = 6;
int QUART_IN = 7;
int QUART_OUT = 8;

int HORIZONTAL = 0;
int GRID = 1;
int CENTER = 2;
int ROTATION = 3;

int TRIANGLE = 0;
int ELLIPSE = 1;
int RECTANGLE = 2;


int DARKEST = 0;
int BRIGHTEST = 1;
int FIRST = 2;
int MIDDLE = 3;
int LAST = 4;
int DARKGRAY = 5;
int WHITE = 6;

int BRI = 0;
int SAT = 1;
int BRISAT = 2;

// Setup
//----------------------------------------------------------------

Mask curtain;
RandomForest forest;

FSM fsm;
State defaultState = new State(this, "enterDefault", "drawDefault", "exitDefault");
State artistState = new State(this, "enterArtist", "drawArtist", "exitArtist");
State ratingState = new State(this, "enterRating", "drawRating", "exitRating");
State predictionState = new State(this, "enterPrediction", "drawPrediction", "exitPrediction");
State gridState = new State(this, "enterGrid", "drawGrid", "exitGrid");
State compareState = new State(this, "enterCompare", "drawCompare", "exitCompare");

PVector screenSize = new PVector(480, 288);

PVector ledPosition = new PVector(36, 258);
PVector ledSize = new PVector(215, 168);
PImage  ledMask;

float downScale =  ledSize.y / screenSize.y;

PVector smallSize = new PVector(screenSize.x * downScale, screenSize.y * downScale);
float smallWidthDiff =  smallSize.x - ledSize.x;

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

boolean csvLoaded = false;
float mutationRate = 0.05;
int populationNum = 30;
Population population;
ArtWork[] populationArt = new ArtWork[populationNum];
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
  size(1458, 880);
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
  if(key == 'g')  fsm.transitionTo(gridState);
  if(key == 'a')  fsm.transitionTo(artistState);
  if(key == 'c')  fsm.transitionTo(compareState);

  if(fsm.currentState == ratingState)            keyPressedRatingMode();
  else if(fsm.currentState == predictionState)   keyPressedPredictionMode();
  else if(fsm.currentState == gridState)       keyPressedArtistMode();
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

// Artist Mode
//----------------------------------------------------------------

void enterArtist()
{
  lastMillis = millis();
  curtain = new Mask();
  curtain.addWindow((int) ledPosition.x, (int) ledPosition.y, (int) ledSize.x, (int) ledSize.y);
  ledMask = loadImage("mask.png");
  showArt = new ArtWork(new Sample(), (int) smallSize.x, (int) smallSize.y, -int(smallWidthDiff/2), 0);
}

void drawArtist()
{
  pushMatrix();
  translate((int) ledPosition.x, (int) ledPosition.y);
    showArt.display();
    if(outArt != null)  outArt.display();
    image(ledMask, 0, 0);
  popMatrix();
  curtain.display();

  if(millis() - lastMillis > timeOnScreen)
  {
    lastMillis = millis();
    
    outArt = showArt;
    outArt.moveTo(-int(smallWidthDiff/2), int(screenSize.y * downScale), 1);
    
    showArt = new ArtWork(new Sample(), (int) smallSize.x, (int) smallSize.y, -int(smallWidthDiff/2), -int(smallSize.y));
    showArt.moveTo(-int(smallWidthDiff/2), 0, 1);
  }
}

void exitArtist()
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
  translate((width/2) - (screenSize.x/2), (height/2) - (screenSize.y/2));
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
  rateArtwork = new ArtWork(rateSample, (int) screenSize.x, (int) screenSize.y, 0, 0);
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

    int splitInteger = round(predictionSplit * csvData.length);

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

// Grid Mode
//----------------------------------------------------------------

void enterGrid()
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

    population = new Population(mutationRate, populationNum);
    populationToArtWork(population);
    labelPopulation(population);
  }

  csvLoaded = true;
}

void drawGrid()
{
  if(csvLoaded)
  {
    for(int i = 0; i < populationNum; i++)
    {
      populationArt[i].display();
      textSize(32);
      fill(0);
      text(population.population[i].label, populationArt[i].loc.x + 5, populationArt[i].loc.y + 37);
      fill(1);
      text(population.population[i].label, populationArt[i].loc.x + 7, populationArt[i].loc.y + 37);
    }
  }
}

void exitGrid()
{

}

void keyPressedArtistMode()
{
  if(key == 'n')
  {
    population.selection();
    population.reproduction();
    populationToArtWork(population);
    labelPopulation(population);
  }
}

void populationToArtWork(Population p)
{
  for(int i = 0; i < populationNum; i++)
  {
    int w = (int) screenSize.x / 2;
    int h = (int) screenSize.y / 2;
    int x = int((i % 6) * w);
    int y = int(((i / 6) % 6) * h);

    populationArt[i] = new ArtWork(p.population[i], w, h, x, y);
  }
}

void labelPopulation(Population p)
{
  for(int i = 0; i < populationNum; i++)
  {
    p.population[i].label = (int) forest.predict(p.population[i]);
  }
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
  compare1 = new ArtWork(sample1, (int) screenSize.x, (int) screenSize.y, 0, 0);

  Sample sample2 = new Sample(sample1.toString());
  compare2 = new ArtWork(sample2, (int) screenSize.x, (int) screenSize.y, (int) screenSize.x, 0);

  String string1 = sample1.toString();
  String string2 = sample2.toString();

  if(!string1.equals(string2))  println("SOMETHING IS WRONG IN CSV CONVERSION");
}