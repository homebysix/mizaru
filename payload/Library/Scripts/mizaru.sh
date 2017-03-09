#!/bin/bash

###
#
#            Name:  mizaru.sh
#     Description:  This script disables Munki if a test URL on the Munki repo
#                   does not return the expected result. This prevents
#                   computers from checking in to non-internet-accessible Munki
#                   repositories when they're on foreign networks, thus
#                   minimizing the possibility of a man-in-the-middle attack.
#                   This script is intended to be triggered by a LaunchDaemon
#                   with WatchPaths that include
#                   /Library/Preferences/SystemConfiguration/
#                   (thus, triggering the script on every network change).
#          Author:  Elliot Jordan <elliot@elliotjordan.com>
#         Created:  2017-03-09
#   Last Modified:  2017-03-09
#         Version:  1.0
#
###

# The URL to the file that verifies your Munki repo.
TEST_URL="https://munki.example.com/repo/mizaru"

# The md5 hash of the contents of the above URL.
# Calculate this using: curl -s "$TEST_URL" | md5
HASH="d41d8cd98f00b214e2803948e5f8727e"

if [[ "$(curl -s "$TEST_URL" | md5)" != "$HASH" ]]; then
    if launchctl list | grep -q "com.googlecode.munki"; then
        launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*
    fi
else
    if ! launchctl list | grep -q "com.googlecode.munki"; then
        launchctl load /Library/LaunchDaemons/com.googlecode.munki.*
    fi
fi
