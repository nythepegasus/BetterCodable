import Testing
import Foundation
@testable import BetterCodable


let validJSON = "{\"name\":\"ny :3\",\"points\":84}".data(using: .utf8)!
let invalidJSON = "{\"name\":\"ny :3\"// missing points}".data(using: .utf8)!

let validPlist = """
<dict>
        <key>points</key>
        <integer>84</integer>
        <key>name</key>
        <string>ny :3</string>
</dict>
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


public struct TestModel: JSONCodable, PlistCodable, Sendable, Equatable {
    // JSON
    public static let jsonEncoder = JSONEncoder()
    public static let jsonDecoder = JSONDecoder()

    // plist
    public static let plistEncoder = {
        var enc = PropertyListEncoder()
        enc.outputFormat = .xml
        return enc
    }()
    public static let plistDecoder = PropertyListDecoder()
    
    let name: String
    let points: Int
}

let t = TestModel(name: "ny :3", points: 84)

@Suite("Decodable JSON Parsing")
struct JSONDecodableExtensionTests {
    @Test("Init with valid JSON")
    func initWithValidJSON() throws {
        #expect(try TestModel(json: validJSON) == t)
    }

    @Test("Init with invalid JSON")
    func initWithInvalidJSON() throws {
        #expect(throws: DecodingError.self) { try TestModel(json: invalidJSON) }
    }
}

@Suite("Encodable JSON")
struct JSONEncodableExtensionTests {
    @Test("JSONEncodable type returns Data")
    func JSONEncodableReturnsData() throws {
        let j = try? t.json
        #expect(j != nil)
    }
}

@Suite("Decodable Plist Parsing")
struct PlistDecodableExtensionTests {
    @Test("Init with valid plist")
    func initWithValidJSON() throws {
        #expect(try TestModel(plist: validPlist) == t)
    }

    @Test("Init with invalid plist")
    func initWithInvalidJSON() throws {
        #expect(throws: DecodingError.self) { try TestModel(plist: invalidPlist) }
    }
}

@Suite("Encodable Plist")
struct PlistEncodableExtensionTests {
    @Test("PlistEncodable type returns Data")
    func PlistEncodableReturnsData() {
        let p = try? t.plist
        #expect(p != nil)
    }
}
