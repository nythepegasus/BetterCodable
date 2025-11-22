import Testing
@testable import BetterCodable
@testable import BCFileHelper
@testable import BCURLSessionHelper

public enum BasicJSONDecoders: CaseIterable, BCJSONDecoderProvider {
    case base
    case json5

    public var jsonDecoder: JSONDecoder {
        let dec = JSONDecoder()
        switch self {
            case .base: return dec
            case .json5:
            dec.allowsJSON5 = true
        }
        return dec
    }
}

public enum BasicJSONEncoders: CaseIterable, BCJSONEncoderProvider {
    case base
    case pretty

    public var jsonEncoder: JSONEncoder {
        let enc = JSONEncoder()
        switch self {
            case .base: 
            return enc
            case .pretty:
            enc.outputFormatting = .prettyPrinted
        }
        return enc
    }
}

public enum BasicPlistEncoders: CaseIterable, BCPlistEncoderProvider {
    case bin
    case xml

    public var plistEncoder: PropertyListEncoder {
        let enc = PropertyListEncoder()
        switch self {
            case .bin:
            enc.outputFormat = .binary
            case .xml:
            enc.outputFormat = .xml
        }
        return enc
    }
}

// Example set up of setting your own default Encoders/Decoders for the types

extension BCDCodable {
    public typealias JSONDecoders = BasicJSONDecoders
    public typealias JSONEncoders = BasicJSONEncoders
    public typealias PlistEncoders = BasicPlistEncoders
}

/// Simple TestModel to test encoding/decoding test data
public struct TestModel: Codable, Equatable, Sendable {
    let name: String
    let points: Int

    static var single: Self { .init(name: "ny :3", points: 84) }
    static var multiple: [Self] { [.init(name: "ny :3", points: 84), .init(name: "Gracie", points: 16)] }
}

// Using the default Encoders/Decoders defined above
extension TestModel: BCDCodable {}

@Suite("BCJSONDecodable Parsing")
struct BCJSONDecodaleTests {
    @Test("BCJSONDecoderProvider valid JSON")
    func initUsingProviderWithValidJSON() throws {
        #expect(try TestModel(json: validJSON, using: .base) == .single)
    }

    @Test("BCJSONDecoderProvider valid JSON Array")
    func initUsingProviderWithValidJSONArray() throws {
        #expect(try [TestModel](json: validJSONArray, using: .base) == TestModel.multiple)
    }

    @Test("BCDefaultJSONDecoderProvider valid JSON Array")
    func initUsingDefaultWithValidJSONArray() throws {
        #expect(try [TestModel](json: validJSONArray) == TestModel.multiple)
    }

    @Test("BCJSONDecoderProvider valid JSON5")
    func initUsingProviderWithValidJSON5() throws {
        #expect(try TestModel(json: validJSON5, using: .json5) == .single)
    }

    @Test("BCJSONDecoderProvider valid JSON5 Array")
    func initUsingProviderWithValidJSON5Array() throws {
        #expect(try [TestModel](json: validJSON5Array, using: .json5) == TestModel.multiple)
    }

    @Test("BCDefaultJSONDecoder valid JSON")
    func initUsingDefaultWithValidJSON() throws {
        #expect(try TestModel(json: validJSON) == .single)
    }

    @Test("BCDefaultJSONDecoder valid JSON5")
    func initUsingDefaultWithValidJSON5() throws {
        #expect(throws: DecodingError.self) { try TestModel(json: validJSON5) }
    }

    @Test("BCJSONDecoderProvider invalid JSON")
    func initUsingProviderWithInvalidJSON() throws {
        #expect(throws: DecodingError.self) { try TestModel(json: invalidJSON, using: .base) }
    }

    @Test("BCDefaultJSONDecoder invalid JSON")
    func initUsingDefaultWithInvalidJSON() throws {
        #expect(throws: DecodingError.self) { try TestModel(json: invalidJSON) }
    }
}

@Suite("BCJSONEncodable Serializing")
struct BCJSONEncodaleTests {
    @Test("BCJSONEncodable returns Data")
    func BCJSONEncodableReturnsData() throws {
        BasicJSONEncoders.allCases.forEach { using in
            #expect(throws: Never.self) { 
                try TestModel.single.json(using)
            }
        }
    }

    @Test("BCJSONEncodable Array returns Data")
    func BCJSONEncodableArrayReturnsData() throws {
        BasicJSONEncoders.allCases.forEach { using in
            #expect(throws: Never.self) {
                try TestModel.multiple.json(using)
            }
        }
    }

    @Test("BCJSONEncodable Default returns Data")
    func BCJSONEncodableDefaultReturnsData() throws {
        #expect(throws: Never.self) { try TestModel.single.json }
    }

    @Test("BCJSONEncodable Array Default returns Data")
    func BCJSONEncodableArrayDefaultReturnsData() throws {
        #expect(throws: Never.self) { try TestModel.multiple.json }
    }
}

@Suite("BCPlistDecodable Parsing")
struct BCPlistDecodaleTests {
    @Test("BCPlistDecoderProvider valid Plist")
    func initUsingProviderWithValidPlist() throws {
        #expect(try TestModel(plist: validPlist, using: .base) == .single)
    }

    @Test("BCPlistDecoderProvider valid Plist Array")
    func initUsingProviderWithValidPlistArray() throws {
        #expect(try [TestModel](plist: validPlistArray, using: .base) == TestModel.multiple)
    }

    @Test("BCDefaultPlistDecoderProvider valid Plist Array")
    func initUsingDefaultWithValidPlistArray() throws {
        #expect(try [TestModel](plist: validPlistArray) == TestModel.multiple)
    }
    
