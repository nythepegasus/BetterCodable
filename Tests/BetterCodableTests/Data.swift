
// i've put this in a separated file since
// multiline Swift strings break syntax
// parsing in neovim :(

// Test data to parse

let invalidJSON = "{\"name\":\"ny :3\"// missing points}".data(using: .utf8)!
let validJSON = "{\"name\":\"ny :3\",\"points\":84}".data(using: .utf8)!
let validJSONArray = "[{\"name\":\"ny :3\",\"points\":84},{\"name\":\"Gracie\",\"points\":16}]".data(using: .utf8)!
let validJSON5 = """
{
    // woag comment !! 
    name: "ny :3", "points": 84,
}
""".data(using: .utf8)!
let validJSON5Array = """
[
    {name: "ny :3", "points": 84},
    // woag comment !!
    {"name": "Gracie", "points": 16},
]
""".data(using: .utf8)!

let invalidPlist = """
<plist version="1.1">
<dict>
    <key>points</key>
    <integer>84</integer>
    <key>name</key>
    <string>ny :3
</dict>
</plist>
""".data(using: .utf8)!

let validPlist = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>points</key>
    <integer>84</integer>
    <key>name</key>
    <string>ny :3</string>
</dict>
</plist>
""".data(using: .utf8)!

let validPlistArray = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
<dict>
    <key>name</key>
    <string>ny :3</string>
    <key>points</key>
    <integer>84</integer>
</dict>
<dict>
    <key>name</key>
    <string>Gracie</string>
    <key>points</key>
    <integer>16</integer>
</dict>
</array>
</plist>
""".data(using: .utf8)!

