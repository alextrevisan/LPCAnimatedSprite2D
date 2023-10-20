PACKAGE_NAME := LPCAnimatedSprite.zip
VERSION := $$(cat addons/LPCAnimatedSprite/plugin.cfg | grep -o -P '(?<=version\=\").*(?=\")')

version:
	@echo $(VERSION)

package:
	@zip -r $(PACKAGE_NAME) ./addons

publish: package
	@git tag -a "v$(VERSION)" -m "Release version $(VERSION)" || true
	@git push origin "v$(VERSION)" || true
	@gh release create "v$(VERSION)" $(PACKAGE_NAME) --notes "New version of Godot LPCAnimatedSprite" || true