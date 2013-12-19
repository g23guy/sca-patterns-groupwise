#!/usr/bin/perl

# Title:       GroupWise 8 support on OES1/SLES9
# Description: Checks if GroupWise 8 is installed on OES1/SLES9, which is unsupported.
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
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
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
	PROPERTY_NAME_CATEGORY."=Base",
	PROPERTY_NAME_COMPONENT."=System",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003913",
	"META_LINK_MISC=http://www.novell.com/documentation/gw8/gw8_install/?page=/documentation/gw8/gw8_install/data/a8sdpxb.html"
);




##############################################################################
# Local Function Definitions
##############################################################################

sub isInstalledGW8 {
	SDP::Core::printDebug('> isInstalledGW8', 'BEGIN');
	my $RCODE = 0;
	my @GWRPMS = qw(novell-groupwise-agents novell-groupwise-gwcheck novell-groupwise-gwclient novell-groupwise-gwha novell-groupwise-gwia novell-groupwise-gwinter novell-groupwise-gwmon novell-groupwise-monitor novell-groupwise-webaccess);
	my $VERSION_TO_COMPARE = '8';
	my $RPM_COMPARISON;
	my $RPM_NAME;

	foreach $RPM_NAME (@GWRPMS) {
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_PARTIAL, "RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON >= 0 ) {
				SDP::Core::updateStatus(STATUS_WARNING, "RPM $RPM_NAME meets or exceeds GroupWise version $VERSION_TO_COMPARE");
				$RCODE++;
			} else {
				SDP::Core::updateStatus(STATUS_PARTIAL, "RPM $RPM_NAME is less than GroupWise version $VERSION_TO_COMPARE");
			}
		}
	}
	SDP::Core::printDebug("< isInstalledGW8", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( compareKernel(SLE10GA) < 0 ) {
		if ( isInstalledGW8() ) {
			SDP::Core::updateStatus(STATUS_CRITICAL, 'GroupWise 8 is unsupported on OES1/SLE9');
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, 'GroupWise 8 is not installed on OES1/SLE9');
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, 'SLE9 or lower required for this GW8 check');
	}
SDP::Core::printPatternResults();

exit;

