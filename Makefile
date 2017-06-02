# Makefile options
SHELL=/bin/bash
.ONESHELL:
.PHONY: all clean

# Source files
IMAGE_FILES = $(shell find -name "*.png")
SOUND_FILES = $(shell find -name "*.wav") $(shell find -name "*.mp3") $(shell find -name "*.ogg")
SOURCE_FILES = $(shell find -name "*.lua")
MAP_FILES = $(shell find maps -name "*.txt")
ALL_SOURCE_FILES = $(IMAGE_FILES) $(SOUND_FILES) $(SOURCE_FILES) $(MAP_FILES)

# Package name
PACKAGE_NAME = game.love

run: all
	love $(PACKAGE_NAME)

all: clean $(PACKAGE_NAME)

$(PACKAGE_NAME): $(ALL_SOURCE_FILES)
	zip -r $(@) $(?)

clean:
	rm -f $(PACKAGE_NAME)