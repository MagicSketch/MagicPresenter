/* jshint ignore:start */
@import "assert.js"
@import "main.js"
/* jshint ignore:end */


var run = function(context) {
  testLoadFramework();
  testInitializeClass();
  testRespondsToLaunchWithSlides();
  // testLaunchPresentationMode()

  testWrapArtboardInSlides(context);
  testClassNamesForSlides(context);
};

var testLoadFramework = function() {
  var success = load();
  assertTrue("Load Framework", success);
};

var testInitializeClass = function() {
  var cl = myClass();
  var object = cl.alloc().init();
  assertNotNil("Load Classes", cl);
  assertTrue("Has Initialized", object);
};

var testRespondsToLaunchWithSlides = function() {
  var cl = myClass();
  var responds = MPPresentationController.instancesRespondToSelector("launchWithSlides:atIndex:");
  assertTrue("InstancesResponds to launchWithSlides:atIndex:", responds);
};

var testLaunchPresentationMode = function() {
  var cl = myClass();
  var object = cl.alloc().init();
  var success = object.launchWithSlides_atIndex_(nil, 0);
  assertNotNil("did launch presentation", success);
};

var testWrapArtboardInSlides = function(context) {
  var artboard1 = MSArtboardGroup.alloc().init();
  var artboard2 = MSArtboardGroup.alloc().init();
 /* jshint ignore:start */
  var artboards = [NSArray arrayWithArray:[artboard1, artboard2]];
  /* jshint ignore:end */
  var slides = createSlides(artboards, context);
  assertTrue("Same Number of Slides", slides.length == artboards.count());
  var className = myClass().className();
  for (var index in slides) {
    assertNotNil(artboards[index].objectID());
  }
};

var testClassNamesForSlides = function(context) {
  var artboard1 = MSArtboardGroup.alloc().init();
/* jshint ignore:start */
  var artboards = [NSArray arrayWithArray:[artboard1]];
/* jshint ignore:end */
  var slides = createSlides(artboards, context);
  for (var index in slides) {
    assertTrue("Is Slides", slides[index].className().startsWith("Slide"));
  }
};

var testIndexOfArtboard = function(context) {
  var artboard1 = MSArtboardGroup.alloc().init();
  var artboard2 = MSArtboardGroup.alloc().init();
  /* jshint ignore:start */
  artboard1.objectID = [MSArtboardGroup generateObjectID];
  artboard2.objectID = [MSArtboardGroup generateObjectID];
  var artboards = [NSArray arrayWithArray:[artboard1, artboard2]];
  /* jshint ignore:end */
};
