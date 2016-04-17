#!/bin/bash
echo "Installing Local to Sketch Plugin folder"
./install.sh

echo "Started SketchTests.js"
./coscript RunSketchTests.js
# ./coscript MagicPresenter.sketchplugin/Contents/Sketch/SketchTests.js


echo "Started test.js"
./coscript MagicPresenter.sketchplugin/Contents/Sketch/test.js
