@import 'helper.js'
@import 'Sketch.js'

var openWindow = function(context) {

    log("Open Window Started");
    context.document.showMessage("Open Window Started2");
    if ( ! classExists("ArtboardPreviewController")) {
        log("don't have ArtboardPreviewController");
        var loaded = loadFramework("ArtboardPreview", "/Contents/Sketch");
        log("finish loading " + loaded);
        context.document.showMessage("framework loaded ");

    } else {
      log("framework loaded ");
      context.document.showMessage("framework loaded ");
    }

    if ( ! classExists("ArtboardPreviewController")) {
      context.document.showMessage("Class Still Doesnt Exists");
      return;
    }

    context.shouldKeepAround = true;

    var layers = context.selection

    var message = "";
    for (var i = 0; i < layers.count(); i++) {
        var layer = layers[i];
        var image = Sketch.layer(layer).exportedImage(context, 3);
        var controller = ArtboardPreviewController.alloc().init();
        [controller launchWithImage:image name:layer.name()];
        NSThread.mainThread().threadDictionary().setObject_forKey_(controller, "artboardpreview" + i + NSDate.date());
    }

    if (layers.count() == 0) {
        context.document.showMessage("No selection");
    } else {
        context.document.showMessage("Showing preview for " + layers.count() + " layers");
    }

}

var printFrame = function(context) {
    var selection = context.selection;
    log(selection);
    log(selection[0]);
    log(selection[0].frame());
}
