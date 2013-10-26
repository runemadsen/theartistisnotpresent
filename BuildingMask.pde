class BuildingMask
{
  PImage maske;
  PGraphics maskeCanvas;
  
  int middlePixel;
  int[] numBlackPixelsLeft;
  int[] blackPixelStopLeft;
  int[] numBlackPixelsRight;
  int[] blackPixelStopRight;

  BuildingMask(String maskPath)
  {
    maske = loadImage(maskPath);
    
    maskeCanvas = createGraphics(maske.width, maske.height);
    maskeCanvas.beginDraw();
    maskeCanvas.colorMode(HSB, 1, 1, 1, 1);
    maskeCanvas.background(1);
    maskeCanvas.endDraw();

    middlePixel = round(maskeCanvas.width / 2);
    numBlackPixelsLeft = new int[maske.height];
    blackPixelStopLeft = new int[maske.height];
    numBlackPixelsRight = new int[maske.height];
    blackPixelStopRight = new int[maske.height];
  
    maske.loadPixels();
    
    for(int y = 0; y < maske.height; y++)
    {
      for(int x = 0; x < maske.width; x++)
      {
        int index = x + y * maske.width;
        int a = (maske.pixels[index] >> 24) & 0xFF;
        if(a == 255)
        {
          if(x < middlePixel)
          {
            numBlackPixelsLeft[y]++;
            blackPixelStopLeft[y] = x + 1; // to remove weird color edge
          }
          else 
          {
            numBlackPixelsRight[y]++;
            blackPixelStopRight[y] = x + 1; // to remove weird color edge
          }
          
        }
      }
    }
  }

  void applyCanvas(PGraphics copyCanvas)
  {
    float downScale = (float) maskeCanvas.height / (float) copyCanvas.height;
    float newWidth = copyCanvas.width * downScale;
    float newHeight = copyCanvas.height * downScale;

    //--> draw to maskeCanvas

    maskeCanvas.beginDraw();
    //maskeCanvas.noSmooth();
    maskeCanvas.image(copyCanvas, (maskeCanvas.width/2)-(newWidth/2), (maskeCanvas.height/2)-(newHeight/2), newWidth, newHeight);
    maskeCanvas.endDraw();

    //--> Move the pixels baby!

    maskeCanvas.loadPixels();

    for(int y = 0; y < maske.height; y++)
    {
      // left mask
    
      int numPixelsToDisplace = blackPixelStopLeft[y] - numBlackPixelsLeft[y];
    
      for(int x = 0; x < numPixelsToDisplace; x++)
      {
        int oldX = blackPixelStopLeft[y] - (numPixelsToDisplace - x);
        int oldIndex = oldX + y * maskeCanvas.width;
        int newIndex = x + y * maskeCanvas.width;
        maskeCanvas.pixels[newIndex] = maskeCanvas.pixels[oldIndex];
      }
    
      // right mask
    
      numPixelsToDisplace = maskeCanvas.width - blackPixelStopRight[y];
    
      for(int x = maskeCanvas.width - 1; x > maskeCanvas.width - 1 - numPixelsToDisplace; x--)
      {
        int oldX = x - numBlackPixelsRight[y];
        int oldIndex = oldX + y * maskeCanvas.width;
        int newIndex = x + y * maskeCanvas.width;
        maskeCanvas.pixels[newIndex] = maskeCanvas.pixels[oldIndex];
      }
    }
    
    maskeCanvas.updatePixels();
    
    maskeCanvas.beginDraw();
    maskeCanvas.image(maske, 0, 0);
    maskeCanvas.endDraw();    
  }
}