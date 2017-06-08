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
	package_json_data = json.load(args.package_json)
	j = package_json_data

	# Initialize name of stuff.
	activity_name = re.sub(r'.*/|\.java', '', j['activity'])

	# Open the AndroidManifest.xml
	am_path = os.path.join(las, 'app/src/main/AndroidManifest.xml')
	print(am_path)
	am_tree = xml.etree.ElementTree.parse(am_path)
	am_root = am_tree.getroot()

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
