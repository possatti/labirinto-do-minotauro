# Makefile options
SHELL=/bin/bash
.ONESHELL:
.PHONY: all clean

# Source files
IMAGE_FILES = $(shell find -name "*.png")
FONT_FILES = $(shell find -name "*.ttf")
SOUND_FILES = $(shell find -name "*.wav") $(shell find -name "*.mp3") $(shell find -name "*.ogg")
SOURCE_FILES = $(shell find -name "*.lua")
ALL_SOURCE_FILES = $(IMAGE_FILES) $(SOUND_FILES) $(SOURCE_FILES) $(MAP_FILES) $(FONT_FILES)

# Package name
PACKAGE_NAME = $(shell basename `pwd`).love

# Location for the love-android-sdl2
LOVE_ANDROID_SDL2_HOME = $(shell echo $$LOVE_ANDROID_SDL2_HOME)
LOVE_ANDROID_SDL2_ASSETS = $(LOVE_ANDROID_SDL2_HOME)/app/src/main/assets

run: all
	love $(PACKAGE_NAME)

all: clean $(PACKAGE_NAME)

android-run: $(PACKAGE_NAME)
	adb push $(PACKAGE_NAME) /sdcard/love-games/$(PACKAGE_NAME)
	adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/love-games/$(PACKAGE_NAME)"

android-build: $(PACKAGE_NAME)
	@if [ -z "$(LOVE_ANDROID_SDL2_HOME)" ]; then
		echo 'You need to set $LOVE_ANDROID_SDL2_HOME.'
		exit 1
	fi
	mkdir -p $(LOVE_ANDROID_SDL2_ASSETS)
	cp $(PACKAGE_NAME) $(LOVE_ANDROID_SDL2_ASSETS)/game.love
	cd $(LOVE_ANDROID_SDL2_HOME)
	./gradlew build &&
	echo "Debug apk created on '$(LOVE_ANDROID_SDL2_HOME)/app/build/outputs/apk/app-debug.apk'." &&
	echo "Release apk created on '$(LOVE_ANDROID_SDL2_HOME)/app/build/outputs/apk/app-release-unsigned.apk'."

$(PACKAGE_NAME): $(ALL_SOURCE_FILES)
	zip -r $(@) $(?)

clean:
	rm -f $(PACKAGE_NAME)
