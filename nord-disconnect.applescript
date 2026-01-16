#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Disconnect VPN
# @raycast.mode compact
# @raycast.packageName NordVPN

# Optional parameters:
# @raycast.icon ⚠️
# @raycast.alias nord dc

# Documentation:
# @raycast.description Disconnect from NordVPN
# @raycast.author lemonteaau
# @raycast.authorURL https://github.com/lemonteaau

tell application "NordVPN" to activate

tell application "System Events"
	tell process "NordVPN"
		-- Wait for window
		repeat until (exists window 1)
			delay 0.1
		end repeat
		
		-- Wait for main group
		repeat until (exists group 1 of window 1)
			delay 0.1
		end repeat
		set mainGroup to group 1 of window 1
		
		-- Wait for content area
		repeat until (exists UI element 3 of mainGroup)
			delay 0.1
		end repeat
		set contentArea to UI element 3 of mainGroup
		
		-- Check if connected by looking at the status text
		-- When disconnected, it shows "Connect to VPN"
		-- When connected, it shows connection info
		repeat until (exists UI element 1 of contentArea)
			delay 0.1
		end repeat
		
		try
			set statusText to value of UI element 1 of contentArea
			
			-- If showing "Connect to VPN", already disconnected
			if statusText contains "Connect to VPN" then
				log "VPN is not connected"
				return
			end if
		on error
			-- Continue if status check fails
		end try
		
		-- Wait for pause button (only exists when connected)
		repeat until (exists UI element 2 of contentArea)
			delay 0.1
		end repeat
		set pauseButton to UI element 2 of contentArea
		
		-- Verify this is the pause button, not "Secure my connection"
		try
			set buttonDesc to description of pauseButton
			if buttonDesc contains "Secure" or buttonDesc contains "Connect" then
				log "VPN is not connected"
				return
			end if
		end try
		
		-- Click pause button to show disconnect menu
		click pauseButton
		
		-- Wait for disconnect menu
		repeat until (exists UI element 6 of contentArea)
			delay 0.1
		end repeat
		set disconnectMenu to UI element 6 of contentArea
		
		-- Click disconnect option
		repeat until (exists UI element 6 of disconnectMenu)
			delay 0.1
		end repeat
		set disconnectMenuItem to UI element 6 of disconnectMenu
		click disconnectMenuItem
		
		log "VPN disconnected"
	end tell
end tell
