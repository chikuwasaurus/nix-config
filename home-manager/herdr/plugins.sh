#!/usr/bin/env sh

# Install Herdr plugins on a new machine.
# Re-running this script reinstalls existing plugins.
# Herdr automatically cleans up old installations.

set -eu

herdr plugin install zenbu-labs/terminal-browser/herdr-plugin --yes
