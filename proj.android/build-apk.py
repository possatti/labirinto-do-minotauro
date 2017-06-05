#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function, division
from subprocess import call

import xml.etree.ElementTree
import argparse
import json
import re
import os

def main():
	las = args.love_android_sdl2_home
	print(las)
	json_data = json.load(args.package_json)
	j = json_data

	# # Changes to AndroidManifest.xml.
	# am_changes = []
	# am_changes.append([
	# 	r'<manifest package=".*?"',
	# 	'<manifest package="{}"'.format(json_data.package)

	# ])
	# am_changes.append([
	# 	r'<activity\n        android:name=".*?"',
	# 	'<activity\n        android:name="{}.{}"'.format(json_data.package + json_data.package)
	# ])
	activity_name = re.sub(r'.*/|\.java', '', j['activity'])
	am_path = os.path.join(las, 'app/src/main/AndroidManifest.xml')
	print(am_path)
	am_tree = xml.etree.ElementTree.parse(am_path)
	am_root = am_tree.getroot()
	print(am_root.attrib)
	print(am_root.find('./application/activity').attrib)

	print()
	print(am_root.get('package'))
	am_root.set('package', j['package'])
	print(am_root.get('package'))

	print()
	print(am_root.find('./application/activity').get('{http://schemas.android.com/apk/res/android}name'))
	am_root.find('./application/activity').set(
		'{http://schemas.android.com/apk/res/android}name',
		'{}.{}'.format(j['package'], activity_name))
	print(am_root.find('./application/activity').get('{http://schemas.android.com/apk/res/android}name'))

	call(['mv', j['activity'], ])


if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Build a LÖVE project for android.')
	parser.add_argument('love_project_root')
	parser.add_argument('package_json', type=argparse.FileType('r'), help='Json containg the needed data.')
	parser.add_argument('love_android_sdl2_home')
	# args = parser.parse_args()
	args = parser.parse_args(['love-package.json', '/home/possatti/projects/love-android-sdl2'])
	# print(args)
	main()


# # Try to go to root directory.
# cd $1 || usage

# # Check whether LOVE_ANDROID_SDL2_HOME is there.
# if [ -z "${LOVE_ANDROID_SDL2_HOME}" ]; then
# 	err 'You need to set $LOVE_ANDROID_SDL2_HOME.' >&2
# fi

# # Copy game.love
# mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main/assets
# cp labirinto.love "${LOVE_ANDROID_SDL2_HOME}/app/src/main/assets/game.love" || err 'Could not copy game.love.'

# # Copy MazeActivity.java
# mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main/br/com/possatti/maze || err 'Cannot create directory.'
# cp "proj.android/MazeActivity.java" ${LOVE_ANDROID_SDL2_HOME}/app/src/main/br/com/possatti/maze || err 'Could not copy MazeActivity.'

# # Copy AndroidManifest.xml
# mkdir -p ${LOVE_ANDROID_SDL2_HOME}/app/src/main
# cp "proj.android/AndroidManifest.xml" ${LOVE_ANDROID_SDL2_HOME}/app/src/main || err 'Could not copy AndroidManifest.'

# # Start build
# # exit #!#
# cd ${LOVE_ANDROID_SDL2_HOME}
# ./gradlew build &&
# echo "Debug apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-debug.apk'." &&
# echo "Release apk created on '${LOVE_ANDROID_SDL2_HOME}/app/build/outputs/apk/app-release-unsigned.apk'."
