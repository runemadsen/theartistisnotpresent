// TODO
//
// - Use arraycopy and PImages for stuff where it's possible. Check speed before / after
// - Put config in a config file

// Imports
//----------------------------------------------------------------

import java.util.Arrays;
import toxi.color.*;
import toxi.util.datatypes.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import geomerative.*;
import codeanticode.syphon.*;

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

SyphonServer server;
RandomForest forest;
PFont helvetica;
PFont helveticaSmall;

FSM fsm;
State defaultState = new State(this, "enterDefault", "drawDefault", "exitDefault");
State artistState = new State(this, "enterArtist", "drawArtist", "exitArtist");
State gridState = new State(this, "enterGrid", "drawGrid", "exitGrid");
State ratingState = new State(this, "enterRating", "drawRating", "exitRating");
State predictionState = new State(this, "enterPrediction", "drawPrediction", "exitPrediction");
State compareState = new State(this, "enterCompare", "drawCompare", "exitCompare");

PVector screen1Loc = new PVector(280, 10);
PVector screen2Loc = new PVector(280, 310);
PVector screenSize = new PVector(480, 288);

PVector buildingLoc = new PVector(36, 258);
PVector syphonSize = new PVector(1024, 768);

// Shared Modes
//----------------------------------------------------------------

String csvFile = "ratings/ratings.csv";

float mutationRate = 0.05;
int populationNum = 30;
Population population;

// Artist Mode
//----------------------------------------------------------------

BuildingMask buildingMask;

boolean saveImages = true;
String saveImagesPath = "/Users/Images/Dropbox/Public";
String runFolder;

int runTimeInMinutes = 15;
long runTimeStart;

int showPopulationNum = 10;
float animationTimeGen = 1;
float animationTimeArt = 1;
float animationTimeFall = 4;
float screenTimeGen = 3;
float screenTimeArt = 0.5;
int fontSize = 80;
int fake = 0;

int generationNum;
PGraphics artistCanvas;
PGraphics screenCanvas;
PGraphics syphonCanvas;
PGraphics syphonCanvasFlip;
ArtWork[] art = new ArtWork[showPopulationNum];
int curArtWork;
boolean displayArtist = false;

PVector animationLoc = new PVector(0, screenSize.y);
AniSequence animation;

// Grid Mode
//----------------------------------------------------------------

ArtWork[] gridArt = new ArtWork[populationNum];
boolean displayGrid = false;

// Rating Mode
//----------------------------------------------------------------

Sample rateSample;
ArtWork rateArtwork;
ArrayList<String> ratings = new ArrayList<String>();

// Prediction Mode
//----------------------------------------------------------------

float predictionSplit = 0.7;

// Compare Mode
//----------------------------------------------------------------

ArtWork compare1;
ArtWork compare2;

// Setup and Draw
//----------------------------------------------------------------

void setup()
{
  size(1024, 768, P2D);
  frameRate(24);
  //size(1458, 880);
  colorMode(HSB, 1, 1, 1, 1);
  background(0);
  smooth();
  noStroke();

  helveticaSmall = loadFont("HelveticaNeue-Bold-20.vlw");
  helvetica = loadFont("HelveticaNeue-Bold-80.vlw");
  textFont(helveticaSmall);

  // preload all samples into random forest
  OpenCV opencv = new OpenCV(this, "test.jpg");
  forest = new RandomForest();

  server = new SyphonServer(this, "Processing Syphon");

  loadAndParseCSVAsTrainingSamples();
  
  fsm = new FSM(defaultState);
  RG.init(this);
  Ani.init(this);

  runFolder = year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second();
}

void draw()
{
  background(0);
  fsm.update();
  //println("Framerate: " + frameRate);
}

void keyPressed()
{
  if(key == 'r')  fsm.transitionTo(ratingState);
  if(key == 'p')  fsm.transitionTo(predictionState);
  if(key == 'g')  fsm.transitionTo(gridState);
  if(key == 'c')  fsm.transitionTo(compareState);

  if(fsm.currentState == defaultState)           keyPressedDefaultMode();
  else if(fsm.currentState == artistState)       keyPressedArtistMode();
  else if(fsm.currentState == ratingState)       keyPressedRatingMode();
  else if(fsm.currentState == predictionState)   keyPressedPredictionMode();
  else if(fsm.currentState == gridState)         keyPressedGridMode();
  else if(fsm.currentState == compareState)      keyPressedCompareMode();
  
}

