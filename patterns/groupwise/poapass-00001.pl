#!/usr/bin/perl

# Title:       GroupWise 8.0.0 HP2 POA Susceptible to Required Passwords
# Description: Users that normally authenticate to eDirectory so that no GroupWise password is necessary get prompted for their password when using the GroupWise 8.0.1 client.
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
	PROPERTY_NAME_CATEGORY."=Auth",
	PROPERTY_NAME_COMPONENT."=Passwords",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003933",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=523582"
);




##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();

	my $RPM_NAME = 'novell-groupwise-agents';
	my $VERSION_TO_COMPARE = '8.0.0HP';
	my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
	if ( $RPM_COMPARISON == 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "RPM $RPM_NAME Not Installed");
	} elsif ( $RPM_COMPARISON > 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "Multiple Versions of $RPM_NAME RPM are Installed");
	} else {
		if ( $RPM_COMPARISON == 0 ) {
			SDP::Core::updateStatus(STATUS_WARNING, "GroupWise 8.0.1 clients may be receive unwanted password prompts, update POA");
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "GroupWise POA Password Issue not Detected");
		}                       
	}

SDP::Core::printPatternResults();

exit;

