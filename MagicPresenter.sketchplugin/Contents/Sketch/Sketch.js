/* jshint ignore:start */
@import "assert.js"
/* jshint ignore:end */

var Sketch = {};

Sketch.env = function() {
  /* jshint ignore:start */
  this.name = function() {
    // var bundle = [NSBundle bundleForClass:NSClassFromString("AppController")];
    // var bundleIdentifier = [bundle bundleIdentifier];
    // var path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleIdentifier];
    //
    // var appName = [[path lastPathComponent] stringByDeletingPathExtension];
    // return appName;
    return "Sketch Beta"
  };
  /* jshint ignore:end */
  return this;
};

Sketch.page = function(context) {
  var _page = context.document.currentPage();
  this.artboards = function() {
      return _page.artboards();
  };
  return this;
};

Sketch.flattener = function(context) {

  _flattener = MSLayerFlattener.alloc().init();
  // assertTrue("Has Context", context)
  _context = context;
  _document = context.document;

  // assertEquals("Has Flattener", _flattener.className(), "MSLayerFlattener")
  // assertEquals("Has Document", _document.className(), "MSDocument")

  this.flattenedImage = function(mslayer) {
    var layer = Sketch.layer(mslayer);
    var array = layer.toMSLayerArray();
    var page = layer.parentPage();

    // assertEquals("Has Page ", page.className(), "MSPage")
    var image = _flattener.imageFromLayers_immutablePage_immutableDoc_(array, layer.parentPage().immutableModelObject(), _document.documentData().immutableModelObject());

    // assertEquals("Has Image", image.className(), "NSImage")

    return image;
  };

  this.exportedImage = function(mslayer, scale) {
    var layer = Sketch.layer(mslayer);
    var array = layer.toMSLayerArray();
    var request = _flattener.exportRequestFromLayers_immutablePage_immutableDoc_(array, layer.parentPage().immutableModelObject(), _document.documentData().immutableModelObject());
    request.scale = scale;

    /* jshint ignore:start */
    var renderer = [MSExportRendererWithSVGSupport exporterForRequest:request colorSpace:[NSColorSpace deviceRGBColorSpace]];
    /* jshint ignore:end */

    // assertClass("  Should have renderer", renderer, "MSExportRendererWithSVGSupport");

    var immutablePage = mslayer.parentPage().immutableModelObject();
    // assertClass("  Has Page", immutablePage, "MSImmutablePage")
    request.immutablePage = immutablePage;

    var immutableDoc = _document.documentData().immutableModelObject();
    // assertClass("  Has ImmutableDoc", immutableDoc, "MSImmutableDocumentData")
    request.immutableDocument = immutableDoc;

    var objectID = mslayer.objectID();
    request.rootLayerID = objectID;
    // assertNotNil("  Has ObjectID", objectID);

    var image = renderer.image();
    // assertClass("  Has Render Image", image, "NSImage")

    return image;
  };

  return this;

};

Sketch.layer = function(mslayer) {

  _mslayer = mslayer;

  this.setFillWithImage = function(image) {
    var style = _mslayer.style();
    assertClass("Is style", style, "MSStyle");

    var fill = style.fills().firstObject();
    if ( ! fill) {
        fill = _mslayer.style().fills().addNewStylePart();
    }
    assertClass("Is Fill", fill, "MSStyleFill");

    /* jshint ignore:start */
    [fill setFillType:4];
    [fill setPatternFillType:1];
    [fill setIsEnabled:true];

    var imageData = [[MSImageData alloc] initWithImage:image convertColorSpace:true];
    [fill setImage:imageData];
    /* jshint ignore:end */
  };

  this.toMSLayerArray = function() {
    return MSLayerArray.arrayWithLayer(_mslayer);
  };

  this.parentPage = function() {
    return _mslayer.parentPage();
  };

  this.flattenedImage = function(context) {
    return Sketch.flattener(context).flattenedImage(_mslayer);
  };

  this.exportedImage = function(context, scale) {
    return Sketch.flattener(context).exportedImage(_mslayer, scale);
  };

  this.layerID = function() {
    return _mslayer.objectID();
  };

  return this;

};



Sketch.dialog = function(context) {

    this.context = context;

    this.selectImage = function() {

      var openPanel = NSOpenPanel.openPanel();
      openPanel.setCanChooseDirectories(true);
      openPanel.setCanChooseFiles(true);
      openPanel.setCanCreateDirectories(false);

    	openPanel.setTitle("Choose your image:");
      openPanel.setPrompt("Choose");
      if (openPanel.runModal() == NSOKButton) {
        var url = openPanel.URL();
        assertEquals("has URL", url.className(), "NSURL");
        var data = NSData.dataWithContentsOfURL(url);
        assertEquals("has data", data.className(), "NSData");
        var image = NSImage.alloc().initWithData(data);
        assertEquals("has image", image.className(), "NSImage");
        return image;
      }
      return nil;
    };

    return this;

};

Sketch.loadFramework = function(name, dir) {
    var mocha = Mocha.sharedRuntime();
    var directory = (Sketch.paths().root + dir);
    /* jshint ignore:start */
    var success = [mocha loadFrameworkWithName:name inDirectory:directory];
    /* jshint ignore:end */
    return success;
};

Sketch.paths = function() {
  this.scriptPath = coscript.env().scriptURL.path()+"";
  this.root = 	(function(){
               var scriptPath = coscript.env().scriptURL.path() + "";
               var NSScriptPath = NSString.stringWithString(scriptPath);

               while(NSScriptPath.lastPathComponent().pathExtension() != "sketchplugin"){
               NSScriptPath = NSScriptPath.stringByDeletingLastPathComponent();
               }

               return NSScriptPath+"";
               })();

  this.installPath = (function() {
                     var appSupportPath = NSFileManager.defaultManager().URLsForDirectory_inDomains(NSApplicationSupportDirectory,NSUserDomainMask).firstObject().path();
                     var pluginFolderPath = appSupportPath.stringByAppendingPathComponent("com.bohemiancoding.sketch3/Plugins");
                     return pluginFolderPath;
                     })();

  var classExists = function(name) {
      return NSClassFromString(name) !== null;
  };

  return this;
};

Sketch.delegate = function() {
  var app = COScript.app("Sketch");
  return app.delegate();
};

Sketch.context = function() {
  var controller = Sketch.delegate();
  return controller.pluginContext();
};

Sketch.selection = function(context) {
  _context = context;
  this.setSelectedLayer = function(layer) {
    var layers = [NSArray arrayWithObject:layer]    // jshint ignore:line
    _context.document.setSelectedLayers(layers);
  };
  return this;
}
