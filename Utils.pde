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
}
