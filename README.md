# NordVPN Raycast Scripts

Fast [Raycast](https://raycast.com) scripts to connect/disconnect NordVPN on macOS.

Quickly connect to any desired server with a single Raycast command, for example, use `nord ja` to connect to Japan or `nord dc` to disconnect.

## Installation

1. Clone or download this repository
2. Copy the scripts to your Raycast scripts folder (usually `~/.config/raycast/scripts/` or any folder you've added to Raycast)
3. Edit `nord-connect-template.applescript` to create your own connection scripts

| File                                | Description                                            |
| ----------------------------------- | ------------------------------------------------------ |
| `nord-connect-handler.applescript`  | Core handler that performs the actual connection       |
| `nord-connect-template.applescript` | Template for creating country-specific connect scripts |
| `nord-disconnect.applescript`       | Disconnect from VPN                                    |

## Usage

### Creating a Connect Script

1. Copy `nord-connect-template.applescript` and rename it (e.g., `nord-japan.applescript`)
2. Edit the file:

```applescript
# @raycast.title Connect Japan        ← Change country name
# @raycast.icon 🇯🇵                    ← Change to country flag
# @raycast.alias nord jp              ← Change alias

set handlerPath to "/YOUR/PATH/nord-connect-handler.applescript"  ← Update path
do shell script "osascript " & quoted form of handlerPath & " 'Japan'"  ← Change country
```

3. The script will appear in Raycast automatically

### Optimizing for Your Countries

The handler has optimized row lookups for Hong Kong, Japan, and Taiwan. For other countries, it falls back to a full scan (slower).

To add optimized lookup for your country:

1. Connect to the country manually in NordVPN
2. Run the debug commands to find the row numbers (see [Finding Row Numbers](#finding-row-numbers))
3. Add the row numbers to `nord-connect-handler.applescript`:

```applescript
else if firstChar is "S" then
    -- Singapore: Recents=?, Countries=118 or 122
    set checkRows to {4, 118, 119, 120, 121, 122, 123}
```

### Finding Row Numbers

Use Accessibility Inspector or run this in Script Editor to find row numbers:

```applescript
tell application "NordVPN" to activate
delay 1

tell application "System Events"
    tell process "NordVPN"
        set win to window 1
        set mainGroup to group 1 of win
        set contentArea to UI element 3 of mainGroup
        set serverListGroup to UI element 3 of contentArea
        set scrollArea to UI element 2 of serverListGroup
        set serverTable to UI element 1 of scrollArea

        repeat with i from 1 to (count of rows of serverTable)
            set cellDesc to description of UI element 1 of row i of serverTable
            if cellDesc contains "YOUR_COUNTRY" then
                log "Found at row " & i & ": " & cellDesc
            end if
        end repeat
    end tell
end tell
```

**Note:** Row numbers shift by ~4 depending on whether "Recent connections" has loaded. Check both states and include all possible row numbers in `checkRows`.

## Requirements

- Accessibility permissions for Raycast (System Preferences → Privacy & Security → Accessibility)

## License

MIT
