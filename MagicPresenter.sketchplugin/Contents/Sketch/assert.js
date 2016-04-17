var assertTrue = function(description, condition) {
  if (condition) {
    log("✅" + description);
  } else {
    log("❌" + description);
  }
}

var assertNotNil = function(description, object) {
   assertTrue(description, object != null)
}

var assert = function(description) {
   log("❌" + description);
}

var assertEquals = function(description, object1, object2) {
  if (object1 == object2) {
    assertTrue(description + ". Is equal " + object1, object1 == object2);
  } else {
    assertTrue(description + ". " + object1 + " is not equal " + object2, object1 == object2);
  }
}

var assertClass = function(description, object, className) {
  if (object != null) {
    assertEquals(description, object.className(), className)
  } else {
    assert(description + " " + object);
  }
}
