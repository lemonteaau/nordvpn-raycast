#!/usr/bin/osascript

-- NordVPN Connect Handler for Raycast
-- A fast, optimized script to connect to NordVPN servers
-- 
-- Usage: osascript nord-connect-handler.applescript "Country Name"
-- Example: osascript nord-connect-handler.applescript "Japan"
--
-- Optimization Strategy:
-- Instead of scanning the entire server list (which is slow), this script
-- checks specific row numbers where the target country is likely to appear.
-- The row numbers vary depending on whether "Recent connections" has loaded.
--
-- Supported countries with optimized lookup:
--   - Hong Kong (rows: 3, 58-63)
--   - Japan (rows: 2, 69-74)
--   - Taiwan (rows: 124-129)
--   - Other countries: full scan fallback
--
-- To add more countries with optimized lookup, find the row numbers using
-- the debug script and add them to the checkRows section below.

on run argv
	if (count of argv) < 1 then
		log "Usage: osascript nord-connect-handler.applescript \"Country Name\""
		return
	end if
	
	set targetCountry to item 1 of argv
	
	tell application "NordVPN" to activate
	
	tell application "System Events"
		-- Wait for NordVPN to become frontmost
		repeat 30 times
			if frontmost of process "NordVPN" then exit repeat
			delay 0.05
		end repeat
		
		tell process "NordVPN"
			-- Wait for window
			repeat until (exists window 1)
				delay 0.05
			end repeat
			set win to window 1
			
			-- Wait for main group
			repeat until (exists group 1 of win)
				delay 0.05
			end repeat
			set mainGroup to group 1 of win
			
			-- Wait for content area
			repeat until (exists UI element 3 of mainGroup)
				delay 0.05
			end repeat
			set contentArea to UI element 3 of mainGroup
			
			-- Wait for server list group
			repeat until (exists UI element 3 of contentArea)
				delay 0.05
			end repeat
			set serverListGroup to UI element 3 of contentArea
			
			-- Wait for scroll area
			repeat until (exists UI element 2 of serverListGroup)
				delay 0.05
			end repeat
			set scrollArea to UI element 2 of serverListGroup
			
			-- Wait for server table
			repeat until (exists UI element 1 of scrollArea)
				delay 0.05
			end repeat
			set serverTable to UI element 1 of scrollArea
			
			-- Determine which rows to check based on target country
			-- Row numbers differ by ~4 depending on whether Recents has loaded
			set firstChar to character 1 of targetCountry
			if firstChar is "H" then
				-- Hong Kong: Recents=3, Countries=58 or 62
				set checkRows to {3, 58, 59, 60, 61, 62, 63}
			else if firstChar is "J" then
				-- Japan: Recents=2, Countries=69 or 73
				set checkRows to {2, 69, 70, 71, 72, 73, 74}
			else if firstChar is "T" then
				-- Taiwan: Countries=124 or 128
				set checkRows to {124, 125, 126, 127, 128, 129}
			else
				-- Other countries: full scan fallback
				set checkRows to {}
			end if
			
			-- Aggressive strategy: start checking immediately, retry for ~3 seconds
			set maxAttempts to 60
			set attempts to 0
			
			repeat until attempts >= maxAttempts
				set rowCount to count of rows of serverTable
				
				-- Check multiple possible positions simultaneously
				if (count of checkRows) > 0 then
					repeat with targetRow in checkRows
						if targetRow ≤ rowCount then
							try
								set cellDesc to description of UI element 1 of row targetRow of serverTable
								if cellDesc contains targetCountry then
									click UI element 1 of UI element 1 of row targetRow of serverTable
									log "Connecting to " & targetCountry & " (row " & targetRow & ")"
									return
								end if
							end try
						end if
					end repeat
				else
					-- Full scan fallback for unsupported countries
					repeat with i from 1 to rowCount
						try
							set cellDesc to description of UI element 1 of row i of serverTable
							if cellDesc contains targetCountry then
								click UI element 1 of UI element 1 of row i of serverTable
								log "Connecting to " & targetCountry & " (row " & i & ")"
								return
							end if
						end try
					end repeat
				end if
				
				delay 0.05
				set attempts to attempts + 1
			end repeat
			
			log targetCountry & " not found"
		end tell
	end tell
end run
