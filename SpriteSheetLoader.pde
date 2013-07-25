/*
TODO: add rotation



*/
public class SpriteSheetLoader{

  PImage test;
  HashMap map;
  
  public  void load(String texturePackerMetaFile){
    
    
    
    
    
   /* JSONObject json;
    
    json = loadJSONObject(texturePackerMetaFile);
    
    String imageFilename = json.getJSONObject("meta").getString("image");
   // print(imageFilename); 
    
    PImage texture = loadImage(imageFilename);
    
    JSONArray frames = json.getJSONArray("frames");
    
    map = new HashMap<String, PImage>(frames.size());    
    
    //println(frames.size());
    
    // Iterate over all the sprites in the json file
    for(int i = 0; i < frames.size(); i++){
      
      //
      JSONObject frame = frames.getJSONObject(i);
      
      
      // Regardless of whether the sprite is rotated or not, it's final dimensions
      // can be extracted from sourceSize.
      JSONObject sourceSize = frame.getJSONObject("sourceSize");
      int dstSpriteWidth  = sourceSize.getInt("w");
      int dstSpriteHeight = sourceSize.getInt("h");
      PImage img = createImage(dstSpriteWidth, dstSpriteHeight, ARGB);
      println("Created image: (" + dstSpriteWidth + "," + dstSpriteHeight + ")");
      
      // Pull the actual sprite from the sheet
      JSONObject dimensions = frame.getJSONObject("frame");
      int srcStartX = dimensions.getInt("x");
      int srcStartY = dimensions.getInt("y");
      int srcWidth = dimensions.getInt("w");
      int srcHeight = dimensions.getInt("h");
      
      // This is actually our destination, where we copy the pixels into the image.
      JSONObject spriteSourceSize = frame.getJSONObject("spriteSourceSize");
      int dstStartX = spriteSourceSize.getInt("x");
      int dstStartY = spriteSourceSize.getInt("y");
      int dw = spriteSourceSize.getInt("w");
      int dh = spriteSourceSize.getInt("h");
      
      //println("dw: " + dw);
      //println("dh: " + dh);
      
     // println("dstSpriteWidth: " + dstSpriteWidth);
      //println("dstSpriteHeight: " + dstSpriteHeight);
      
      // If the sprite isn't rotated, our logic is much simpler so we break up the cases.
      if(frame.getBoolean("rotated")){
        println("sprite is rotated");
        
        // Going to copy the pixels starting from the sprite in the sheet
        // upper left corner downwards moving left to right

        // inverted for src
        //int dstWidth = 400;
       // int dstHeight = 324;
        
        // We only need to copy the trimmed part
        int pixelsCopied = 0;
        int pixelsToCopy = srcWidth * srcHeight;
        
        int srcX = srcStartX;
        int srcY = srcStartY;
       
        int dstX = dstStartX;
        int dstY = dh - 1;
        
        //println(dw);
        int srcRotHeight = srcWidth;
        //println(srcRotHeight);

        
        for( ;pixelsCopied < pixelsToCopy; pixelsCopied++, dstX++, srcY++){

          //
         if(srcY == srcRotHeight + srcStartY){
           srcY = srcStartY;
           srcX++;
           
           dstX = dstStartX;
           dstY--;
         }
        // println(dstY*dw+dstX);
         
         color c = texture.pixels[srcY * texture.width + srcX];
           
          //
          img.pixels[dstY * dstSpriteWidth + dstX] = c;
        }
        
        img.updatePixels();
  
        map.put(frame.getString("filename"), img);
      }
      else{
        println("sprite is not rotated");
        // Copy from the sprite sheet to our individual sprite
        // potentially not touching the transparent pixels that border the sprite.
        img.copy(texture, srcStartX, srcStartY, srcWidth, srcHeight, dstStartX, dstStartY, dw, dh);
        map.put(frame.getString("filename"), img);
      }
    }*/
  }
  
  public PImage get(String sprite){
    return (PImage)map.get(sprite);
  }
}
