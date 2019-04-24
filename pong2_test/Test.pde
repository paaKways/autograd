//class for autoGrad assignment 2

/*
Uncomment line 42 and comment line 41 in getLines function if using with APDE
In apde, the students assignment file has to be stored in a folder called data
the data folder should be inside the class's folder and the path should be the
filename. 
APDE clone details
Remote: https://Suacode@bitbucket.org/Suacode/automaticgradingsystem.git  
Local: autoGrad
Username: Suacodefacilitators
Password: Suacodefacilitators10!
*/

class Test {

  String[] fileLines;
  ArrayList<String> linesFiltered = new ArrayList<String>(); //filtered lines ie no empty lines
  ArrayList<Integer> backgrounds = new ArrayList<Integer>(); //background lines
  ArrayList<Integer> rects = new ArrayList<Integer>(); //rect lines
  ArrayList<Integer> ellipses = new ArrayList<Integer>(); //ellipse lines
  ArrayList<Integer> texts = new ArrayList<Integer>(); //text lines
  ArrayList<Integer> lines = new ArrayList<Integer>(); //line lines
  ArrayList<Integer> fills = new ArrayList<Integer>(); //fill lines
  ArrayList<Integer> strokes = new ArrayList<Integer>(); //stroke lines
  ArrayList<Integer> variableLines = new ArrayList<Integer>(); //lines with variables

  HashMap<String,String> variablesHashMap = new HashMap<String,String>();

  float totalScore = 20; // total score of the student
  float majorExceptions = 3; //deductions that generate exceptions, ie code that won't likely compile
  int gap = 5; //interval due to floating divisions
  int screenWidth, screenHeight; //height and width of screen
  float deduction = 1; //deduction for each section missed
  float commentPercentage = 0.3; //percentage error for floatation divisions
  int tabLength = 2;

  Test() { //empty constructor for class
  }

  /*
  In the function below, I'm reading the file into an array of strings. Each element in the array is a line in the file
   */
  void getLines() { //reads file
    try
    {
      fileLines = loadStrings("../Assignment2/Assignment2.pde"); //comment if you're using APDE
      //fileLines = loadStrings("Assignment2.pde"); //uncomment if you're using APDE
    }
    catch (Exception e) //IO error
    {
      println("Couldn't load file");
      totalScore -= majorExceptions;
    }
  }
  

  /*
   In the function below, I'm checking the student indented properly
   I have a var called tabs that increments when it sees a {
   And decrements when iit sees a }
   if at the end tabs < 0 there's an unmatched }
   if at the end tabs > 0 there's an unmatched {
   */
  void checkTabs()
  {
    boolean tabsFlag = false;
    int tabs = 0;
    try
    {
      for (int i = 0; i < fileLines.length; i++) {
        for (int j = 0; j < tabs; j++)
        {
          if (fileLines[i].length() > tabs)
          {
            if (fileLines[i].charAt(j) != ' ') //wrongly under indented
            {
              tabsFlag = true;
            }
            if (fileLines[i].charAt(tabs) == ' ')//wrongly over indented
            {
              tabsFlag = true;
            }
          }
        }
        if (match(fileLines[i], "\\{") != null) //find {
        {
          tabs += tabLength;
        } else if (match(fileLines[i], "\\}") != null) //find }
        {
          tabs -= tabLength;
        }
      }

      if (tabs < 0) //unmatched }
      {
        println("Unmatched }");
        totalScore -= deduction;
      } else if (tabs != 0) //unmatched {
      {
        println("Unmatched {");
        totalScore -= deduction;
      }
      if (tabsFlag) //wrong indentation
      {
        println("Code not indented properly");
        totalScore -= deduction;
      }
    }
    catch (Exception e) //catch exception
    {
      println("Check tabs in file");
      totalScore -= majorExceptions;
    }
  }

  /*
    Loops through the lines in the file and removes white lines
   Also check for at least two empty lines to assume grouped sections of code
   */

