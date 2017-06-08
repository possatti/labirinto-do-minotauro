Running LÖVE games on Android
=============================

## Quick and dirty
 - Install LÖVE for Android, on the Android device.
 - `adb push game.love /sdcard/love-games/game.love`
 - `adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/love-games/game.love"`

## Build distributable `apt`
 - https://bitbucket.org/MartinFelis/love-android-sdl2/wiki/Building_L%C3%96VE_for_Android_-_Linux
 - Intall JDK8.
   - Fedora: `sudo dnf install java-1.8.0-openjdk-headless java-1.8.0-openjdk java-1.8.0-openjdk-devel`
 - Install Apache ANT.
   - Fedora: `sudo dnf install ant`
 - Install Android SDK (https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip).
 - Install the Android NDK (https://developer.android.com/ndk/downloads/index.html).
 - Clone the `love-android-sdl2` repo.
   - `git clone --depth 1 https://bitbucket.org/MartinFelis/love-android-sdl2`
 - ...
 - `./gradlew build`

## Other
 - Maybe `Start Gamedev` is easier: https://www.youtube.com/watch?annotation_id=annotation_444447295&feature=iv&src_vid=vfn1nTjPuOY&v=TAZo-pin4nE
 - Or maybe `love-release`: https://github.com/MisterDA/love-release
