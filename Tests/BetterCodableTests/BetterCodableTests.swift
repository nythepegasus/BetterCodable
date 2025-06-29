import Testing
import Foundation
@testable import BetterCodable

// Helpers

extension String {
    func Data(using: String.Encoding = .utf8) -> Data { data(using: using)! }
}

extension URL {
    func delete() throws { try FileManager.default.removeItem(at: self) }
}


let validJSON = "{\"name\":\"ny :3\",\"points\":84}".Data()
let invalidJSON = "{\"name\":\"ny :3\"// missing points}".Data()

let validPlist = """
<dict>
        <key>points</key>
        <integer>84</integer>
        <key>name</key>
        <string>ny :3</string>
</dict>
""".Data()

let invalidPlist = """
<plist version="1.1">
<dict>
        <key>points</key>
        <integer>84</integer>
        <key>name</key>
        <string>ny :3
</dict>
</plist>
""".Data()


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

@Suite("File access", .serialized)
struct FileCodableExtensionTests {
    let jsonpath = URL(fileURLWithPath: "test.json")
    let plistpath = URL(fileURLWithPath: "test.plist")

    @Test("JSON save")
    func saveJSON() throws {
        #expect(t.write(json: jsonpath))
    }

    @Test("JSON read")
    func readJSON() throws {
        let r = try? TestModel(jsonPath: jsonpath)
        try? jsonpath.delete()
        #expect(r != nil)
        #expect(r == t)
    }

    @Test("plist save")
    func savePlist() throws {
        #expect(t.write(plist: plistpath))
    }

    @Test("Plist read")
    func readPlist() throws {
        let r = try? TestModel(plistPath: plistpath)
        try? plistpath.delete()
        #expect(r != nil)
        #expect(r == t)
    }
}

