# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
# 
# Copyright (C) 2009-2011 Michael Daum, http://michaeldaumconsulting.com
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. 
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::JQGridPlugin::GRID;
use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugin ();
use Foswiki::Plugins::JQueryPlugin::Plugins ();
use Foswiki::Form ();

our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

=begin TML

---+ package Foswiki::Plugins::JQGridPlugin::GRID

This is the perl stub for the jquery.grid plugin.

=cut

=begin TML

---++ ClassMethod new( $class, $session, ... )

Constructor

=cut

sub new {
  my $class = shift;
  my $session = shift || $Foswiki::Plugins::SESSION;

  my $this = bless($class->SUPER::new( 
    $session,
    name => 'Grid',
    version => '3.7.2',
    author => 'Tony Tomov',
    homepage => 'http://www.trirand.com/blog/',
    puburl => '%PUBURLPATH%/%SYSTEMWEB%/JQGridPlugin',
    javascript => ['jquery.jqgrid.js', 'jquery.jqgrid.init.js'],
    css => ['css/jquery.jqgrid.css'],
    dependencies => ['ui', 'metadata', 'livequery', 'JQUERYPLUGIN::THEME', 'JQUERYPLUGIN::GRID::LANG'], 
  ), $class);

  return $this;
}

=begin TML

---++ ClassMethod init( $this )

Initialize this plugin by adding the required static files to the html header

=cut

sub init {
  my $this = shift;

  return unless $this->SUPER::init();

  # open matching localization file if it exists
  my $langTag = $this->{session}->i18n->language();
  my $localeFile = 'i18n/grid.locale-'.$langTag.'.js';
  $localeFile = 'i18n/grid.locale-en.js' 
    unless -f $this->{puburl}.'/'.$localeFile;

  my $header .= $this->renderJS($localeFile);
  Foswiki::Func::addToZone('script', "JQUERYPLUGIN::GRID::LANG", $header, 'JQUERYPLUGIN');
}

=begin TML

---++ ClassMethod handleGrid( $this, $params, $topic, $web ) -> $result

Tag handler for =%<nop>GRID{web="blah"}%=. 

=cut

