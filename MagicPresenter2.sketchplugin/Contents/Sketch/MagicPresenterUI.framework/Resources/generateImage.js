var generateImage = function(document, layer, scale) {
    var flattener = MSLayerFlattener.alloc().init();
    var array = MSLayerArray.arrayWithLayer(layer)
    var data = document.immutableDocumentData()
    var impage = data.currentPage()
    
    var request = nil;
    if ([layer isKindOfClass:MSSliceLayer]) {
        request = data.exportRequestForArtboardOrSlice(layer);
    } else {
        request = [flattener exportRequestFromLayers:array immutablePage:impage immutableDoc:data];
    }
    request.scale = scale;

    var renderer = [MSExportRendererWithSVGSupport exporterForRequest:request colorSpace:[NSColorSpace sRGBColorSpace]];
    var image = renderer.image()
    return image;
}

var isEqual = function (first, second) {
    if (typeof first !== typeof second) {
        return false
    }
    var tree = MSTreeDiff.alloc().initWithFirstObject_secondObject_(first, second);
    return tree.diffs().count() == 0
}
