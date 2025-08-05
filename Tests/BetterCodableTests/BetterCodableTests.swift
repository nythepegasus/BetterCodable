import Testing
import Foundation
@testable import BetterCodable

// MARK: Setup Helpers

extension URL {
    func delete() throws { try FileManager.default.removeItem(at: self) }
}

let invalidJSON = "{\"name\":\"ny :3\"// missing points}".data(using: .utf8)!
let validJSON = "{\"name\":\"ny :3\",\"points\":84}".data(using: .utf8)!
let validArrayJSON = "[{\"name\":\"ny :3\",\"points\":84},{\"name\":\"Gracie\",\"points\":16}]".data(using: .utf8)!

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

let validArrayPlist = """
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

public struct TestModel: Sendable, Equatable {
    let name: String
    let points: Int

    static var single: Self { .init(name: "ny :3", points: 84) }
    static var multiple: [Self] { [.init(name: "ny :3", points: 84), .init(name: "Gracie", points: 16)] }
}

extension TestModel: JSONCodable {
    public static let jsonEncoder = JSONEncoder()
    public static let jsonDecoder = JSONDecoder()
}

extension TestModel: PlistCodable {
    public static let plistEncoder = {
        let enc = PropertyListEncoder()
        enc.outputFormat = .xml
        return enc
    }()
    public static let plistDecoder = PropertyListDecoder()
}

// MARK: Tests

@Suite("Decodable Parsing")
struct DecodableExtensionTests {
    // JSON
    @Test("Init with valid JSON")
    func initWithValidJSON() throws { #expect(try TestModel(json: validJSON) == .single) }

    @Test("Init with valid JSON Array")
    func initWithValidJSONArray() throws { #expect(try [TestModel](json: validArrayJSON) == TestModel.multiple) }

    @Test("Init with invalid JSON")
    func initWithInvalidJSON() throws { #expect(throws: DecodingError.self) { try TestModel(json: invalidJSON) } }

    // plist

    @Test("Init with valid plist")
    func initWithValidPlist() throws { #expect(try TestModel(plist: validPlist) == .single) }

    @Test("Init with valid plist Array")
    func initWithValidPlistArray() throws { #expect(try [TestModel](plist: validArrayPlist) == TestModel.multiple) }

    @Test("Init with invalid plist")
    func initWithInvalidPlist() throws { #expect(throws: DecodingError.self) { try TestModel(plist: invalidPlist) } }
}

@Suite("Encodable Serializing")
struct EncodableExtensionTests {
    @Test("JSONEncodable type returns Data")
    func JSONEncodableReturnsData() throws { #expect(throws: Never.self) { try TestModel.single.json } }

    @Test("PlistEncodable type returns Data")
    func PlistEncodableReturnsData() { #expect(throws: Never.self) { try TestModel.single.plist } }

    @Test("JSONEncodable Array type returns Data")
    func JSONArrayEncodableReturnsData() throws { #expect(throws: Never.self) { try TestModel.multiple.json } }

    @Test("PlistEncodable Array type returns Data")
    func PlistArrayEncodableReturnsData() { #expect(throws: Never.self) { try TestModel.multiple.plist } }
}

@Suite("File Access", .serialized)
struct FileCodableExtensionTests {
    static let datapath = URL(fileURLWithPath: "test.dat")

    @Suite("File JSON Access")
    struct FileJSONCodableExtensionTests {
        @Test("JSON save")
        func saveJSON() throws { #expect(throws: Never.self) { try TestModel.single.write(json: datapath) } }

        @Test("JSON read")
        func readJSON() throws {
            let r = try? TestModel(jsonPath: datapath)
            try? datapath.delete()
            #expect(r != nil && r == .single)
        }
    }

    @Suite("File JSON Array Access")
    struct FileJSONArrayCodableExtensionTests {
        @Test("JSON Array save")
        func saveArrayJSON() throws { #expect(throws: Never.self) { try TestModel.multiple.write(json: datapath) } }

        @Test("JSON Array read")
        func readArrayJSON() throws {
            let r = try? [TestModel](jsonPath: datapath)
            try? datapath.delete()
            #expect(r != nil && r == TestModel.multiple)
        }
    }

    @Suite("File Plist Access")
    struct FilePlistCodableExtensionTests {
        @Test("plist save")
        func savePlist() throws { #expect(throws: Never.self) { try TestModel.single.write(plist: datapath) } }

        @Test("plist read")
        func readPlist() throws {
            let r = try? TestModel(plistPath: datapath)
            try? datapath.delete()
            #expect(r != nil && r == .single)
        }
    }

    @Suite("File Plist Array Access")
    struct FilePlistArrayCodableExtensionTests {
        @Test("plist Array save")
        func saveArrayPlist() throws { #expect(throws: Never.self) { try TestModel.multiple.write(plist: datapath) } }

        @Test("plist Array read")
        func readArrayPlist() throws {
            let r = try? [TestModel](plistPath: datapath)
            try? datapath.delete()
            #expect(r != nil && r == TestModel.multiple)
        }
    }
}
