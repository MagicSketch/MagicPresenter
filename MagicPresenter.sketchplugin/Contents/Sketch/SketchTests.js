@import "Sketch.js"

// log("Please use `coscript RunSketchTests.js`")

function run(context) {
  // testGetDelegate()
  // testGetContext()
  if (testHasSelectedAnArtboardBeforeContinueTesting(context)) {
    testHasFlattener(context);
    testWrappingLayer(context)
    testExportLayerToImage(context)
  }

  testGetAllArtboardsInPage(context);
}

// function testGetDelegate() {
//   var delegate = Sketch.delegate()
//   assertClass("Delegate is AppController", delegate, "AppController")
// }
//
// function testGetContext() {
//   var context = Sketch.context()
//   assertNotNil("Context Exists", context);
// }

function testHasSelectedAnArtboardBeforeContinueTesting(context) {
  var selection = context.selection.firstObject()
  var hasSelectedAnArtboard = selection != null && selection.className() == "MSArtboardGroup"
  assertTrue("TestHasSelectedAnArtboardBeforeContinueTesting", hasSelectedAnArtboard)
  return hasSelectedAnArtboard
}

function testHasFlattener(context) {
  var mslayer = context.selection.firstObject();
  var flattener = Sketch.flattener(context)
  assertNotNil("TestHasFlattener", flattener)
}

function testWrappingLayer(context) {
  var mslayer = context.selection.firstObject();
  var layer = Sketch.layer(mslayer)
  assertNotNil("TestWrappingLayer", layer)
}

function testExportLayerToImage(context) {
  var mslayer = context.selection.firstObject();
  var layer = Sketch.layer(mslayer)
  var image = layer.exportedImage(context, 3);
  assertNotNil("TestExportLayerToImage", image)
}

function testGetAllArtboardsInPage(context) {
  var artboards = Sketch.page(context).artboards()
  assertTrue("Artboards Count > 0", artboards != null && artboards.count())
}
