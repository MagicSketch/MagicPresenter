@import 'helper.js'
@import 'Sketch.js'
@import 'Class.js'

var present = function(context) {
    context.document.showMessage("Start Presentation");
    load()
    var cl = myClass()
    var object = cl.alloc().init()
    var artboards = Sketch.page(context).artboards()
    var slides = createSlides(artboards, context)
    var index = 0
    log(slides);
    var success = object.launchWithSlides_atIndex_(slides, 0);
    coscript.shouldKeepAround = true;
    NSThread.mainThread().threadDictionary().setObject_forKey_(object, "design.magicmirror.presentation");
    context.document.showMessage("Successfully Presents");
}



var load = function() {
    var loaded = Sketch.loadFramework("Presentation", "/Contents/Sketch");
    return loaded
}

var myClass = function() {
  var my = NSClassFromString("PresentationController")
  return my;
}

var createSlides = function(artboards, context) {

    var slides = []
    var Slide = Class("Slide", NSObject, {
       "setArtboard":function(artboard) {
         this.artboard = artboard;
       },
       "image":function() {
         return Sketch.layer(this.artboard).exportedImage(context, 3);
       },
    });

    for (var i = 0; i < artboards.count(); i++) {
      var artboard =  artboards[i];
      var slide = Slide.alloc().init()
      slide.setArtboard(artboard)
      slides.push(slide);
    }

    return slides;
}
