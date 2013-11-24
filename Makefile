# Horadrix make file
# Creates a Javascript playable version
# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify: 
	cat BoardModel.pde ScreenSet.pde ScreenWin.pde ScreenStory.pde ScreenGameOver.pde HUDLayer.pde IScreen.pde Subject.pde LayerObserver.pde SpriteSheetLoader.pde ScreenGameplay.pde ScreenSplash.pde Debugger.pde RetroFont.pde RetroLabel.pde RetroPanel.pde RetroWidget.pde Keyboard.pde Ticker.pde Horadrix.pde SoundManager.js Token.pde AssetStore.java IScreen.pde ScreenSplash.pde Utils.js ScreenGameplay.pde  > Horadrix-min.pde
	
publish: minify
	git add Horadrix-min.js
	git commit -m"publishing"
	git push
