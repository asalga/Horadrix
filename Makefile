# Horadrix make file
# Creates a Javascript playable version
# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify: 
	cat Stack.pde Queue.pde GameOverScreen.pde FPSTimer.pde HUDLayer.pde IScreen.pde Subject.pde LayerObserver.pde SpriteSheetLoader.pde ScreenGameplay.pde ScreenSplash.pde Debugger.pde RetroFont.pde RetroLabel.pde RetroPanel.pde RetroWidget.pde Keyboard.pde Ticker.pde TokenType.pde Horadrix.pde SoundManager.pde Token.pde Tuple.pde AssetStore.java > Horadrix-min.pde IScreen.pde ScreenSplash.pde Utils.js ScreenGameplay.pde
	
publish: minify
	git add Horadrix-min.js
	git commit -m"publishing"
	git push
