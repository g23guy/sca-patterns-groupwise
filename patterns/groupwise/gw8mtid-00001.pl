#!/usr/bin/perl

# Title:       Master TID: GroupWise 8
# Description: Recommends GroupWise 8 master TID if applicable.
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
	PROPERTY_NAME_CATEGORY."=Master TID",
	PROPERTY_NAME_COMPONENT."=GroupWise",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Master",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Master=http://www.suse.com/support/kb/doc.php?id=7001971"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my @GW_PKGS = qw(novell-groupwise-client novell-groupwise-gwha novell-groupwise-agents novell-groupwise-gwinter novell-groupwise-monitor novell-groupwise-admin novell-groupwise-gwmon novell-groupwise-gwcheck novell-groupwise-gwia novell-groupwise-webaccess novell-groupwise-calhost);
	#my $VERSION_TO_COMPARE = '8.0.1-88138';
	my $VERSION_TO_COMPARE = '8';
	my $RPM_NAME = '';
	my $GW8 = 0;
	foreach $RPM_NAME (@GW_PKGS) {
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::printDebug('ERROR', "ERROR: RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::printDebug('ERROR', "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON >= 0 ) {
				SDP::Core::updateStatus(STATUS_RECOMMEND, "Consider TID7001971 - GroupWise 8 current information and issues");
				$GW8 = 1;
				last;
			}                       
		}
	}
	SDP::Core::updateStatus(STATUS_ERROR, "Master TID not applicable, missing GroupWise 8 packages") if ( ! $GW8 );
SDP::Core::printPatternResults();

exit;