// Default State
//----------------------------------------------------------------

void enterDefault()
{

}

void drawDefault()
{
  textSize(20);
  text("Press '1' to run 15 minute sequence, '5' to run 5 minute sequence, or '0' to run with no stop time", 5, height-8);
}

void exitDefault()
{

}

void keyPressedDefaultMode()
{
  if(key == 't')
  {
    runTimeInMinutes = 1;
    // ALSO SET VARS SO THEY WORK BETTER WITH THIS TIME
    fsm.transitionTo(artistState);
  }

  if(key == '1')
  {
    runTimeInMinutes = 15;
    // ALSO SET VARS SO THEY WORK BETTER WITH THIS TIME
    fsm.transitionTo(artistState);
  }
  else if(key == '5')
  {
    runTimeInMinutes = 5;
    // ALSO SET VARS SO THEY WORK BETTER WITH THIS TIME
    fsm.transitionTo(artistState);
  }
  else if(key == '0')
  {
    runTimeInMinutes = 0;
    fsm.transitionTo(artistState);
  }
}

// Artist Mode
//----------------------------------------------------------------

void enterArtist()
{
  //printGenerationAnimationtime();

  runTimeStart = millis();
  generationNum = 1;
  curArtWork = 0;

  buildingMask = new BuildingMask("mask.png");

  //--> Create Syphon output graphics
  syphonCanvas = createGraphics((int) syphonSize.x, (int) syphonSize.y);
  syphonCanvas.beginDraw();
  syphonCanvas.colorMode(HSB, 1, 1, 1, 1);
  syphonCanvas.background(0);
  syphonCanvas.endDraw();

  syphonCanvasFlip = createGraphics((int) syphonSize.x, (int) syphonSize.y);
  syphonCanvasFlip.beginDraw();
  syphonCanvasFlip.colorMode(HSB, 1, 1, 1, 1);
  syphonCanvasFlip.background(0);
  syphonCanvasFlip.endDraw();

  //--> Create Big PGraphics to hold all artworks in generation

  artistCanvas = createGraphics((int) screenSize.x, (int) screenSize.y * (showPopulationNum + 1));
  artistCanvas.beginDraw();
  artistCanvas.colorMode(HSB, 1, 1, 1, 1);
  artistCanvas.background(0);
  artistCanvas.endDraw();
  
  //--> Create Screen Mask PGraphics

  screenCanvas = createGraphics((int) screenSize.x, (int) screenSize.y);
  screenCanvas.beginDraw();
  screenCanvas.colorMode(HSB, 1, 1, 1, 1);
  screenCanvas.background(0);
  screenCanvas.endDraw();

  //--> Create Animation Sequence

  animation = new AniSequence(this);
  animation.beginSequence();

  // show generation num
  animation.add(Ani.to(animationLoc, animationTimeGen, 0, "y", 0, Ani.CUBIC_IN_OUT));

  // show each artwork
  for(int i = 0; i < showPopulationNum; i++)
  {
    float delayTime = i == 0 ? screenTimeGen : screenTimeArt;
    animation.add(Ani.to(animationLoc, animationTimeArt, delayTime, "y", -(screenSize.y * (i+1)), Ani.CUBIC_IN_OUT));
  }

  // fake animation to call onEnd method
  animation.add(Ani.to(this, 0, "fake", 0, Ani.CUBIC_IN, "onEnd:fallOrFinish"));
  animation.endSequence();

  //--> Create population

  population = new Population(mutationRate, populationNum);
  runPredictionOnPopulationSamples(population);
  Arrays.sort(population.population);
  populationToArtistCanvas(population);
  saveGenerationToSVGs(art);
  
  displayArtist = true;
  animation.start();
}

