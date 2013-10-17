class ColorSchemeAnalogous extends ColorScheme
{
	public String getName() { return "Analogous"; };

	public boolean hasAngleColors() { return true; }
  public boolean hasMoreColors() { return random(1) < 0.5; }
  public boolean hasVariableSaturation()  { return random(1) < 0.8; }
  public boolean hasVariableBrightness()  { return random(1) < 0.5; }
  public boolean hasFewerColors()  { return random(1) < 0.5; }

	ColorSchemeAnalogous() {}

	// Get Colors
	//----------------------------------------------------------------

	ColorList getColors()
	{
		ColorList colors = new ColorList();

		// hue
		colors.add(TColor.newHSV(hue, 1, 1));

		// angle colors
		for(int i = 0; i < 4; i++)
		{
			colors.add(TColor.newHSV(colors.get(0).hue() + (angle*(i+1)), 1, 1));
		}
		println(angle);

		// more colors
		addColors(colors, pickMoreColorsFromColor(colors.get(0)));
		addColors(colors, pickMoreColorsFromColor(colors.get(1)));

		// variable saturation
		colors = scaleSaturations(colors, scaleSat);

		// variable brightness
		colors = scaleBrightnesses(colors, scaleBri);

		// fewer colors

		return colors;
	}

	// Choose Vars
	//----------------------------------------------------------------

	void pickAngleColors()
	{
		angle = random(5.0, (180.0 / (float) 4)) / 360f;
	}

	void pickMoreColors()
	{
		pickMoreColorsDisperse(2, 6);
	}
}