@import "assert.js"
@import "main.js"

var testLoadFramework = function() {
  var success = load()
  assertTrue("Load Framework", success);
}

var testInitializeClass = function() {
  var cl = myClass()
  assertNotNil("Load Classes", cl);
}

testLoadFramework()
testInitializeClass()
