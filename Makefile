# Horadrix make file
# Creates a Javascript playable version
# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify:
	cat Horadrix/*.pde Horadrix/*.java > Horadrix.js
	
publish: minify
	git add Horadrix-min.js
	git commit -m"publishing"
	git push
