local package = require "package"
-- Maybe it will be necessary to change the LUA_PATH.
-- http://www.thijsschreijer.nl/blog/?p=1025

function readShellVar(varname)
  local handle = io.popen('echo $' + varname)
  local result = handle:read("*a")
  handle:close()
  return result
end

function produceApk()
  os.execute()
end

loveAndroidSdlHome = readShellVar('LOVE_ANDROID_SDL_HOME')
loveAndroidSdlAssets = loveAndroidSdlHome + '/app/src/main/assets'
manifestPath = loveAndroidSdlHome + 'app/src/main/AndroidManifest.xml'

-- src/br/com/possatti/maze/MazeActivity.java
--[[
package com.josefnpat.loveburgers;
import org.love2d.android.GameActivity;
public class BurgerActivity extends GameActivity {}
]]

arg[1]
