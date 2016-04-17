@import "assert.js"
@import "main.js"

var testLoadFramework = function() {
  var success = load()
  assertTrue("Load Framework", success);
}

var testInitializeClass = function() {
  var cl = myClass()
  var object = cl.alloc().init()
  assertNotNil("Load Classes", cl);
  assertTrue("Has Initialized", object);
}

var testRespondsToLaunchWithSlides = function() {
  var cl = myClass()
  var responds = PresentationController.instancesRespondToSelector("launchWithSlides:atIndex:")
  assertTrue("InstancesResponds to launchWithSlides:atIndex:", responds)
}

var testLaunchPresentationMode = function() {
  var cl = myClass()
  var object = cl.alloc().init()
  var success = object.launchWithSlides_atIndex_(nil, 0);
  assertNotNil("did launch presentation", success)
}

testLoadFramework()
testInitializeClass()
testRespondsToLaunchWithSlides()
testLaunchPresentationMode()