void drawArtist()
{
  if(!displayArtist) return;

  // draw into screen graphics
  screenCanvas.beginDraw();
  screenCanvas.background(0);
  screenCanvas.image(artistCanvas, animationLoc.x, animationLoc.y);
  screenCanvas.endDraw();

  buildingMask.applyCanvas(screenCanvas);
  
  // THIS SHOULD REALLY NOT BE NECESSARY!!!!!
  screenCanvas.beginDraw();
  screenCanvas.background(0);
  screenCanvas.image(artistCanvas, animationLoc.x, animationLoc.y);
  screenCanvas.endDraw();
  // THIS SHOULD REALLY NOT BE NECESSARY!!!!!

  // BEFORE SYPHON
  //image(buildingMask.maskeCanvas, buildingLoc.x, buildingLoc.y);
  //image(screenCanvas, screen1Loc.x, screen1Loc.y);
  //image(screenCanvas, screen2Loc.x, screen2Loc.y);

  // AFTER SYPHON
  syphonCanvas.beginDraw();
  screenCanvas.background(0);
  syphonCanvas.image(buildingMask.maskeCanvas, buildingLoc.x, buildingLoc.y);
  syphonCanvas.image(screenCanvas, screen1Loc.x, screen1Loc.y);
  syphonCanvas.image(screenCanvas, screen2Loc.x, screen2Loc.y);
  syphonCanvas.endDraw();

  image(syphonCanvas, 0, 0);
  flipIt();
  server.sendImage(syphonCanvasFlip);
}

void exitArtist()
{

}

void fallOrFinish()
{
  if(runTimeInMinutes > 0 && millis() - runTimeStart > (runTimeInMinutes * 60 * 1000))
  {
    // just stay still on screen
  }
  else {
    Ani.to(animationLoc, animationTimeFall, screenTimeArt, "y", screenSize.y, Ani.CUBIC_IN_OUT);
    Ani.to(this, animationTimeFall, screenTimeArt, "fake", screenSize.y, Ani.CUBIC_IN_OUT, "onEnd:animateNewGeneration");
  }
}

void animateNewGeneration()
{
  population.selection();
  population.reproduction();
  runPredictionOnPopulationSamples(population);
  Arrays.sort(population.population);
  generationNum++;
  populationToArtistCanvas(population);
  saveGenerationToSVGs(art);
  animation.start();
}

void keyPressedArtistMode()
{
}

void populationToArtistCanvas(Population p)
{
  artistCanvas.beginDraw();
  artistCanvas.colorMode(HSB, 1, 1, 1, 1);
  //artistCanvas.noSmooth();

  // write generation num to first spot
  artistCanvas.fill(0);
  artistCanvas.noStroke();
  artistCanvas.rect(0, 0, screenSize.x, screenSize.y);
  artistCanvas.textSize(fontSize);
  artistCanvas.fill(1);
  artistCanvas.noStroke();
  artistCanvas.textFont(helvetica);
  float tWidth = artistCanvas.textWidth("" + generationNum);
  artistCanvas.text("" + generationNum, (artistCanvas.width/2)-(tWidth/2), (screenSize.y/2)+(fontSize/3));

  // then draw artists
  for(int i = 0; i < showPopulationNum; i++)
  {
    // get from bottom because they are sorted by label min > max
    int index = (p.population.length-1) - i;
    art[i] = new ArtWork(p.population[index], (int) screenSize.x, (int) screenSize.y);
    artistCanvas.image(art[i].canvas, 0, (i + 1) * screenSize.y);
  }

  artistCanvas.endDraw();
}

void printGenerationAnimationtime()
{
  float secs = animationTimeGen + screenTimeGen + (showPopulationNum * animationTimeArt) + (showPopulationNum * screenTimeArt);
  println(secs + " seconds");
  println(((5.0 * 60.0) / secs) + " generations for 5 minute run");
  println(((15.0 * 60.0) / secs) + " generations for 15 minute run");
}

// Grid Mode
//----------------------------------------------------------------

void enterGrid()
{
  population = new Population(mutationRate, populationNum);
  populationToGridArt(population);
  runPredictionOnPopulationSamples(population);
  displayGrid = true;
}

void drawGrid()
{
  if(!displayGrid) return;

  for(int i = 0; i < gridArt.length; i++)
  {
    PGraphics canvas = gridArt[i].canvas;
    int x = int((i % 6) * canvas.width);
    int y = int(((i / 6) % 6) * canvas.height);
    image(canvas, x, y);
    textSize(20);
    textFont(helveticaSmall);
    fill(0);
    text(population.population[i].label, x + 5, y + 37);
    fill(1);
    text(population.population[i].label, x + 7, y + 37);
  }
}

