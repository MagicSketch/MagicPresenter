/*
// To load this framework, add the following code in your manifest.json

"commands": [
:
:
{
    "script" : "MagicPresenterUI.framework/MagicPresenterUI.js",
    "handlers" : {
        "actions" : {
            "Startup" : "onStartup",
            "OpenDocument":"onOpenDocument",
            "SelectionChanged.finish" : "onSelectionChanged"
        }
    }
}
]
*/

var onStartup = function(context) {
  var MagicPresenterUI_FrameworkPath = MagicPresenterUI_FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent().stringByDeletingLastPathComponent();
  var MagicPresenterUI_Log = MagicPresenterUI_Log || log;
  (function() {
    var mocha = Mocha.sharedRuntime();
    var frameworkName = "MagicPresenterUI";
    var directory = MagicPresenterUI_FrameworkPath;
    if (mocha.valueForKey(frameworkName)) {
      MagicPresenterUI_Log("😎 loadFramework: `" + frameworkName + "` already loaded.");
      return true;
    } else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
      MagicPresenterUI_Log("✅ loadFramework: `" + frameworkName + "` success!");
      mocha.setValue_forKey_(true, frameworkName);
      return true;
    } else {
      MagicPresenterUI_Log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ". Please define MagicPresenterUI_FrameworkPath if you're trying to @import in a custom plugin");
      return false;
    }
  })();
};

var onSelectionChanged = function(context) {
  MagicPresenterUI.onSelectionChanged(context);
};
