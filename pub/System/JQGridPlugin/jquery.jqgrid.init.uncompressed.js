jQuery(function($) {
  var defaults = {
    height:'auto',
    cellLayout:18,
    forceFit: true,
    viewrecords: true,
    filterToolbar: false,
    altRows: true,
    onSortCol: function(index, iCol, sortOrder) {
      var $table = $(this), 
          id = $table.attr('id'),
          $header = $("#gbox_"+id),
          className = 'ui-jqgrid-sortcol';

      // SMELL: smell
      window.setTimeout(function() {
        $table.find("."+className).removeClass(className);
        $header.find("."+className).removeClass(className);
        $table.find("tr td:nth-child("+(iCol+1)+")").addClass(className);
        $header.find("tr th:nth-child("+(iCol+1)+")").addClass(className);
      }, 0);
    }
  };

  function init($table, options) {
    var id = options.gridId || foswiki.getUniqueID();
    $table.attr("id", id);

    if (options.pager) {
      $table.after("<div id='"+options.pager+"'></div>");
    }

    // remove anchors from TablePlugin
    $table.find("th a").each(function() {
      var $this = $(this), text = $this.text();
      $this.parent().html(text);
    });

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
