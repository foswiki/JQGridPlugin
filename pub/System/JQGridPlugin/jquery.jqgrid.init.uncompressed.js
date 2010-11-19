jQuery(function($) {
  var defaults = {
    height:'auto',
    cellLayout:18,
    forceFit: true,
    viewrecords: true,
    filterToolbar: false
  };

  function init($table, options) {
    var id = options.gridId || foswiki.getUniqueID();
    $table.attr("id", id);

    if (options.pager) {
      $table.after("<div id='"+options.pager+"'></div>");
    }

    //$table.debug();
    //$(options).debug();
    tableToGrid($table, options);
    if (options.filterToolbar) {
      $table.jqGrid('filterToolbar');
    }

    var $grid = $table.jqGrid();
    if(options.foswiki_filtertoolbar) {
      $grid.filterToolbar();
    }
    if(options.foswiki_navgrid) {
      $grid.navGrid();
    }

    $table.removeClass("foswikiTable").addClass("jqInitedGrid");
    $table.addClass("jqInitedGrid");
  }

  // initinitializer for %GRID%
  $(".jqTable2Grid").livequery(function() {
    var $this = $(this);
    var options = $.extend({}, defaults, $this.metadata());
    var $table = $this.nextAll('table:first');
    init($table, options);
    //$this.remove();
  });

  // initializer for automatic table2Grids
  var table2Grid = foswiki.getPreference("JQGridPlugin.table2Grid");
  if (table2Grid) {
    $(table2Grid).livequery(function() {
      var $this = $(this);
      var options = $.extend({}, defaults, $this.metadata());
      init($this, options);
    });
  }
});
