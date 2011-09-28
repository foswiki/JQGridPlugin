# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2009-2011 Michael Daum, http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
package Foswiki::Plugins::JQGridPlugin;
use strict;
use warnings;

our $VERSION = '$Rev$';
our $RELEASE = '2.01';
our $SHORTDESCRIPTION = 'jQuery grid widget for Foswiki';
our $NO_PREFS_IN_TOPIC = 1;
our $doInit = 0;

use Foswiki::Plugins::JQueryPlugin ();
use Error qw(:try);

sub initPlugin {
  my ($topic, $web, $user) = @_;

  Foswiki::Plugins::JQueryPlugin::registerPlugin('grid', 'Foswiki::Plugins::JQGridPlugin::GRID');

  Foswiki::Func::registerTagHandler('GRID', \&handleGrid);
  Foswiki::Func::registerRESTHandler('gridconnector', \&restGridConnector);

  my $selector = Foswiki::Func::getPreferencesValue('JQGRIDPLUGIN_TABLE2GRID');# || '.foswikiTable';

  if ($selector) {
    $doInit = 1; # delay createplugin 
    Foswiki::Func::addToZone('head', 'JQGRIDPLUGIN::META', <<HERE);
<meta name='foswiki.JQGridPlugin.table2Grid' content='$selector' />
HERE
  }

  return 1;
}

sub afterCommonTagsHandler {

  return unless $doInit;
  $doInit = 0;

  my $session = $Foswiki::Plugins::SESSION;
  Foswiki::Plugins::JQueryPlugin::createPlugin('Grid', $session);
}

sub handleGrid {
  my $session = shift;
  my $plugin = Foswiki::Plugins::JQueryPlugin::createPlugin('Grid', $session);
  return $plugin->handleGrid(@_) if $plugin;
  return '';
}

sub restGridConnector {
  my ($session, $subject, $verb, $response) = @_;

  my $request = Foswiki::Func::getCgiQuery();

  my $connectorID = $request->param('connector') || $Foswiki::cfg{JQGridPlugin}{DefaultConnector};
  my $connectorClass = $Foswiki::cfg{JQGridPlugin}{Connector}{$connectorID};


  unless ($connectorClass) {
    printRESTResult($response, 500, "ERROR: unknown connector $connectorID");
    return '';
  }

  eval "require $connectorClass";
  if ($@) {
    printRESTResult($response, 500, "ERROR: loading connector $connectorID - $@");
    return '';
  }

  my $connector = $connectorClass->new($session);

  my $action = $request->param('oper') || 'search';
  try {
    if ($action eq 'edit') {
      $connector->restHandleSave($request, $response);
    } else {
      $connector->restHandleSearch($request, $response);
    }
  } catch Foswiki::AccessControlException with {
    my $error = shift;
    printRESTResult($response, 401, "ERROR: Unauthorized access to $error->{web}.$error->{topic}");
  } catch Error::Simple with {
    my $error = shift;
    printRESTResult($response, 500, "ERROR: ".$error);
  };

  return '';
}

sub printRESTResult {
  my ($response, $status, $text) = @_;

  $response->header(
    -status  => $status,
    -type    => 'text/html',
  );

  $response->print("$text\n");
}

1;
