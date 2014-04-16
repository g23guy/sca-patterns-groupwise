#!/usr/bin/perl

# Title:       GroupWise Agents Running as Root User
# Description: Check to see if the GroupWise agents were started as the root user.
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
	PROPERTY_NAME_CATEGORY."=Agent",
	PROPERTY_NAME_COMPONENT."=User",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7000315"
);




##############################################################################
# Local Function Definitions
##############################################################################

sub analyzeRunningAgents {
	SDP::Core::printDebug('> analyzeRunningAgents', 'BEGIN');
	use constant CMD => 9;
	use constant OWNER => 0;
	use constant PID => 1;
	my $RCODE = 0;
	my $HEADER_LINES = 1;
	my $FILE_OPEN = 'basic-health-check.txt';
	my $SECTION = 'ps axwwo';
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $LINE = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			$LINE++;
			next if ( $LINE < $HEADER_LINES ); # Skip header lines
			next if ( /^\s*$/ );                  # Skip blank lines
			@LINE_CONTENT = split(/\s+/, $_);
			if ( $LINE_CONTENT[CMD] =~ /gwpoa$|gwdca$|gwmta$|gwinter$|gwia$|gwdva$/i ) {
				SDP::Core::printDebug("GW PROCESS $LINE", $_);
				if ( $LINE_CONTENT[OWNER] =~ /root/ ) {
					SDP::Core::printDebug(" OWNER", 'Triggered by root');
					$RCODE++;
					SDP::Core::updateStatus(STATUS_PARTIAL, " Running as root: $LINE_CONTENT[CMD] ($LINE_CONTENT[PID])");
				}
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $RCODE ) {
		SDP::Core::updateStatus(STATUS_WARNING, "GroupWise Agent(s) Running with root User Priviledges");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "GroupWise Agent(s) Running as Non-root User");
	}
	SDP::Core::printDebug("< analyzeRunningAgents", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( ! analyzeRunningAgents() ) {
		SDP::Core::updateStatus(STATUS_ERROR, 'No GroupWise Agents Loaded');
	}
SDP::Core::printPatternResults();

exit;