  void removeEmptyLines() { //removes empty lines
    try
    {
      int emptyLines = 0;
      for (int i = 0; i < fileLines.length; i++) {
        if (fileLines[i] != null && fileLines[i].length() > 0) //if lines have no content or a null string
          linesFiltered.add(trim(fileLines[i]));
        else
          emptyLines++;
      }
      if (emptyLines < 2) //if at least two lines are empty
      {
        println("Improper code grouping");
        totalScore -= deduction;
      }
    }
    catch (Exception e) //catch exception
    {
      println("Couldn't remove empty lines in file");
      totalScore -= majorExceptions;
    }
  }

  /*
    checks to see if there are more two semicolons on one line. That means there are two statements on one line.
   deduct points if the size of the array returned by matchAll is greater than 1
   */
  void checkStatementsPerLine()
  {
    try
    {
      boolean statementsFlag = false;
      for (int i = 1; i < linesFiltered.size(); i++) //start from the second line to escape the comment on the first line
      {
        if (matchAll(linesFiltered.get(i), ";") != null) //if line has matched semi colon
        {
          if (matchAll(linesFiltered.get(i), ";").length > 1)//get number of semi colon matches
          {
            statementsFlag = true;
          }
        }
      }

      if (statementsFlag)
      {
        println("Insufficient comments");
        totalScore -= deduction;
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check statements per line");
      totalScore -= majorExceptions;
    }
  } 

  /*
  This line parses the first comment in the line and gets the size of the screen used by the device, it just keeps splitting by tokens
   Follow the name of the variables to understand what's going on with each splitTokens
   */

  void getScreenSize() //gets first comment line
  {
    try
    {
      String[] splitByComma = splitTokens(linesFiltered.get(0), ","); 

      String[] splitByEqualsLeft = splitTokens(splitByComma[0], "=");
      String[] splitByEqualsRight = splitTokens(splitByComma[splitByComma.length - 1], "=");

      String[] splitBySpacesLeft = splitTokens(splitByEqualsLeft[1]);
      String[] splitBySpacesRight = splitTokens(splitByEqualsRight[1]);

      //get width
      int i = 0;
      while (!(isNumeric(splitBySpacesLeft[i])) && i < splitBySpacesLeft.length) //parse for numeric value
      {
        i++;
      }

      screenWidth = int(trim(splitBySpacesLeft[i]));//get screen height

      if (i == (splitBySpacesLeft.length - 1) && i != 0) //if invalid width, quit program and give zero
      {
        println("Check width in code");
        totalScore = 0;
      }

      //get height
      i = 0;
      while (!(isNumeric(splitBySpacesRight[i])) && i < splitBySpacesRight.length) //parse for numeric value
      {
        i++;
      }

      if (i == (splitBySpacesRight.length - 1) && i != 0) //if invalid height, quit program and give zero
      {
        println("Check height in code");
        totalScore = 0;
      }

      screenHeight = int(trim(splitBySpacesRight[i])); //get screen height
    } 
    catch (Exception e)
    {
      println("Check sytax of width and height at first line of code");
      totalScore -= majorExceptions;
    }
  }

  /*
   This function basically verifies the values gotten from the first comment are the same as the values in the size function 
   Follow the name of the variables to understand what's going on with each splitTokens
   */

  void checkSize() //verify screen width and height in size function
  {
    boolean sizeFlag = false;
    try
    {
      String[] splitByLeftBrace;
      String[] splitByCommas;
      for (int i = 0; i < linesFiltered.size(); i++) //loop through lines
      {
        if (match(linesFiltered.get(i), "^size.*$") != null) //look for size with regex
        {
          splitByLeftBrace = splitTokens(linesFiltered.get(i), "(");
          splitByCommas = splitTokens(splitByLeftBrace[1], ",)");
          if (screenWidth != int(trim(splitByCommas[0])) || screenHeight != int(trim(splitByCommas[1]))) //if invalid width and height
          {
            sizeFlag = true;
            screenWidth = int(trim(splitByCommas[0]));
            screenHeight = int(trim(splitByCommas[1]));
          }
        }
      }
      if (sizeFlag)
      {
        println("Check the size function width and height");  
        totalScore -= deduction;
      }
    }
    catch (Exception e) 
    {
      println("Couldn't verify size function");
      totalScore -= majorExceptions;
    }
  }

  /*
  Counts the number of comments, finds the percentage of comments within the file
   */

  void checkComments() //check number of comments
  {
    try
    {
      int comments = 0;
      for (int i = 1; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "//") != null)//look for comments with regex
        {
          comments++;
        }
      }
      if (float(comments)/linesFiltered.size() < commentPercentage) //check comment percentage
      {
        println("Insufficient comments");
        totalScore -= deduction;
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check comments");
      totalScore -= majorExceptions;
    }
  }