sub handleGrid {
  my ($this, $params, $topic, $web) = @_;

  my $theQuery = $params->{_DEFAULT} || $params->{query} || '';
  my $theWeb = $params->{web} || $web;
  my $theForm = $params->{form} || '';
  my $theCols = $params->{columns};
  my $theRows = $params->{rows};
  my $theRowNumbers = $params->{rownumbers} || 'off';
  my $theInclude = $params->{include};
  my $theExclude = $params->{exclude};
  my $theFilterbar = $params->{filterbar} || 'off';
  my $theToolbar = $params->{toolbar} || 'off'; # navGrid
  my $theSort = $params->{sort};
  my $theReverse = $params->{reverse} || 'off';
  my $theCaption = $params->{caption};
  my $thePager = $params->{pager} || 'off';
  my $theViewRecords = $params->{viewrecords} || 'on';
  my $theHeight = $params->{height} || 'auto';
  my $theWidth = $params->{width};
  my $theScroll = $params->{scroll} || 'off';
  my $theRowList = $params->{rowlist} || '5, 10, 20, 30, 40, 50, 100';
  my $theEdit = $params->{edit} || 'off';
  my $theMulti = $params->{multiselect} || 'off';
  my $theLoadonce = $params->{loadonce} || 'off';
  my $theSortable = $params->{sortable} || 'off';
  my $theGridComplete = $params->{gridComplete};
  my $theOnSelectRow = $params->{onSelectRow};
  my $theOnSelectAll = $params->{onSelectAll};
  my $theConnector = $params->{connector} || $Foswiki::cfg{JQGridPlugin}{DefaultConnector};

  # sanitize params
  $theRowNumbers = ($theRowNumbers eq 'on')?'true':'false';
  my $gridId = $params->{id} || "jqGrid".Foswiki::Plugins::JQueryPlugin::Plugins::getRandom();
  my $pagerId = "jqGridPager".Foswiki::Plugins::JQueryPlugin::Plugins::getRandom();

  my $filterToolbar = '';
  if ($theFilterbar eq 'on') {
    $filterToolbar = <<"HERE";
myGrid.jqGrid('filterToolbar'); 
HERE
  }
  my $navGrid = '';
  if ($theToolbar eq 'on') {
    $navGrid = <<"HERE";
myGrid.jqGrid('navGrid', '#$pagerId', {
  search:false, 
  edit:false, 
  del:false, 
  refresh:false, 
  add:false
});
myGrid.jqGrid('navButtonAdd', '#$pagerId', {
  caption:'%MAKETEXT{"Clear"}%',
  title:'%MAKETEXT{"Clear Search"}%',
  buttonicon:'ui-icon-refresh', 
  onClickButton:function() { 
    myGrid[0].clearToolbar();
  } 
}); 
HERE
  }

# SMELL: parked code
#
# myGrid.jqGrid('navButtonAdd', '#$pagerId', {
#   caption:'%MAKETEXT{"Search"}%',
#   title:'%MAKETEXT{"Toggle Search"}%', 
#   buttonicon:'ui-icon-search',
#   onClickButton:function() { 
#     myGrid[0].toggleToolbar(); 
#   } 
# }); 

  my $sortOrder = ($theReverse eq 'on'?'desc':'asc');

#    "foswiki_filtertoolbar:".($theFilterbar eq 'on'?'true':'false'),
#    "foswiki_navgrid:".($theToolbar eq 'on'?'true':'false'),
  my @metadata = (
    "rowList:[$theRowList]",
    "sortorder: '$sortOrder'",
    "rownumbers: $theRowNumbers",
    "cellLayout: 18", # SMELL: this is depending on the skin's css :(
  );
 
  push @metadata, "multiselect:true" if $theMulti eq 'on';
  push @metadata, "rowNum:$theRows" if defined $theRows;
  push @metadata, "pager:'$pagerId'" if $thePager eq 'on';
  push @metadata, "sortname: '$theSort'" if $theSort;
  push @metadata, "height: '$theHeight'" if $theHeight;
  push @metadata, 'scroll: true' if $theScroll eq 'on';
  push @metadata, 'viewrecords: true' if $theViewRecords eq 'on';
  push @metadata, 'loadonce: true' if $theLoadonce eq 'on';
  push @metadata, 'sortable: true' if $theSortable eq 'on';
  push @metadata, 'onSelectRow: ' . $theOnSelectRow if $theOnSelectRow;
  push @metadata, 'onSelectAll: ' . $theOnSelectAll if $theOnSelectAll;
  push @metadata, 'gridComplete: ' . $theGridComplete if $theGridComplete;
  

  if (defined $theWidth) {
    if ($theWidth && $theWidth eq 'auto') {
      push @metadata, "autowidth: true";
    } else {
      push @metadata, "width: '$theWidth'";
    }
  }

  push @metadata, "caption:'$theCaption'" if defined $theCaption; 

  if ($theQuery || $theForm) {
    # ajax mode #############################
    if (!$theQuery && $theForm) {
      $theQuery = "form.name='$theForm'";
    }

    my $theFormWeb = $theWeb;
    ($theFormWeb, $theForm) = Foswiki::Func::normalizeWebTopicName($theFormWeb, $theForm);

    my @selectedFields = ();
    if ($theCols) {
      foreach my $fieldName (split(/\s*,\s*/, $theCols)) {
        push @selectedFields, $fieldName;
      }
    } else {
      my $form = new Foswiki::Form($this->{session}, $theFormWeb, $theForm);
      @selectedFields = map {$_->{name}} @{$form->getFields()} if $form;
    }

    if ($theInclude) {
      @selectedFields = grep {/^($theInclude)$/} @selectedFields;
    }
    if ($theExclude) {
      @selectedFields = grep {!/^($theExclude)$/} @selectedFields;
    }

    # get model
    my @colModels;
    foreach my $fieldName (@selectedFields) {

      my @colModel;
      push @colModel, "name:'$fieldName'";

      # switch off tooltips as they are wrong most of the time using renderForDisplay to display cells
      push @colModel, "title:false";

      # title
      my $fieldTitle = $params->{$fieldName.'_title'};
      $fieldTitle = $fieldName unless defined $fieldTitle;
      push @colModel, "label:'$fieldTitle'";

      # resizable
      my $fieldResizable = $params->{$fieldName.'_resizable'};
      $fieldResizable = 'on' unless defined $fieldResizable;
      $fieldResizable = ($fieldResizable eq 'on')?'true':'false';
      push @colModel, "resizable:$fieldResizable";

      # align
      my $fieldAlign = $params->{$fieldName.'_align'};
      $fieldAlign = 'left' unless defined $fieldAlign;
      push @colModel, "align:'$fieldAlign'";

      # width
      my $fieldWidth = $params->{$fieldName.'_width'};
      push @colModel, "width:$fieldWidth" if defined $fieldWidth;

      # search
      my $fieldSearch = $params->{$fieldName.'_search'};
      $fieldSearch = 'on' unless defined $fieldSearch;
      $fieldSearch = ($fieldSearch eq 'on')?'true':'false';
      push @colModel, "search:$fieldSearch";

      # formatter, but also for table2grid mode
      # TODO
      if ($fieldName =~ /^(Date|Changed|Modified|info.date|info.createdate)$/) {
        push @colModel, "formatter:'date'";
        push @colModel, "formatoptions: {srcformat: 's', newformat: 'd M Y - H:i'}";
        push @colModel, "sorttype:'date'";
      }
      if ($fieldName =~ /^(.*Topic|TopicTitle)$/) {
        push @colModel, "formatter:'topic'";
      }
      if ($fieldName =~ /(Image|Photo)$/) {
        push @colModel, "formatter:'image'";
      }

      # edit
      if ($theEdit eq 'on') {
        if ($fieldName =~ /^(Changed|Modified|Author|info.date|info.author|Topic|topic)$/) {
          push @colModel, "editable:false";
        } else {
          push @colModel, "editable:true";
          push @colModel, "edittype:'text'";
        }
      }

      # colmodel
      push @colModels, '{ '.join(', ', @colModel).'}';

      $theSort = $fieldName unless $theSort;
    }

    push @metadata, 'colModel: ['.join(",\n", @colModels).']';

    my $baseWeb = $this->{session}->{webName};
    my $baseTopic = $this->{session}->{topicName};
    my $gridConnectorUrl;

    my ($connectorWeb, $connectorTopic) = Foswiki::Func::normalizeWebTopicName($baseWeb, $theConnector);
    if (Foswiki::Func::topicExists($connectorWeb, $connectorTopic)) {
      $gridConnectorUrl = Foswiki::Func::getScriptUrl(
        $connectorWeb, $connectorTopic, 'view',
        web => $theWeb,
        skin => 'text',
        contenttype => 'text/xml',
        section => 'grid',
        query => $theQuery,
        columns => join(',', @selectedFields)
      );
    } else {

      if (defined $Foswiki::cfg{JQGridPlugin}{Connector}{$theConnector}) {
        $gridConnectorUrl = Foswiki::Func::getScriptUrl(
          'JQGridPlugin', 'gridconnector', 'rest',
          topic => $baseWeb . '.' . $baseTopic,
          web => $theWeb,
          query => $theQuery,
          columns => join(',', @selectedFields),
          connector => $theConnector,
        );
      } else {
        die "unknown grid connector $theConnector"; # SMELL: where's the catch
      }
    }
    $gridConnectorUrl =~ s/'/\\'/g;

    push @metadata, "url:'$gridConnectorUrl'";
    push @metadata, "datatype: 'xml'";
    push @metadata, "mtype: 'GET'";

    if ($theEdit eq 'on') {
      push @metadata, "editurl:'$gridConnectorUrl'"; 
      my $onSelect = <<"HERE";
ondblClickRow: function(id) { 
  var grid = \$(this);
  var lastSel = grid.data('lastSel');
  if(id && id !== lastSel) { 
    if (lastSel) {
      grid.jqGrid('restoreRow', lastSel); 
    }
    grid.jqGrid('editRow', 
      id, 
      true, 
      function(id) { //oneditfunc
        //console.log('called oneditfunc');
      },
      function(id) { // successfunc
        \$.log("GRID: success");
        grid.trigger("reloadGrid");
        grid.removeData("lastSel");
        return true;
      }, 
      false, // url
      '', // extra param
      function(id) {
        \$.log("GRID: after save");
        grid.removeData("lastSel");
      },
      function (id) {
        \$.log("GRID: error");
        grid.removeData("lastSel");
      },
      function (id) {
        \$.log("GRID: after restore");
        grid.removeData("lastSel");
      }
    ); 
    grid.data("lastSel", id);
  }
}
HERE
      push @metadata, $onSelect;
    }

    my $metadata = '{'.join(",\n", @metadata)."}\n";
    my $autoResizer = '';
    if (defined $theWidth && $theWidth eq 'auto') {
      $autoResizer = <<"HERE";
  jQuery(window).bind("resize", function() {
    var parent = myGrid.parents('.ui-jqgrid:first').parent();
    var gridWidth = parent.width()-2;
    myGrid.setGridWidth(gridWidth);
  });
HERE
    }


    my $jsTemplate = <<"HERE";
<script>
jQuery(function(\$) {
  var myGrid = \$('#$gridId').jqGrid($metadata);
  $filterToolbar;
  $navGrid;
  $autoResizer;
}); 
</script>
HERE

    Foswiki::Func::addToZone('script', "JQUERYPLUGIN::GRID::$gridId", $jsTemplate, 'JQUERYPLUGIN::GRID');

    my $result = "<table id='$gridId'></table>";
    $result .= "<div id='$pagerId'></div>" if $thePager eq 'on';
    return $result;
  } else {
    # table conversion mode #############################
    push @metadata, "gridId:'$gridId'";
    push @metadata, "filterToolbar: true" if $theFilterbar eq 'on';
    my $metadata = '{'.join(', ', @metadata).'}';
    return '<div class="jqTable2Grid '.$metadata.'"></div>';
  }
}

1;
