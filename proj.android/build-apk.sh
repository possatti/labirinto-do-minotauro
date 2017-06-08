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
LOVE_PACKAGE_DEST="${LOVE_ANDROID_SDL2_HOME}/app/src/main/assets"
mkdir -p "${LOVE_PACKAGE_DEST}"
cp labirinto.love "${LOVE_PACKAGE_DEST}/game.love" || err 'Could not copy game.love.'

# Copy AndroidManifest.xml
AM_DEST="${LOVE_ANDROID_SDL2_HOME}/app/src/main"
mkdir -p "${AM_DEST}"
cp "proj.android/AndroidManifest.xml" ${AM_DEST} || err 'Could not copy AndroidManifest.'

# Put original love2d activities under a new namespace.
LOVE2D_PACKAGE="org.love2d.android"
MAZE_PACKAGE="br.com.possatti.maze"
ACTIVITIES_SOURCE="${LOVE_ANDROID_SDL2_HOME}/love/src/main/java/org/love2d/android"
ACTIVITIES_DEST="${LOVE_ANDROID_SDL2_HOME}/app/src/main/java/br/com/possatti/maze"
mkdir -p "$ACTIVITIES_DEST"
cp "$ACTIVITIES_SOURCE"/* "$ACTIVITIES_DEST"
perl -i -pe "s/${LOVE2D_PACKAGE}/${MAZE_PACKAGE}/" ${ACTIVITIES_DEST}/*


# Start build
# exit #!#
cd ${LOVE_ANDROID_SDL2_HOME}
./gradlew build &&
echo "Debug apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-debug.apk'." &&
echo "Release apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-release-unsigned.apk'."
