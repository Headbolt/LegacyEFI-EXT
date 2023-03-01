#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	LegacyEFI-EXT.sh
#	https://github.com/Headbolt/LegacyEFI
#
#   This Script is designed for use in JAMF as an Extension Attribute
#
#   - This script will ...
#		Grab the status of the "Legacy EFI"
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.0 - 01/03/2023
#
#	01/03/2023 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
Processor=$(/usr/bin/sudo /usr/bin/sudo /usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/grep "Apple")
#
if [[ "$Processor" != "" ]]
	then
    	result="Compliant"
	else
		T2=$(/usr/bin/sudo /usr/sbin/system_profiler SPiBridgeDataType | /usr/bin/grep "T2")
		if [[ "$T2" != "" ]]
			then
				result="Compliant"
			else
				IntegrityCheck=$(/usr/bin/sudo /usr/libexec/firmwarecheckers/eficheck/eficheck --integrity-check | /usr/bin/grep "Primary allowlist version match found. No changes detected in primary hashes")
				if [[ "$IntegrityCheck" != "" ]]
					then
						DaemonCheck=$(/usr/bin/sudo /bin/launchctl list | /usr/bin/grep "com.apple.driver.eficheck")
						if [[ "$DaemonCheck" != "" ]]
							then
								result="Compliant"
							else
								result="Not Compliant"
						fi
					else
						result="Not Compliant"
				fi
		fi
fi
/bin/echo "<result>$result</result>"