void exitGrid()
{

}

void keyPressedGridMode()
{
  if(key == 'n')
  {
    population.selection();
    population.reproduction();
    populationToGridArt(population);
    runPredictionOnPopulationSamples(population);
  }
}

void populationToGridArt(Population p)
{
  for(int i = 0; i < population.population.length; i++)
  {
    int w = (int) screenSize.x / 2;
    int h = (int) screenSize.y / 2;
    gridArt[i] = new ArtWork(population.population[i], w, h);
  }
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
  translate((width/2) - (rateArtwork.canvas.width/2), (height/2) - (rateArtwork.canvas.height/2));
  image(rateArtwork.canvas, 0, 0);
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
    println("rated: " + rating);
    rateSample.setLabel(rating);
    ratings.add(rateSample.toString());
    newRandom();
  }

  if(key == 'i')
  {
    println("****** VARIABLES *******");
    rateSample.colorscheme.printVars();
    rateSample.composition.printVars();
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
    ratings.clear();
    println("Saved CSV");
  }
}

void newRandom()
{
  rateSample = new Sample();
  rateArtwork = new ArtWork(rateSample, (int) screenSize.x, (int) screenSize.y);
}

// Prediction Mode
//----------------------------------------------------------------

void enterPrediction()
{
  // reset random forest with split
  forest = new RandomForest();
  loadAndParseCSVAsTrainingAndPredictionSamples();
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

// Compare Mode
//----------------------------------------------------------------

void enterCompare()
{
  compareTwo();
}

void drawCompare()
{
  translate((width/2) - (screenSize.x/2), (height/2) - (screenSize.y + 5));
  image(compare1.canvas, 0, 0);
  image(compare2.canvas, 0, compare1.canvas.height + 10);
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
  compare1 = new ArtWork(sample1, (int) screenSize.x, (int) screenSize.y);

  Sample sample2 = new Sample(sample1.toString());
  compare2 = new ArtWork(sample2, (int) screenSize.x, (int) screenSize.y);

  String string1 = sample1.toString();
  String string2 = sample2.toString();

  if(!string1.equals(string2))  println("SOMETHING IS WRONG IN CSV CONVERSION");
}

// Helpers
//----------------------------------------------------------------

void runPredictionOnPopulationSamples(Population p)
{
  for(int i = 0; i < p.population.length; i++)
  {
    double prediction = forest.predict(p.population[i]);
    p.population[i].label = (int) prediction;
  }
}

void saveGenerationToSVGs(ArtWork[] artToSave)
{
  if(saveImages)
  {
    String folder = saveImagesPath + "/" + runFolder;

    for(int i = 0; i < artToSave.length; i++)
    {
      String filename = folder + "/" + generationNum + "-" + i + ".svg";
      artToSave[i].saveSVG(filename);
    }

    artToSave[artToSave.length-1].saveSVG(folder + "/latest.svg");
  }
}

void flipIt()
{
  syphonCanvas.loadPixels();
  syphonCanvasFlip.loadPixels();
 
  for(int y = 0; y < syphonCanvas.height; y++)
  {
    for(int x = 1; x < syphonCanvas.width; x++)
    {
      int oldIndex = x + y * syphonCanvas.width;
      int newY = syphonCanvas.height - 1 - y;
      int newIndex = x + newY * syphonCanvas.width;
      syphonCanvasFlip.pixels[newIndex] = syphonCanvas.pixels[oldIndex];
    }
  }
  syphonCanvasFlip.updatePixels();
} 

// CSV Parsing
//----------------------------------------------------------------

void loadAndParseCSVAsTrainingSamples()
{
  String[] csvData = loadStrings(csvFile);
    
  for(int i = 0; i < csvData.length; i++)
  {
    Sample sample = new Sample(csvData[i]);
    forest.addTrainingSample(sample);
  }

  if(csvData.length > 0)
  {
    forest.train();
  }
}

void loadAndParseCSVAsTrainingAndPredictionSamples()
{
  //--> Split up data

  String[] csvData = loadStrings(csvFile);
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
