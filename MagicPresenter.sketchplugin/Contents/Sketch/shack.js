var $ = {};

$.initialize = function(context) {
  this.context = context;
  return this;
};

$.ui = {
  "splitViewController" : function() {
    return context.document.splitViewController();
  },
  "splitView" : function() {
    return this.splitViewController().splitView();
  },
}
