class ColorScheme
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
  int moreColorsSaturationEasing;
  int moreColorsBrightnessEasing;
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
    nums.add(round(random(5, 8)), 1);
    numColors = nums.getRandom();
  }

  // Choose: Color Distance
  //----------------------------------------------------------------

  void chooseColorDistance()
  {
    colorDistance = random(10, 180) / 360.0;
  }

  // Choose: More Colors
  //----------------------------------------------------------------

  void chooseMoreColors()
  {
    WeightedRandomSet<Integer> nums = new WeightedRandomSet<Integer>();
    nums.add(0, 1);
    nums.add(round(random(2, 3)), 1);
    //nums.add(round(random(2, 10)), 1);
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
    //bases.add(0.2, 5);
    //bases.add(0.3, 4);
    bases.add(0.5, 3);
    bases.add(0.6, 2);
    moreColorsSaturationBase = bases.getRandom();
  }

  // Choose: More Colors Brightness Base
  //----------------------------------------------------------------

  void chooseMoreColorsBrightnessBase()
  {
    WeightedRandomSet<Float> bases = new WeightedRandomSet<Float>();
    //bases.add(0.2, 5);
    //bases.add(0.3, 4);
    bases.add(0.5, 3);
    bases.add(0.6, 2);
    moreColorsBrightnessBase = bases.getRandom();
  }

  // Choose: More Colors Saturation Easing
  //----------------------------------------------------------------

  void chooseMoreColorsSaturationEasing()
  {
    WeightedRandomSet<Integer> easings = new WeightedRandomSet<Integer>();
    easings.add(LINEAR, 1);
    //easings.add(SINE_IN, 1);
    //easings.add(SINE_OUT, 1);
    //easings.add(QUAD_IN, 1);
    //easings.add(QUAD_OUT, 1);
    //easings.add(QUINT_IN, 1);
    //easings.add(QUINT_OUT, 1);
    //easings.add(QUART_IN, 1);
    //easings.add(QUART_OUT, 1);
    moreColorsSaturationEasing = easings.getRandom();
  }

  // Choose: More Colors Brightness Easing
  //----------------------------------------------------------------

  void chooseMoreColorsBrightnessEasing()
  {
    WeightedRandomSet<Integer> easings = new WeightedRandomSet<Integer>();
    easings.add(LINEAR, 1);
    //easings.add(SINE_IN, 1);
    //easings.add(SINE_OUT, 1);
    //easings.add(QUAD_IN, 1);
    //easings.add(QUAD_OUT, 1);
    //easings.add(QUINT_IN, 1);
    //easings.add(QUINT_OUT, 1);
    //easings.add(QUART_IN, 1);
    //easings.add(QUART_OUT, 1);
    moreColorsSaturationEasing = easings.getRandom();
  }

  // Choose: Saturation Scale
  //----------------------------------------------------------------

  void chooseSaturationScale()
  {
    WeightedRandomSet<Float> scales = new WeightedRandomSet<Float>();
    scales.add(1.0, 1);
    //scales.add(random(0.4, 1), 1);
    saturationScale = scales.getRandom();
  }

  // Choose: Brightness Scale
  //----------------------------------------------------------------

  void chooseBrightnessScale()
  {
    WeightedRandomSet<Float> scales = new WeightedRandomSet<Float>();
    scales.add(1.0, 1);
    //scales.add(random(0.4, 1), 1);
    brightnessScale = scales.getRandom();
  }

  // Choose: Sort Mode
  //----------------------------------------------------------------

  void chooseSortMode()
  {
    WeightedRandomSet<Integer> ran = new WeightedRandomSet<Integer>();
    ran.add(DISTANCE_SORT, 10);
    ran.add(ODD_SORT, 10);
    ran.add(BRIGHTNESS_SORT, 10);
    ran.add(SATURATION_SORT, 10);
    sortMode = ran.getRandom();
  }

  // Choose: Sort Reversed
  //----------------------------------------------------------------

  void chooseSortReversed()
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
    backgrounds.add(FIRST, 1);
    backgrounds.add(MIDDLE, 1);
    backgrounds.add(LAST, 1);
    backgrounds.add(DARKGRAY, 1);
    backgrounds.add(WHITE, 1);
    backgroundMode = backgrounds.getRandom();
  }

  // Get Front Colors
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
    
    int baseColorNum = colors.size();

    for(int i = 0; i < baseColorNum; i++)
    {
      for(int j = 0; j < moreColors; j++)
      {
        TColor newColor = new TColor(colors.get(0));

        float val;

        if(moreColorsMode == SAT || moreColorsMode == BRISAT)
        {
          Easing easing = getEasing(moreColorsSaturationEasing);
          val = easing.calcEasing(j, moreColorsSaturationBase, 1-moreColorsSaturationBase, moreColors);
          newColor.setSaturation(val);
        }
  
        if(moreColorsMode == BRI || moreColorsMode == BRISAT)
        {
          Easing easing = getEasing(moreColorsBrightnessEasing);
          val = easing.calcEasing(j, moreColorsBrightnessBase, 1-moreColorsBrightnessBase, moreColors);
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
    else if(sortMode == ODD_SORT)
    {
      ColorList sorted = colors.sortByDistance(sortReversed == 1);
      ColorList odd = new ColorList();
      for(int i = 0; i < sorted.size()/2; i++)
      {
        odd.add(sorted.get(i));
        odd.add(sorted.get((sorted.size() - 1) - i));
      }
      colors = odd;
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

  // Get Background Color
  //----------------------------------------------------------------

  TColor getBackgroundColor(ColorList colors)
  {
    if(backgroundMode == DARKEST)         return (TColor) colors.getDarkest();
    else if(backgroundMode == BRIGHTEST)  return (TColor) colors.getLightest();
    else if(backgroundMode == FIRST)      return (TColor) colors.get(0);
    else if(backgroundMode == MIDDLE)     return (TColor) colors.get(floor(colors.size() / 2));
    else if(backgroundMode == LAST)       return (TColor) colors.get(colors.size() - 1);
    else if(backgroundMode == DARKGRAY)   return (TColor) TColor.newHSV(0, 0, 0.1);
    else                                  return (TColor) TColor.newHSV(0, 0, 1);
  }

  // Get Easing
  //----------------------------------------------------------------

  Easing getEasing(int easingNum)
  {
    if(easingNum == LINEAR)           return Ani.LINEAR;
    else if(easingNum == SINE_IN )    return Ani.SINE_IN;
    else if(easingNum == SINE_OUT)    return Ani.SINE_OUT;
    else if(easingNum == QUAD_IN )    return Ani.QUAD_IN;
    else if(easingNum == QUAD_OUT)    return Ani.QUAD_OUT;
    else if(easingNum == QUINT_IN)    return Ani.QUINT_IN;
    else if(easingNum == QUINT_OUT)   return Ani.QUINT_OUT;
    else if(easingNum == QUART_IN)    return Ani.QUART_IN;
    else                              return Ani.QUART_OUT;
  }

  // Print Vars
  //----------------------------------------------------------------

  void printVars()
  {
    println("hue: " + hue);
    println("numColors: " + numColors);
    println("colorDistance: " + colorDistance);
    println("moreColors: " + moreColors);
    println("moreColorsMode: " + moreColorsMode);
    println("moreColorsSaturationBase: " + moreColorsSaturationBase);
    println("moreColorsBrightnessBase: " + moreColorsBrightnessBase);
    println("moreColorsSaturationEasing: " + moreColorsSaturationEasing);
    println("moreColorsBrightnessEasing: " + moreColorsBrightnessEasing);
    println("saturationScale: " + saturationScale);
    println("brightnessScale: " + brightnessScale);
    println("sortMode: " + sortMode);
    println("sortReversed: " + sortReversed);
    println("backgroundMode: " + backgroundMode);
  }
}