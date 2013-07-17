# Horadrix make file
# Creates a Javascript playable version
# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify: 
	cat Debugger.pde Keyboard.pde Ticker.pde TokenType.pde Utils.pde GemToken.pde Horadrix.pde SoundManager.pde Token.pde Tuple.pde AssetStore.java > Horadrix-min.pde
	
publish: minify
	git add Horadrix-min.js
	git commit -m"publishing"
	git push
