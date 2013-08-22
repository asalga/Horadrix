/*
*
*/
function SoundManager(){

  var muted;

  var BASE_PATH = "data/audio/";

  var paths = [BASE_PATH + "fail_swap.ogg", BASE_PATH + "success_swap.ogg"];
  var sounds = [];

  var FAIL = 0;
  var SWAP = 1;

  /*
  */
  this.init = function(){
    var i;

    for(i = 0; i < paths.length; i++){
      sounds[i] = document.createElement('audio');
      sounds[i].setAttribute('src', paths[i]);
      sounds[i].preload = 'auto';
      sounds[i].load();
      sounds[i].volume = 0;
      sounds[i].setAttribute('autoplay', 'autoplay');
    }
  };

  /*
  *
  */
  this.setMute = function(mute){
    muted = mute;
  };

  /*
  */
  this.stop = function(){
    
  }

  /*
  */
  this.playSound = function(soundID){
    if(muted){
      return;
    }

    sounds[soundID].volume = 1.0;

    // Safari does not want to play sounds...??
    try{
      sounds[soundID].volume = 1.0;
      sounds[soundID].play();
      sounds[soundID].currentTime = 0;
    }catch(e){
      console.log("Could not play audio file.");
    }
  };

  this.playSuccessSwapSound = function(){
    this.playSound(SWAP);
  };

  this.playFailSwapSound = function(){
    this.playSound(FAIL);
  };
}
