# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
# 
# Copyright (C) 2009-2014 Michael Daum, http://michaeldaumconsulting.com
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

package Foswiki::Plugins::JQGridPlugin::Connector;

use strict;
use warnings;
use Encode ();

=begin TML

---+ package Foswiki::Plugins::JQGridPlugin::Connector

base class for grid connectors used to feed a jqGrid widget

=cut

sub new {
  my ($class, $session) = @_;

  my $this = {
    session => $session,
    propertyMap => {},
  };

  return bless($this, $class);
}

=begin TML

---++ ClassMethod restHandleSave($request, $response)

this is called by the gridconnector REST handler based on the "oper"
url parameter as provided by the GRID widget.

=cut

sub restHandleSave {
  die "restHandleSave not implemented";
}

=begin TML

---++ ClassMethod restHandleSearch($request, $response)

this is called by the gridconnector REST handler based on the "oper"
url parameter as provided by the GRID widget.

=cut

sub restHandleSearch {
  die "restHandleSearch not implemented";
}

=begin TML

---++ ClassMethod column2Property( $columnName ) -> $propertyName

maps a column name to the actual property in the store. 

=cut

sub column2Property {
  my ($this, $columnName) = @_;

  return unless defined $columnName;
  return $this->{propertyMap}{$columnName} || $columnName;
}


=begin TML

---++ StaticMethod fromUtf8 ($string) -> $string

converts an utf8 string to its internal representation

=cut

sub fromUtf8 {
  my $string = shift;

  my $charset = $Foswiki::cfg{Site}{CharSet};
  return $string if $charset =~ /^utf-?8$/i;

  my $encoding = Encode::resolve_alias($charset);
  if (not $encoding) {
    print STDERR 'Warning: Conversion to "' . $charset . '" not supported, or name not recognised - check ' . '"perldoc Encode::Supported"'."\n";;
    return $string;
  } else {

    # converts to $charset, generating HTML NCR's when needed
    my $octets = $string;
    $octets = Encode::decode('utf-8', $string);
    return Encode::encode($encoding, $octets, 0);
  }
}

=begin TML

---++ StaticMethod urlDecode( $text ) -> $text

from Fowiki.pm

=cut

sub urlDecode {
  my $text = shift;
  $text =~ s/%([\da-f]{2})/chr(hex($1))/gei;
  return $text;
}

1;

