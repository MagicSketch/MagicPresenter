@import "Sketch.js"

// log("Please use `coscript RunSketchTests.js`")

function run(context) {
  // testGetDelegate()
  // testGetContext()

  testOpenFile(context);
  var mslayer = testAutoSelectLayer(context);
  testHasFlattener(context);
  var layer = testWrappingLayer(mslayer)
  var image = testExportLayerToImage(context, layer)
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

function testOpenFile(context) {
  var controller = [NSApp delegate]
  var path = NSURL.URLWithString("/Users/james/Projects/MagicPresenter/MagicPresenter.sketch")
  controller.openTemplateAtPath(path)
}

function testAutoSelectLayer(context) {
    var artboards = Sketch.page(context).artboards()
    var firstLayer = artboards.firstObject()
    var isSelectionFirstLayer = false;
    if (artboards.count() > 0) {
      Sketch.selection(context).setSelectedLayer(firstLayer)
    } else {
      assertTrue("No Artboards for selection", false);
    }
    return firstLayer
}
//
// function testHasSelectedAnArtboardBeforeContinueTesting(context) {
//   var selection = context.selection.firstObject()
//   var hasSelectedAnArtboard = selection != null && selection.className() == "MSArtboardGroup"
//   assertTrue("TestHasSelectedAnArtboardBeforeContinueTesting", hasSelectedAnArtboard)
//   return hasSelectedAnArtboard
// }

function testHasFlattener(context) {
  var flattener = Sketch.flattener(context)
  assertNotNil("TestHasFlattener", flattener)
}

function testWrappingLayer(mslayer) {
  var layer = Sketch.layer(mslayer)
  assertNotNil("TestWrappingLayer", layer)
  return layer;
}

function testExportLayerToImage(context, layer) {
  var image = layer.exportedImage(context, 2);
  assertNotNil("TestExportLayerToImage", image)
  return image
}

function testGetAllArtboardsInPage(context) {
  var artboards = Sketch.page(context).artboards()
  assertTrue("Artboards Count > 0", artboards != null && artboards.count())
}
