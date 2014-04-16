#!/usr/bin/perl

# Title:       GroupWise GWIA Security Alert 482914
# Description: GroupWise GWIA vulnerability that could lead to arbitrary code execution with SYSTEM privileges from the way it processes email addresses in the SMTP protocol.
# Modified:    2013 Jun 22

##############################################################################
#  Copyright (C) 2013 SUSE LLC
##############################################################################
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; version 2 of the License.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, see <http://www.gnu.org/licenses/>.
#

#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)

##############################################################################

##############################################################################
# Module Definition
##############################################################################


use strict;
use warnings;
use SDP::Core;
use SDP::SUSE;

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

@PATTERN_RESULTS = (
	PROPERTY_NAME_CLASS."=GroupWise",
	PROPERTY_NAME_CATEGORY."=Security",
	PROPERTY_NAME_COMPONENT."=GWIA",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003273",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=482914"
);




##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $RPM_NAME = 'novell-groupwise-gwia';
	my $CHECKING = 'GroupWise GWIA';
	my $ADVISORY = '482914';
	my $TYPE = 'Remote code execution';
	my @PKGS_TO_CHECK = ();
	my $FIXED_VERSION = '';

	my @RPM_INFO = SDP::SUSE::getRpmInfo($RPM_NAME);
	if ( $#RPM_INFO < 0 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "RPM $RPM_NAME Not Installed");
	} elsif ( $#RPM_INFO > 0 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "Multiple Versions of $RPM_NAME RPM are Installed");
	} elsif ( SDP::Core::compareVersions($RPM_INFO[0]{'version'}, '8') == 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'GWIA 8');
		@PKGS_TO_CHECK = qw(novell-groupwise-gwia);
		$FIXED_VERSION = '8.0.0HP-87328';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::Core::compareVersions($RPM_INFO[0]{'version'}, '7') == 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'GWIA 7');
		@PKGS_TO_CHECK = qw(novell-groupwise-gwia);
		$FIXED_VERSION = '7.0.3-20090508';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the product scope");
	}

SDP::Core::printPatternResults();

exit;

