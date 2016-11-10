/* jshint ignore:start */
@import 'Sketch.js'
@import 'helper.js'
@import 'Class.js'
/* jshint ignore:end */

var present = function(context) {
    context.document.showMessage("Start Presentation");
    load("design.magicmirror.presenter");
    var cl = myClass();
    var object = cl.alloc().init();
    var artboards = Sketch.page(context).artboards();
    var slides = createSlides(artboards, context);
    var current = representingArtboard(context.selection.firstObject()) || artboards.lastObject();
    var index = indexOfArtboard(current, artboards);
    var success = object.launchWithSlides_atIndex_(slides, index);
    coscript.shouldKeepAround = true;
    NSThread.mainThread().threadDictionary().setObject_forKey_(object, "io.magicsketch.presenter");
    context.document.showMessage("Successfully Presents");
};



var load = function(identifier) {
    var loadedMPTracker = Sketch.loadFramework("MPTracker", "/Contents/Sketch", identifier);
    var loadedMagicPresenter = Sketch.loadFramework("MagicPresenter", "/Contents/Sketch", identifier);

    log("loaded MagicPresenter: " + loadedMagicPresenter);
    log("loaded MPTracker: " + loadedMPTracker);

    return loadedMPTracker;
};

var myClass = function() {
  var my = NSClassFromString("MPPresentationController");
  return my;
};

var createSlides = function(artboards, context) {

    var Slide = Class("Slide", NSObject, {
       "setArtboard":function(artboard) {
         this.artboard = artboard;
       },
       "image":function() {
         return Sketch.layer(this.artboard).exportedImage(context, 2);
       },
    });

    var slides = [];
    for (var i = 0; i < artboards.count(); i++) {
      var artboard =  artboards[i];
      var slide = Slide.alloc().init();
      slide.setArtboard(artboard);
      slides.push(slide);
    }

    return slides;
};

var indexOfArtboard = function(artboard, artboards) {
  var index = -1;
  for (var i = 0; i < artboards.count(); i++) {
      var current = artboards[i];
      if (artboard.objectID() == current.objectID()) {
        index = i;
        break;
      }
  }
  return index;
};

var representingArtboard = function(selected) {
  if (selected && selected.isKindOfClass([MSLayer class])) {  // jshint ignore:line
    selected = selected.parentArtboard();
  }
  return selected;
};
