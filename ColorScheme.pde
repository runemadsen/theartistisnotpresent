abstract class ColorScheme
{
  // Default Properties
  //----------------------------------------------------------------

  float hue = 0;
  float angle = 0;
  int   moreColors = 0;
  int   moreColorsType = 0;
  float moreColorsSatLow = 1;
  float moreColorsBriLow = 1;
  int   moreColorsSatEasing = 0;
  int   moreColorsBriEasing = 0;
  float scaleSat = 1;
  float scaleBri = 1;
  int   sortMode;
  int   sortReversed;

  ColorScheme() 
  {
    pickHue();
    if(hasAngleColors())          pickAngleColors();
    if(hasMoreColors())           pickMoreColors();
    if(hasVariableSaturation())   pickVariableSaturation();
    if(hasVariableBrightness())   pickVariableBrightness();
    if(hasFewerColors())          pickFewerColors();
    pickSortMode();
  }

	// Base methods that can be overridden
  //----------------------------------------------------------------

  public abstract ColorList getColors();
  public abstract String getName();
  public abstract int getIndex();
  public abstract boolean hasAngleColors();
  public abstract boolean hasMoreColors();
  public abstract boolean hasVariableSaturation();
  public abstract boolean hasVariableBrightness();
  public abstract boolean hasFewerColors();

	void pickHue()
	{
		hue = random(1);
	}

	void pickVariableSaturation()
	{
		scaleSat = random(0.4, 1);
	}

	void pickVariableBrightness()
	{
		scaleBri = random(0.4, 1);
	}

	void pickAngleColors() {}
	void pickMoreColors() {}
	void pickFewerColors() {}

  void pickSortMode()
  {
    WeightedRandomSet<Integer> ran = new WeightedRandomSet<Integer>();
    ran.add(DISTANCE_SORT, 10);
    ran.add(RANDOM_SORT, 10);
    ran.add(BRIGHTNESS_SORT, 10);
    ran.add(SATURATION_SORT, 10);
    sortMode = ran.getRandom();
    sortReversed = round(random(1));
  }

	/* Helpers
	--------------------------------------------------------- */

	void pickMoreColorsDisperse(int lowNum, int highNum)
	{
    WeightedRandomSet<Integer> typeChooser = new WeightedRandomSet<Integer>();
    typeChooser.add(BRI, 1);
    typeChooser.add(SAT, 1);
    typeChooser.add(BRISAT, 1);
    moreColorsType = typeChooser.getRandom();
	
		WeightedRandomSet<Float> lowChooser = new WeightedRandomSet<Float>();
		lowChooser.add(0.2, 5);
		lowChooser.add(0.3, 4);
		lowChooser.add(0.5, 3);
		lowChooser.add(0.6, 2);

		moreColors = round(random(lowNum, highNum));

    if(moreColorsType == SAT || moreColorsType == BRISAT)   moreColorsSatLow = lowChooser.getRandom();
		if(moreColorsType == BRI || moreColorsType == BRISAT)   moreColorsBriLow = lowChooser.getRandom();
	}

	ColorList pickMoreColorsFromColor(TColor col)
	{
		ColorList mores = new ColorList();

		for(int i = 0; i < moreColors; i++)
		{
			mores.add(new TColor(col));
		}

		for(int i = 0; i < mores.size(); i++)
		{
			float lowest;
			float val;

			if(moreColorsType == SAT || moreColorsType == BRISAT)
			{
				val = Ani.LINEAR.calcEasing(i, moreColorsSatLow, 1-moreColorsSatLow, mores.size());
				mores.get(i).setSaturation(val);
			}

			if(moreColorsType == BRI || moreColorsType == BRISAT)
			{
				val = Ani.LINEAR.calcEasing(i, moreColorsBriLow, 1-moreColorsBriLow, mores.size());
				mores.get(i).setSaturation(val);
			}
		}

		return mores;
	}

	ColorList scaleSaturations(ColorList colors, float s)
	{
		for(int i = 0; i < colors.size(); i++)
		{
			colors.get(i).setSaturation( colors.get(i).saturation() * s);
		}

    return colors;
	}

	ColorList scaleBrightnesses(ColorList colors, float s)
	{
		for(int i = 0; i < colors.size(); i++)
		{
			colors.get(i).setBrightness( colors.get(i).brightness() * s);
		}

    return colors;
	}

	ColorList addColors(ColorList colors, ColorList newColors)
	{
		for(int i = 0; i < newColors.size(); i++)
		{
			colors.add(newColors.get(i));
		}

    return colors;
	}

  ColorList sortColors(ColorList colors)
  {
    if(sortMode == DISTANCE_SORT)
    {
      return colors.sortByDistance(sortReversed == 1);
    }
    else if(sortMode == RANDOM_SORT)
    {
      return colors.sortByCriteria(new RandomAccessor(), sortReversed == 1);
    }
    else if(sortMode == BRIGHTNESS_SORT)
    {
      return colors.sortByCriteria(AccessCriteria.BRIGHTNESS, sortReversed == 1);
    }
    else
    {
      return colors.sortByCriteria(AccessCriteria.SATURATION, sortReversed == 1);
    }
  }
}