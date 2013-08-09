/*
 * JS Utilities interface
 */
var Utils = {

  /*   
   */
  charCodeAt: function(ch){
    return ch.charCodeAt(0);
  },

  /*
   * 
   */
  getRandomInt: function(minVal, maxVal){
    var scale = Math.random();
    return minVal + Math.floor(scale * (maxVal - minVal + 1));
  },
  
  Lerp: function(a, b, p){
  	return a * (1-p) + (b * p);
  },
  
  floatToInt:function(f){
    return Math.floor(f);
  },
  
  /*
  */
  prependStringWithString: function(baseString, prefix, newStrLength){
    var zerosToAdd, i;

    if(newStrLength <= baseString.length()){
      return baseString;
    }
    
    zerosToAdd = newStrLength - baseString.length();
    
    for(i = 0; i < zerosToAdd; i++){
      baseString = prefix + baseString;
    }
    
    return baseString;
  }

}
