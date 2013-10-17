class Population 
{
  float mutationRate;
  Sample[] population;
  ArrayList<Sample> matingPool;
  int curGeneration = 0;

  Population(float _mutationRate, int populationNum)
  {
    mutationRate = _mutationRate;
    population = new Face[populationNum];
    matingPool = new ArrayList<Sample>();
    
    for (int i = 0; i < population.length; i++)
    {
      population[i] = new Sample();
    }
  }

  void display()
  {
    for (int i = 0; i < population.length; i++)
    {
      population[i].display();
    }
  }

  void selection()
  {  
    matingPool.clear();

    for (int i = 0; i < population.length; i++)
    {
      // WE COULD MULTIPLY THIS WITH 100 OR SOMETHING LIKE DAN
      int fitness = population[i].label;
      
      for (int j = 0; j < fitness; j++)
      {
        matingPool.add(population[i]);
      }
    }
  }  

  void reproduction() 
  {
    for (int i = 0; i < population.length; i++)
    {
      int m = int(random(matingPool.size()));
      int d = int(random(matingPool.size()));
     
      Sample mom = matingPool.get(m);
      Sample dad = matingPool.get(d);
      
      Sample child = mom.crossover(dad);
      child.mutate(mutationRate);
      population[i] = child;
    }

    curGeneration++;
  }

  int getCurGeneration()
  {
    return curGeneration;
  }
}