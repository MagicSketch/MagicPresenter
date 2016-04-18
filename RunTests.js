var sketchApp = COScript.app("Sketch Beta")
var appSupportPath = NSFileManager.defaultManager().URLsForDirectory_inDomains(NSApplicationSupportDirectory,NSUserDomainMask).firstObject().path()
var pluginFolderPath = appSupportPath.stringByAppendingPathComponent("com.bohemiancoding.sketch3/Plugins/MagicPresenter.sketchplugin")
var pluginURL = NSURL.fileURLWithPath(pluginFolderPath)
var output = sketchApp.delegate().runPluginCommandWithIdentifier_fromBundleAtURL('sketchtests',pluginURL)
log(output);

output = sketchApp.delegate().runPluginCommandWithIdentifier_fromBundleAtURL('test',pluginURL)
log(output);