  /*
  It just checks the number of strokes in the file and makes sure all the arguments are the same
   Follow the name of the variables to understand what's going on with each splitTokens
   */
  void checkStrokes() //check strokes
  {
    try
    {
      String[] splitByLeftBrace;
      String[] splitByCommas;
      ArrayList<Integer> parameters = new ArrayList<Integer>();
      boolean wrongFlag = false;
      for (int i = 0; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "^stroke.*$") != null)//look for stroke with regex
        {
          strokes.add(i);
        }
      }

      if (strokes.size() == 0) //if no stroke
      {
        totalScore -= deduction;
        println("Use at least one stroke function");
      }

      splitByLeftBrace = splitTokens(linesFiltered.get(strokes.get(0)), "(");
      splitByCommas = splitTokens(splitByLeftBrace[1], ",)");

      int j = 0;

      while (isNumeric(trim(splitByCommas[j])) && j < splitByCommas.length) //get parameters
      {
        parameters.add(int(trim(splitByCommas[j])));
        j++;
      }
      int parameterSize = 0;
      parameterSize = parameters.size();
      parameters.clear();
      for (int m = 0; m < strokes.size(); m++) {
        splitByLeftBrace = splitTokens(linesFiltered.get(strokes.get(m)), "(");
        splitByCommas = splitTokens(splitByLeftBrace[1], ",)");

        j = 0;
        while (isNumeric(trim(splitByCommas[j])) && j < splitByCommas.length) //get parameters
        {
          parameters.add(int(trim(splitByCommas[j])));
          j++;
        }
      }
      if (parameterSize == 1) //compares the parameters in the subsequent stroke functions
      {
        for (int m = 0; m < strokes.size(); m++) {
          if (int(parameters.get(m)) != int(parameters.get(m+1)))
          {
            wrongFlag = true;
          }
        }
      } else if (parameterSize == 3) //compares the parameters in the subsequent stroke functions
      {
        for (int m = 0; m < (3 * (strokes.size() - 1)); m++) {
          if (int(parameters.get(m)) != int(parameters.get(m+3)))
          {
            wrongFlag = true;
          }
        }
      }

      if (wrongFlag)
      {
        totalScore -= deduction;
        println("Shapes have different outline colors");
      }
    }
    catch (Exception e) 
    {
      println("Check strokes function");
      totalScore -= majorExceptions;
    }
  }

  /*
  gets the parameters of the rects into an array
   Follow the name of the variables to understand what's going on with each splitTokens
   */

