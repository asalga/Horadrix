/*
* General utilities
*
* A JavaScript version of this class also exists.
*/
public static class Utils{
  
  /*
   * We use Math.random() instead of Processing's random() to prevent
   * having to make this class a singleton and take a Papplet. That code
   * would be unnecessarily complex.
   */
  public static int getRandomInt(int minVal, int maxVal) {
    float scaleFloat = (float) Math.random();
    return minVal + (int) (scaleFloat * (maxVal - minVal + 1));
  }
  
  public static boolean circleCircleIntersection(PVector circle1Pos, float circle1Radius, PVector circle2Pos, float circle2Radius){
    PVector result = circle1Pos;
    result.sub(circle2Pos);
    
    float distanceBetween = result.mag();
    return distanceBetween < (circle1Radius/2.0 + circle2Radius/2.0);
  }
  
  public static float Lerp(float a, float b, float p){
    return a * (1 - p) + (b * p);
  }
      
  /*
  * This is here simply to provide a means for us to call a custom method for the JS version.
  */
  public static int charCodeAt(char ch){
    return ch;
  }
  
  /**
  * Mostly used for adding zeros to number in string format, but general enough to be
  * used for other purposes.
  */
  public static String prependStringWithString(String baseString, String prefix, int newStrLength){
    if(newStrLength <= baseString.length()){
      return baseString;
    }
    
    int zerosToAdd = newStrLength - baseString.length();
    
    for(int i = 0; i < zerosToAdd; i++){
      baseString = prefix + baseString;
    }
    
    return baseString;
  }
}
