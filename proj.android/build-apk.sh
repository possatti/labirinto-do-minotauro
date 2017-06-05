#!/bin/sh

usage() {
	echo "$0 LOVE_PROJ_PATH" >&2
	echo "Arguments" >&2
	echo "  LOVE_PROJ_PATH: Path to your LÖVE project." >&2
}

err() {
	echo "ERROR  $@" >&2
	exit 1
}

# Try to go to root directory.
cd $1 || usage

# Check whether LOVE_ANDROID_SDL2_HOME is there.
if [ -z "${LOVE_ANDROID_SDL2_HOME}" ]; then
	err 'You need to set $LOVE_ANDROID_SDL2_HOME.' >&2
fi

# Copy game.love
mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main/assets
cp labirinto.love "${LOVE_ANDROID_SDL2_HOME}/app/src/main/assets/game.love" || err 'Could not copy game.love.'

# Copy MazeActivity.java
mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main/br/com/possatti/maze || err 'Cannot create directory.'
cp "proj.android/MazeActivity.java" ${LOVE_ANDROID_SDL2_HOME}/app/src/main/br/com/possatti/maze || err 'Could not copy MazeActivity.'

# Copy AndroidManifest.xml
mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main
cp "proj.android/AndroidManifest.xml" ${LOVE_ANDROID_SDL2_HOME}/app/src/main || err 'Could not copy AndroidManifest.'

# Start build
# exit #!#
cd ${LOVE_ANDROID_SDL2_HOME}
./gradlew build &&
echo "Debug apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-debug.apk'." &&
echo "Release apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-release-unsigned.apk'."
