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

	ColorList colors = new ColorList();

  ColorScheme() 
  {
    pickHue();
    if(hasAngleColors())          pickAngleColors();
    if(hasMoreColors())           pickMoreColors();
    if(hasVariableSaturation())   pickVariableSaturation();
    if(hasVariableBrightness())   pickVariableBrightness();
    if(hasFewerColors())          pickFewerColors();
  }

	// Main
  //----------------------------------------------------------------

  void display()
  {
    int rectSize = 200;

    for(int i = 0; i < colors.size(); i++)
    {
      TColor col = colors.get(i);
      noStroke();
      fill(col.hue(), col.saturation(), col.brightness());
      rect((i % 3) * rectSize, ((i/3) % 3) * rectSize, rectSize, rectSize);
    }
  }

	// Base methods that can be overridden
  //----------------------------------------------------------------

  public abstract String getName();
  public abstract boolean hasAngleColors();
  public abstract boolean hasMoreColors();
  public abstract boolean hasVariableSaturation();
  public abstract boolean hasVariableBrightness();
  public abstract boolean hasFewerColors();

	void pickHue()
	{
		hue = random(1);
		colors.add(TColor.newHSV(hue, 1, 1));
	}

	void pickVariableSaturation()
	{
		scaleSat = random(0.4, 1);
		scaleSaturations(scaleSat);
	}

	void pickVariableBrightness()
	{
		scaleBri = random(0.4, 1);
		scaleBrightnesses(scaleBri);
	}

	void pickAngleColors() {}
	void pickMoreColors() {}
	void pickFewerColors() {}

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

	void pickMoreColorsFromColor(TColor col)
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

		addColors(mores);
	}

	void scaleSaturations(float s)
	{
		for(int i = 0; i < colors.size(); i++)
		{
			colors.get(i).setSaturation( colors.get(i).saturation() * s);
		}
	}

	void scaleBrightnesses(float s)
	{
		for(int i = 0; i < colors.size(); i++)
		{
			colors.get(i).setBrightness( colors.get(i).brightness() * s);
		}
	}

	void addColors(ColorList newColors)
	{
		for(int i = 0; i < newColors.size(); i++)
		{
			colors.add(newColors.get(i));
		}
	}
}