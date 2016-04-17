@import 'helper.js'
@import 'Sketch.js'

var present = function(context) {
    context.document.showMessage("Start Presentation");
    load()
    var cl = myClass()
    var object = cl.alloc().init()
    var success = object.launchWithSlides_atIndex_(nil, 0);
    assertNotNil("did launch presentation", success)
    coscript.shouldKeepAround = true;
    NSThread.mainThread().threadDictionary().setObject_forKey_(object, "design.magicmirror.presentation");
}

var load = function() {
    var loaded = Sketch.loadFramework("Presentation", "/Contents/Sketch");
    return loaded
}

var myClass = function() {
  var my = NSClassFromString("PresentationController")
  return my;
}
