#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Connect COUNTRY_NAME
# @raycast.mode compact
# @raycast.packageName NordVPN

# Optional parameters:
# @raycast.icon 🌍
# @raycast.alias nord xx

# Documentation:
# @raycast.description Connect to NordVPN COUNTRY_NAME server
# @raycast.author lemonteaau
# @raycast.authorURL https://github.com/lemonteaau

-- ============================================================================
-- TEMPLATE: Copy this file and modify the following:
--   1. Change "COUNTRY_NAME" in @raycast.title to your country (e.g., "Japan")
--   2. Change the icon to the country flag emoji (e.g., 🇯🇵)
--   3. Change the alias to something memorable (e.g., "nord jp")
--   4. Change "COUNTRY_NAME" in the handlerPath line below
--   5. Update handlerPath to match your script location
-- ============================================================================

set handlerPath to "/PATH/TO/nord-connect-handler.applescript"
do shell script "osascript " & quoted form of handlerPath & " 'COUNTRY_NAME'"
