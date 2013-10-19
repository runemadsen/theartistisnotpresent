abstract class ColorScheme
{
  // Default Properties
  //----------------------------------------------------------------

  float hue;
  int numColors;
  float colorDistance;
  int moreColors;
  int moreColorsMode;
  float moreColorsSaturationBase;
  float moreColorsBrightnessBase;
  int moreColorsSatEasing;
  int moreColorsBriEasing;
  float saturationScale;
  float brightnessScale;
  int sortMode;
  int sortReversed;
  int backgroundMode;

  ColorScheme() 
  {
    chooseHue();
    chooseNumColors();
    chooseColorDistance();
    chooseMoreColors();
    chooseMoreColorsMode();
    chooseMoreColorsSaturationBase();
    chooseMoreColorsBrightnessBase();
    chooseMoreColorsSaturationEasing();
    chooseMoreColorsBrightnessEasing();  
    chooseSaturationScale();
    chooseBrightnessScale();
    chooseSortMode();
    chooseSortReversed();
    chooseBackgroundMode();
  }

  // Choose: Hue
  //----------------------------------------------------------------

  void chooseHue()
  {
    hue = random(1);
  }

  // Choose: Num Colors
  //----------------------------------------------------------------

  void chooseNumColors()
  {
    WeightedRandomSet<Integer> nums = new WeightedRandomSet<Integer>();
    nums.add(1, 1);
    nums.add(2, 1);
    nums.add(3, 1);
    nums.add(4, 1);
    nums.add(int(random(5, 8), 1);
    numColors = nums.getRandom();
  }

  // Choose: Color Distance
  //----------------------------------------------------------------

  void chooseColorDistance()
  {
    WeightedRandomSet<Float> distances = new WeightedRandomSet<Float>();
    distances.add(180.0 / 360.0, 1);
    distances.add(random(5, 90) / 360.0, 1);
    distances.add(random(90, 175) / 360.0, 1);
    distances.add(random(5, 180) / 360.0, 5);
    colorDistance = distances.getRandom();
  }

  // Choose: More Colors
  //----------------------------------------------------------------

  void chooseMoreColors()
  {
    WeightedRandomSet<Integer> nums = new WeightedRandomSet<Integer>();
    nums.add(0, 1);
    nums.add(int(random(2, 10), 1);
    moreColors = nums.getRandom();
  }

  // Choose: More Colors Mode
  //----------------------------------------------------------------

  void chooseMoreColorsMode()
  {
    WeightedRandomSet<Integer> modes = new WeightedRandomSet<Integer>();
    modes.add(BRI, 1);
    modes.add(SAT, 1);
    modes.add(BRISAT, 1);
    moreColorsMode = modes.getRandom();
  }

  // Choose: More Colors Saturation Base
  //----------------------------------------------------------------

  void chooseMoreColorsSaturationBase()
  {
    WeightedRandomSet<Float> bases = new WeightedRandomSet<Float>();
    bases.add(0.2, 5);
    bases.add(0.3, 4);
    bases.add(0.5, 3);
    bases.add(0.6, 2);
    moreColorsSaturationBase = bases.getRandom();
  }

  // Choose: More Colors Brightness Base
  //----------------------------------------------------------------

  void chooseMoreColorsBrightnessBase()
  {
    WeightedRandomSet<Float> bases = new WeightedRandomSet<Float>();
    bases.add(0.2, 5);
    bases.add(0.3, 4);
    bases.add(0.5, 3);
    bases.add(0.6, 2);
    moreColorsBrightnessBase = bases.getRandom();
  }

  // Choose: More Colors Saturation Easing
  //----------------------------------------------------------------

  void chooseMoreColorsSaturationEasing()
  {

  }

  // Choose: More Colors Brightness Easing
  //----------------------------------------------------------------

  void chooseMoreColorsBrightnessEasing()
  {

  }

  // Choose: Saturation Scale
  //----------------------------------------------------------------

  void chooseSaturationScale()
  {
    WeightedRandomSet<Float> scales = new WeightedRandomSet<Float>();
    scales.add(1.0, 1);
    scales.add(random(0.4, 1), 4);
    saturationScale = scales.getRandom();
  }

  // Choose: Brightness Scale
  //----------------------------------------------------------------

  void chooseBrightnessScale()
  {
    WeightedRandomSet<Float> scales = new WeightedRandomSet<Float>();
    scales.add(1.0, 1);
    scales.add(random(0.4, 1), 1);
    brightnessScale = scales.getRandom();
  }

  // Choose: Sort Mode
  //----------------------------------------------------------------

  void chooseSortMode()
  {
    WeightedRandomSet<Integer> ran = new WeightedRandomSet<Integer>();
    ran.add(DISTANCE_SORT, 10);
    ran.add(RANDOM_SORT, 10);
    ran.add(BRIGHTNESS_SORT, 10);
    ran.add(SATURATION_SORT, 10);
    sortMode = ran.getRandom();
  }

  // Choose: Sort Reversed
  //----------------------------------------------------------------

  void chooseSortMode()
  {
    sortReversed = round(random(1));
  }

  // Choose: Background Mode
  //----------------------------------------------------------------

  void chooseBackgroundMode()
  {
    WeightedRandomSet<Integer> backgrounds = new WeightedRandomSet<Integer>();
    backgrounds.add(DARKEST, 1);
    backgrounds.add(BRIGHTEST, 1);
    backgrounds.add(RANDOM, 1);
    backgrounds.add(DARKGRAY, 1);
    backgrounds.add(WHITE, 1);
    backgroundMode = backgrounds.getRandom();
  }

  // Getters
  //----------------------------------------------------------------

  ColorList getColors()
  {
    ColorList colors = new ColorList();

    //--> Base Color

    colors.add(TColor.newHSV(hue, 1, 1));

    //--> Create Colors

    for(int i = 0; i < numColors; i++)
    {
      colors.add(TColor.newHSV(colors.get(0).hue() + (colorDistance*(i+1)), 1, 1));
    }

    //--> More Colors

    for(int i = 0; i < colors.size(); i++)
    {
      for(int j = 0; j < moreColors; j++)
      {
        TColor newColor = new TColor(colors.get(0));

        float val;

        if(moreColorsMode == SAT || moreColorsMode == BRISAT)
        {
          val = Ani.LINEAR.calcEasing(j, chooseMoreColorsSaturationBase, 1-chooseMoreColorsSaturationBase, moreColors);
          newColor.setSaturation(val);
        }
  
        if(moreColorsMode == BRI || moreColorsMode == BRISAT)
        {
          val = Ani.LINEAR.calcEasing(j, chooseMoreColorsBrightnessBase, 1-chooseMoreColorsBrightnessBase, moreColors);
          newColor.setSaturation(val);
        }

        colors.add(newColor);
      }
    }

    //--> Saturation Scale

    for(int i = 0; i < colors.size(); i++)
    {
      colors.get(i).setSaturation( colors.get(i).saturation() * saturationScale);
    }

    //--> Brightness Scale

    for(int i = 0; i < colors.size(); i++)
    {
      colors.get(i).setBrightness( colors.get(i).brightness() * brightnessScale);
    }

    //--> Sort Colors

    if(sortMode == DISTANCE_SORT)
    {
      colors = colors.sortByDistance(sortReversed == 1);
    }
    else if(sortMode == RANDOM_SORT)
    {
      colors = colors.sortByCriteria(new RandomAccessor(), sortReversed == 1);
    }
    else if(sortMode == BRIGHTNESS_SORT)
    {
      colors = colors.sortByCriteria(AccessCriteria.BRIGHTNESS, sortReversed == 1);
    }
    else
    {
      colors = colors.sortByCriteria(AccessCriteria.SATURATION, sortReversed == 1);
    }

    return colors;
  }
}