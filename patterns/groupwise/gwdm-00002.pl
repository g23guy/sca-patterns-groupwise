#!/usr/bin/perl

# Title:       Slow sync of mail for some users
# Description: Mail takes a long time to sync to Mobility for some users
# Modified:    2013 Jun 28

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
	PROPERTY_NAME_CATEGORY."=Mobility",
	PROPERTY_NAME_COMPONENT."=SOAP",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7012735"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub syncSoapFailed {
	SDP::Core::printDebug('> syncSoapFailed', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'plugin-ds_groupwise_connector.txt';
	my $SECTION = 'default.pipeline1.groupwise-AppInterface.log';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /Failure parsing soap response.*Response string.*Exception.*urlopen error.*Broken pipe/i ) {
				SDP::Core::printDebug("  syncSoapFailed FOUND", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: syncSoapFailed(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< syncSoapFailed", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( syncSoapFailed() ) {
		SDP::Core::updateStatus(STATUS_WARNING, "SOAP Response failure detected, consider restarting POA");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "No SOAP response failures found");
	}
SDP::Core::printPatternResults();

exit;