    @Test("BCDefaultPlistDecoder valid Plist")
    func initUsingDefaultWithValidPlist() throws {
        #expect(try TestModel(plist: validPlist) == .single)
    }

    @Test("BCPlistDecoderProvider invalid Plist")
    func initUsingProviderWithInvalidPlist() throws {
        #expect(throws: DecodingError.self) { try TestModel(plist: invalidPlist, using: .base) }
    }

    @Test("BCDefaultPlistDecoder invalid Plist")
    func initUsingDefaultWithInvalidPlist() throws {
        #expect(throws: DecodingError.self) { try TestModel(plist: invalidPlist) }
    }
}

@Suite("BCPlistEncodable Serializing")
struct BCPlistEncodaleTests {
    @Test("BCPlistEncodable returns Data")
    func BCPlistEncodableReturnsData() throws {
        BasicPlistEncoders.allCases.forEach { using in
            #expect(throws: Never.self) { 
                try TestModel.single.plist(using)
            }
        }
    }

    @Test("BCPlistEncodable Array returns Data")
    func BCPlistEncodableArrayReturnsData() throws {
        BasicPlistEncoders.allCases.forEach { using in
            #expect(throws: Never.self) {
                try TestModel.multiple.plist(using)
            }
        }
    }

    @Test("BCPlistEncodable Default returns Data")
    func BCPlistEncodableDefaultReturnsData() throws {
        #expect(throws: Never.self) { try TestModel.single.plist }
    }

    @Test("BCPlistEncodable Array Default returns Data")
    func BCPlistEncodableArrayDefaultReturnsData() throws {
        #expect(throws: Never.self) { try TestModel.multiple.plist }
    }
}

// Simple helper for FileHelper tests
extension URL {
    func delete() { try? FileManager.default.removeItem(at: self) }
}

@Suite("JSON File Access", .serialized)
struct BCJSONFileTests {
    static let datapath = URL(fileURLWithPath: "test.json")

    @Suite("JSON Object")
    struct BCJSONFileObjectTests {
        @Test("Save JSON TestModel to file Provider")
        func saveJSONUsingProvider() throws {
            #expect(throws: Never.self) { try TestModel.single.write(json: datapath, using: .base) }
        }
        
        @Test("Read JSON TestModel from file Provider")
        func readJSONUsingProvider() throws {
            defer { datapath.delete() }
            #expect(try TestModel(json: datapath, using: .base) == .single)
        }
        
        @Test("Save JSON TestModel to file Default")
        func saveJSONUsingDefault() throws {
            #expect(throws: Never.self) { try TestModel.single.write(json: datapath) }
        }
        
        @Test("Read JSON TestModel from file Default")
        func readJSONUsingDefault() throws {
            defer { datapath.delete() }
            #expect(try TestModel(json: datapath) == .single)
        }
    }

    @Suite("JSON Array")
    struct BCJSONFileArrayTests {
        @Test("Save JSON [TestModel] to file Default")
        func saveJSONUsingDefault() throws {
            #expect(throws: Never.self) { try TestModel.multiple.write(json: datapath) }
        }

        @Test("Read JSON [TestModel] from file Default")
        func readJSONUsingDefault() throws {
            defer { datapath.delete() }
            #expect(try [TestModel](json: datapath) == TestModel.multiple)
        }
        
        @Test("Save JSON [TestModel] to file Provider")
        func saveJSONUsingProvider() throws {
            #expect(throws: Never.self) { try TestModel.multiple.write(json: datapath, using: .pretty) }
        }

        @Test("Read JSON [TestModel] from file Provider")
        func readJSONUsingProvider() throws {
            defer { datapath.delete() }
            #expect(try [TestModel](json: datapath, using: .base) == TestModel.multiple)
        }
    }
}

@Suite("plist File Access", .serialized)
struct BCPlistFileTests {
    static let datapath = URL(fileURLWithPath: "test.plist")

    @Suite("plist Object")
    struct BCJSONFileObjectTests {
        @Test("Save plist TestModel to file Provider")
        func savePlistUsingProvider() throws {
            #expect(throws: Never.self) { try TestModel.single.write(plist: datapath, using: .xml) }
        }

        @Test("Read plist TestModel from file Provider")
        func readPlistUsingProvider() throws {
            defer { datapath.delete() }
            #expect(try TestModel(plist: datapath, using: .base) == .single)
        }
        
        @Test("Save plist TestModel to file Default")
        func savePlistUsingDefault() throws {
            #expect(throws: Never.self) { try TestModel.single.write(plist: datapath) }
        }

        @Test("Read plist TestModel from file Default")
        func readPlistUsingDefault() throws {
            defer { datapath.delete() }
            #expect(try TestModel(plist: datapath) == .single)
        }
    }

    @Suite("Save plist Array")
    struct BCPlistFileArrayTests {
        @Test("Save plist [TestModel] to file Provider")
        func savePlistArrayUsingProvider() throws {
            #expect(throws: Never.self) { try TestModel.multiple.write(plist: datapath, using: .xml) }
        }

        @Test("Read plist [TestModel] from file Provider")
        func readPlistArrayUsingProvider() throws {
            defer { datapath.delete() }
            #expect(try [TestModel](plist: datapath, using: .base) == TestModel.multiple)
        }
        
        @Test("Save plist [TestModel] to file Default")
        func savePlistArrayUsingDefault() throws {
            #expect(throws: Never.self) { try TestModel.multiple.write(plist: datapath) }
        }

        @Test("Read plist [TestModel] from file Default")
        func readPlistArrayUsingDefault() throws {
            defer { datapath.delete() }
            #expect(try [TestModel](plist: datapath) == TestModel.multiple)
        }
    }
}