void checkRects() //check rects
  {
    try
    {
      //ArrayList<Integer> parameters = new ArrayList<Integer>();     
      String[] splitByLeftBrace1;
      String[] splitByCommas1;
      int max = 0;      
      //int coordinateFlag = 0;

      for (int i = 0; i < linesFiltered.size(); i++) 
      {
        if (match(linesFiltered.get(i), "^rect.*$") != null) //look for rect with regex
        {
          rects.add(i);
        }
      }

      int j = 0;
      for (int m = 0; m < rects.size(); m++) {
        splitByLeftBrace1 = splitTokens(linesFiltered.get(rects.get(m)), "(");
        splitByCommas1 = trim(splitTokens(splitByLeftBrace1[1], ",)"));
        
        j = 0;
        while (j < splitByCommas1.length && j < 4) //get parameters
        {
          //put something here
          if(isNumeric(splitByCommas1[j])) // check for magic numbers
          { 
            println("Use of magic numbers as parameters for rect " + (m + 1) ); // 'm + 1' indicates the affected rect or paddle
            totalScore -= deduction;
            break;
          }
          j++;
        }
        max = max + j;
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check rects");
      totalScore -= majorExceptions;
    }
  }

  /*
  It checks the color interactions between the various shapes
   Very long function and doing a number of things
   1. Two rects should have the same color
   2. Rects and shapes should have different colors
   3. Shapes and background have different colors
   Follow the name of the variables to understand what's going on with each splitTokens
   */

  /*
   This funciton assumes that if the parameter count for fill/stroke are different then the colors have to be different
   This is not necessarily the case as fill(0) = fill(0,0,0) and fill(255) = fill(255,255,255) 
   but I don't expect the students to go to that length to try and beat the system, I mean, at what cost??
   */

  void shapeColorInteractions()
  {
    try
    {
      ArrayList<Integer> rect2FillParameters = new ArrayList<Integer>();
      ArrayList<Integer> rect1FillParameters = new ArrayList<Integer>();
      ArrayList<Integer> fillParameters = new ArrayList<Integer>();
      ArrayList<Integer> backgroundParameters = new ArrayList<Integer>();
      ArrayList<Integer> ellipseFillParameters = new ArrayList<Integer>();
      String[] splitByLeftBrace1;
      String[] splitByCommas1;
      String[] splitByLeftBrace2;
      String[] splitByCommas2;
      String[] splitByLeftBrace3;
      String[] splitByCommas3;
      String[] splitByLeftBrace;
      String[] splitByCommas;
      boolean closestFlag = false;
      int closest1 = 0; //checks for the closest fill for the first paddle
      int closest2 = 0; //checks for the closest fill ot the second paddle
      int closest = 0; //checking the closest fill for the ellipse
      int n = 0;
      int k = 0;
      int j = 0;
      int cl1_index = -1;
      int cl2_index = -1;
      int cl_index = -1;

      for (int i = 0; i < fills.size(); i++) //get closest fill to paddle1
      {
        if (fills.get(i) < rects.get(0))
        {
          closest1 = fills.get(i);
          cl1_index = i;
        }
      }

      if (closest1 == 0)//if closest fill to paddle 1 exists
      {
        for (int i = fills.size(); i > 0; i--) //get closest fill to paddle1
        {
          if (fills.get(i-1) > rects.get(0))
          {
            closest1 = fills.get(i-1);
            cl1_index = i-1;
            break;
          }
        }
      }

      for (int i = 0; i < fills.size(); i++) //get closest fill to paddle2
      {
        if (fills.get(i) < rects.get(1))
        {
          closest2 = fills.get(i);
          cl2_index = i;
        }
      }

      if (closest2 == 0)//if closest fill to paddle2 exists
      {
        for (int i = fills.size(); i > 0; i--) //get closest fill to paddle2
        {
          if (fills.get(i-1) > rects.get(1))
          {
            closest2 = fills.get(i-1);
            cl2_index = i-1;
            break;
          }
        }
      }


      for (int i = 0; i < fills.size(); i++) //get closest fill to ellipse
      {
        if (fills.get(i) < ellipses.get(0))
        {
          closest = fills.get(i);
          cl_index = i;
        }
      }

      if (closest == 0) //if closest fill to ellipse exists
      {
        for (int i = fills.size(); i > 0; i--) //get closest fill to ellipse
        {
          if (fills.get(i-1) > ellipses.get(0))
          {
            closest = fills.get(i-1);
            cl_index = i-1;
            break;
          }
        }
      }

      splitByLeftBrace3 = splitTokens(linesFiltered.get(backgrounds.get(0)), "(");
      splitByCommas3 = splitTokens(splitByLeftBrace3[1], ",)");

      while (isNumeric(trim(splitByCommas3[n])) && n < splitByCommas3.length) //get background's parameters
      {
        backgroundParameters.add(int(trim(splitByCommas3[n])));
        n++;
      }

      /*This section is for the color interactions between paddles and with backgrounds */

      if (closest1 != 0 && closest2 != 0) //if there're two fills beside both paddles
      {      
        splitByLeftBrace1 = splitTokens(linesFiltered.get(fills.get(cl1_index)), "(");
        splitByCommas1 = splitTokens(splitByLeftBrace1[1], ",)");
        splitByLeftBrace2 = splitTokens(linesFiltered.get(fills.get(cl2_index)), "(");
        splitByCommas2 = splitTokens(splitByLeftBrace2[1], ",)");
        j = 0;
        k = 0;
        while (isNumeric(trim(splitByCommas1[j])) && j < splitByCommas1.length) //get fill parameters for paddle1
        {
          fillParameters.add(int(trim(splitByCommas1[j])));
          j++;
        }
        while (isNumeric(trim(splitByCommas2[k])) && k < splitByCommas2.length) //get fill parameters for paddle2
        {
          fillParameters.add(int(trim(splitByCommas2[k])));
          k++;
        }

        if (j == 1 && k == 1) //single parameter
        {
          if (int(fillParameters.get(0)) != int(fillParameters.get(1)))
          {
            totalScore -= deduction;
            println("Paddles have different colors");
          }
          if (n == 1)
          {
            if ((int(backgroundParameters.get(0)) == int(fillParameters.get(0))) || int(backgroundParameters.get(0)) == int(fillParameters.get(1)))
            {
              closestFlag = true;
              totalScore -= deduction;
              println("Paddle has color as background");
            }
          }
        } else if (j == 3 && k == 3) //triple parameter
        {
          if (int(fillParameters.get(0)) != int(fillParameters.get(3)) || int(fillParameters.get(1)) != int(fillParameters.get(4)) || int(fillParameters.get(2)) != int(fillParameters.get(5)))
          {
            totalScore -= deduction;
            println("Paddles have different colors");
          }
          if (n == 3)
          {
            if ((int(backgroundParameters.get(0)) == int(fillParameters.get(0)) && int(backgroundParameters.get(1)) == int(fillParameters.get(1)) &&
              int(backgroundParameters.get(2)) == int(fillParameters.get(2))) || (int(backgroundParameters.get(0)) == int(fillParameters.get(3)) &&
              int(backgroundParameters.get(1)) == int(fillParameters.get(4)) &&  int(backgroundParameters.get(2)) == int(fillParameters.get(5))))
            {
              closestFlag = true;
              totalScore -= deduction;
              println("Paddle has color as background");
            }
          }
        } else
        {
          totalScore -= deduction;
          println("Paddles have different colors");
        }
      }

      /*This section looks at the ellipse's color interaction with either rect and with the background*/

      if (closest != 0) //fill before ellipse
      {
        if (closest1 != 0)//fill before paddle1
        {      
          splitByLeftBrace1 = splitTokens(linesFiltered.get(fills.get(cl1_index)), "(");
          splitByCommas1 = splitTokens(splitByLeftBrace1[1], ",)");

          j = 0;

          while (isNumeric(trim(splitByCommas1[j])) && j < splitByCommas1.length) //get paddle1 parameters
          {
            rect1FillParameters.add(int(trim(splitByCommas1[j])));
            j++;
          }
        } else
        {
          j = 0;
        }
        if (closest2 != 0) //fill before paddle2
        {
          splitByLeftBrace2 = splitTokens(linesFiltered.get(fills.get(cl2_index)), "(");
          splitByCommas2 = splitTokens(splitByLeftBrace2[1], ",)");
          k = 0;
          while (isNumeric(trim(splitByCommas2[k])) && k < splitByCommas2.length) //get paddle2 parameters
          {
            rect2FillParameters.add(int(trim(splitByCommas2[k])));
            k++;
          }
        } else
        {
          k = 0;
        }
        splitByLeftBrace = splitTokens(linesFiltered.get(fills.get(cl_index)), "(");
        splitByCommas = splitTokens(splitByLeftBrace[1], ",)");
        int t = 0;
        while (isNumeric(trim(splitByCommas[t])) && t < splitByCommas.length) //get ellipse parameters
        {
          ellipseFillParameters.add(int(trim(splitByCommas[t])));
          t++;
        }

        if (t == 1) //single parameter
        {
          if (t == j)
          {
            if (int(ellipseFillParameters.get(0)) == int(rect1FillParameters.get(0))) 
            {
              totalScore -= deduction;
              println("Ball has same color as left paddle");
            }
          }
          if (t == k)
          {
            if (int(ellipseFillParameters.get(0)) == int(rect2FillParameters.get(0)))
            {
              totalScore -= deduction;
              println("Ball has same color as right paddle");
            }
          }
          if (n == 1)
          {
            if ((int(backgroundParameters.get(0)) == int(ellipseFillParameters.get(0))))
            {
              totalScore -= deduction;
              println("Ball has color as background");
            }
          }
        } else if (t == 3) //triple parameters
        {
          if (t == k)
          {
            if (int(ellipseFillParameters.get(0)) == int(rect2FillParameters.get(0)) && int(ellipseFillParameters.get(1)) == int(rect2FillParameters.get(1)) 
              &&  int(ellipseFillParameters.get(2)) == int(rect2FillParameters.get(2)))
            {
              totalScore -= deduction;
              println("Ball has same color as right paddle");
            }
          }
          if (t == j)
          {
            if (int(ellipseFillParameters.get(0)) == int(rect1FillParameters.get(0)) && int(ellipseFillParameters.get(1)) == int(rect1FillParameters.get(1)) 
              &&  int(ellipseFillParameters.get(2)) == int(rect1FillParameters.get(2)))
            {
              totalScore -= deduction;
              println("Ball has same colors as left paddle");
            }
          }
          if (n == 3)
          {
            if ((int(backgroundParameters.get(0)) == int(ellipseFillParameters.get(0)) && int(backgroundParameters.get(1)) == int(ellipseFillParameters.get(1)) &&
              int(backgroundParameters.get(2)) == int(ellipseFillParameters.get(2))) || (int(backgroundParameters.get(0)) == int(ellipseFillParameters.get(3)) &&
              int(backgroundParameters.get(1)) == int(ellipseFillParameters.get(4)) &&  int(backgroundParameters.get(2)) == int(ellipseFillParameters.get(5))))
            {
              totalScore -= deduction;
              println("Ball has color as background");
            }
          }
        }
      }


      /*left paddle and background.*/
      if (closest1 != 0 && !closestFlag) //fill before paddle 1
      {      
        splitByLeftBrace1 = splitTokens(linesFiltered.get(fills.get(cl1_index)), "(");
        splitByCommas1 = splitTokens(splitByLeftBrace1[1], ",)");

        j = 0;

        while (isNumeric(trim(splitByCommas1[j])) && j < splitByCommas1.length)
        {
          rect1FillParameters.add(int(trim(splitByCommas1[j])));
          j++;
        }
        if (j == 1 && n == 1)
        {
          if ((backgroundParameters.get(0) == rect1FillParameters.get(0)))
          {
            totalScore -= deduction;
            println("Left Paddle has color as background");
          }
        }
        if (j == 3 && n == 3)
        {
          if ((int(backgroundParameters.get(0)) == int(rect1FillParameters.get(0)) && int(backgroundParameters.get(1)) == int(rect1FillParameters.get(1)) &&
            int(backgroundParameters.get(2)) == int(rect1FillParameters.get(2))))
          {
            totalScore -= deduction;
            println("Left Paddle has color as background");
          }
        }
      }

      /*right paddle and background*/
      if (closest2 != 0 && !closestFlag) //fill right paddle
      {      
        splitByLeftBrace2 = splitTokens(linesFiltered.get(fills.get(cl2_index)), "(");
        splitByCommas2 = splitTokens(splitByLeftBrace2[1], ",)");

        k = 0;

        while (isNumeric(trim(splitByCommas2[k])) && k < splitByCommas2.length)
        {
          rect1FillParameters.add(int(trim(splitByCommas2[k])));
          k++;
        }
        if (k == 1 && n == 1)
        {
          if ((int(backgroundParameters.get(0)) == int(rect1FillParameters.get(0))))
          {
            totalScore -= deduction;
            println("Right Paddle has color as background");
          }
        }
        if (k == 3 && n == 3)
        {
          if ((int(backgroundParameters.get(0)) == int(rect1FillParameters.get(0)) && int(backgroundParameters.get(1)) == int(rect1FillParameters.get(1)) &&
            int(backgroundParameters.get(2)) == int(rect1FillParameters.get(2))))
          {
            totalScore -= deduction;
            println("Right Paddle has color as background");
          }
        }
      }

      /*if no fill in code*/
      if (closest == 0 && closest1 == 0 && closest2 == 0)
      {
        totalScore -= deduction;
        println("Paddle and ball have the same color");
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check shape color interactions");
      totalScore -= majorExceptions;
    }
  }

  /*
  Finds the number of fills within the code
   */

  void checkFills() //check for fill
  {
    try
    {
      for (int i = 0; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "^fill.*$") != null) //look for fill with regex
        {
          fills.add(i);
        }
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check fills");
      totalScore -= majorExceptions;
    }
  }

  /*
  Finds the number of backgrounds within the code
   */

  void checkBackground() //check for background
  {
    try
    {
      for (int i = 0; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "^background.*$") != null) //look for background with regex
        {
          backgrounds.add(i);
        }
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check background");
      totalScore -= majorExceptions;
    }
  }

  /*
  Finds the number of texts within the code
   Makes sure two texts are on either side of the screen
   Follow the name of the variables to understand what's going on with each splitTokens  
   */
  void checkScores() //check for text
  {
    try
    {        
      //ArrayList<Integer> parameters = new ArrayList<Integer>();     
      String[] splitByLeftBrace;
      String[] splitByCommas;
      int max = 0;
      //int coordinateFlag = 0;
      boolean sizeFlag = true;

      for (int i = 0; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "^textSize.*$") != null) //look for textSize with regex
        {
          sizeFlag = false;
          if (texts.size() != 0)
          {
            totalScore -= deduction;
            println("size not set before text called");
          }
        }
        if (match(linesFiltered.get(i), "^text.*$") != null) //look for text with regex
        {
          texts.add(i);
        }
      }

      if (sizeFlag) //if no textSize was used
      {
        totalScore -= deduction;
        println("text size not set");
      }
      
      int j = 0;
      
      for (int m = 0; m < texts.size(); m++) 
      {
        splitByLeftBrace = splitTokens(linesFiltered.get(texts.get(m)), "(");
        splitByCommas = trim(splitTokens(splitByLeftBrace[1], ",)"));
        
        j = 0;
        while(j < splitByCommas.length) // 
        { 
          if(m < 1 && j < 2 && isNumeric(splitByCommas[j])) // check fo magic number in texSize() fxn. 'scoreSize'
          { 
            println(splitByCommas[j]);
            println("Use of magic numbers as parameters for textSize()");
            totalScore -= deduction;
            break;
          }
          
          if(m > 0 && j < 3 && isNumeric(splitByCommas[j])) // check for magic numbers for both text() fxns 'scores' 
          { 
            println("Use of magic numbers as parameters for text() " + m); // 'm' indicates the affected text fnx
            totalScore -= deduction;
            break;
          }
          j++;
        }
        max = max + j;
      }
    }
    catch (Exception e) 
    {
      println("Couldn't check scores");
      totalScore -= majorExceptions;
    }
  }

  /*
  Finds the number of ellipses within the code
   Makes sure the ellipse is at the center of the program
   Follow the name of the variables to understand what's going on with each splitTokens  
   */

  void checkEllipses()
  {
    try
    {
      //ArrayList<Integer> parameters = new ArrayList<Integer>();    
      String[] splitByLeftBrace;
      String[] splitByCommas;
      int max = 0;
      
      for (int i = 0; i < linesFiltered.size(); i++)
      {
        if (match(linesFiltered.get(i), "^ellipse.*$") != null) //look for ellipse with regex
        {
          ellipses.add(i);
        }
      }
  
      int j = 0;
      for (int m = 0; m < ellipses.size(); m++) {
        splitByLeftBrace = splitTokens(linesFiltered.get(ellipses.get(m)), "(");
        splitByCommas = trim(splitTokens(splitByLeftBrace[1], ",)"));

        j = 0;
        while (j < splitByCommas.length && j < 4) //get ellipse's parameters
        {
          if(isNumeric(splitByCommas[j])) // check for magic numbers
          {
            println("Use of magic numbers as params for ellipse");
            totalScore -= deduction;
            break;
          }
          j++;
        }
        max = max + j;
      }
    }
    catch (Exception e) 
    {
      println("Check ellipses");
      totalScore -= majorExceptions;
    }
  }

  boolean charIsNum(char c)  //check ascii range of char
  {
    return 48<=c&&c<=57;
  }

  boolean isNumeric(String s) //check if a number
  {
    char [] ca = s.toCharArray();
    int len = ca.length;
    boolean first = charIsNum(ca[0]);
    if (len==1) {
      return first;
    } else {
      if ( !first && ca[0]!='-') { 
        return false;
      }
      for (int i=1; i<len; i++) {
        if (!charIsNum(ca[i])) {
          return false;
        }
      }
    }
    return true;
  }
  
  void getVariables() 
  { 
    String[] splitByEquals;
    String[] splitBySemiColon;
    String[] splitBySpace;
    
    try
    {
      for(int i = 0; i < linesFiltered.size(); i++)
      {  
        if (match(linesFiltered.get(i), "=") != null)
        {
          variableLines.add(i);
        }
      }
      
      for (int m = 0; m < variableLines.size(); m++) 
      {
        splitByEquals = splitTokens(linesFiltered.get(variableLines.get(m)), "="); //split by equals 
        splitBySpace = trim(splitTokens(splitByEquals[0], " ")); //get variable name
        
        String varName = splitBySpace[splitBySpace.length-1];
        
        splitBySemiColon = trim(splitTokens(splitByEquals[1], ";")); //split by equals 
        
        String varValue = splitBySemiColon[0];
        
        if(isNumeric(varValue)) {
           variablesHashMap.put(varName, varValue); 
        } else {
          println("The value for the variable " + varName + " is not a number");
        }
      }
    }
    
    catch(Exception e)
    {
      println("Could not get variables"); 
    }
  }

  void printResults() {
    if (totalScore < 0)
    {
      totalScore = 0;
    }
    println("Total score: ", totalScore);
  }

  void run() {
    getLines();
    checkTabs();
    removeEmptyLines();
    getVariables();
    checkStatementsPerLine();
    getScreenSize();
    checkSize();
    checkComments();
    checkBackground();
    checkFills();
    checkStrokes();
    checkEllipses();
    checkRects();
    checkScores();
    shapeColorInteractions();
    printResults();
  }
}
