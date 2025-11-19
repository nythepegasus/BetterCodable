
@_exported import struct Foundation.Data
@_exported import class Foundation.JSONEncoder
@_exported import class Foundation.JSONDecoder
@_exported import class Foundation.PropertyListEncoder
@_exported import class Foundation.PropertyListDecoder

// Protocols stolen from Combine but match the current Foundation implementations
// (TopLevelEncoder/TopLevelDecoder are a bit too generic to be useful for this currently)

/// TopLevelDecoder from Combine stolen for BetterCodable purposes
/// Defines a common interface for Decodable types
public protocol BCDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

/// TopLevelEncoder from Combine stolen for BetterCodable purposes
/// Defines a common interface for Encodable types
public protocol BCEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

/// A protocol for defining JSONDecoder types
public protocol BCJSONDecoderProtocol: BCDecoder {}
/// A protocol for defining JSONEncoder types
public protocol BCJSONEncoderProtocol: BCEncoder {}

extension JSONDecoder: BCJSONDecoderProtocol {}
extension JSONEncoder: BCJSONEncoderProtocol {}

/// A protocol for defining JSONDecoder provider types
public protocol BCJSONDecoderProvider {
    /// The type of JSONDecoder this provider returns
    associatedtype BCJSONDecoder: BCJSONDecoderProtocol
    /// The selected BCJSONDecoder to be used for decoding
    var jsonDecoder: BCJSONDecoder { get }
}

public extension BCJSONDecoderProvider {
    /// Helper function to use a specific BCJSONDecoder directly to decode data
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try jsonDecoder.decode(type, from: data)
    }
}

public protocol BCJSONEncoderProvider {
    associatedtype BCJSONEncoder: BCJSONEncoderProtocol
    var jsonEncoder: BCJSONEncoder { get }
}

public extension BCJSONEncoderProvider {
    func encode<T: Encodable>(_ value: T) throws -> Data {
        try jsonEncoder.encode(value)
    }
}

/// Helper protocol for both BCJSONDecoderProvider and BCJSONEncoderProvider
public protocol BCJSONCoderProvider: BCJSONDecoderProvider & BCJSONEncoderProvider {}

public protocol BCJSONDecodable<JSONDecoders>: Decodable {
    associatedtype JSONDecoders: BCJSONDecoderProvider
}

public extension BCJSONDecodable {
    init(json data: Data, using: JSONDecoders) throws {
        self = try using.decode(Self.self, from: data)
    }
}

public extension Sequence where Self: Decodable, Element: BCJSONDecodable {
    init(json data: Data, using: Element.JSONDecoders) throws {
        self = try using.decode(Self.self, from: data)
    }
}

public protocol BCJSONEncodable<JSONEncoders>: Encodable {
    associatedtype JSONEncoders: BCJSONEncoderProvider
}

public extension BCJSONEncodable {
    func json(_ using: JSONEncoders) throws -> Data {
        try using.encode(self)
    }
}

public extension Sequence where Self: Encodable, Element: BCJSONEncodable {
    func json(_ using: Element.JSONEncoders) throws -> Data {
        try using.encode(self)
    }
}

public protocol BCJSONCodable: Codable, BCJSONEncodable & BCJSONDecodable {}

// Single de/encoder setup

public protocol BCDefaultJSONDecodable: Decodable {
    static var jsonDefaultDecoder: BCJSONDecoderProtocol { get }
}

public extension BCDefaultJSONDecodable {
    init(json data: Data) throws {
        self = try Self.jsonDefaultDecoder.decode(Self.self, from: data)
    }
}

public extension Sequence where Self: Decodable, Element: BCDefaultJSONDecodable {
    init(json data: Data) throws {
        self = try Element.jsonDefaultDecoder.decode(Self.self, from: data)
    }
}

public protocol BCDefaultJSONEncodable: Encodable {
    static var jsonDefaultEncoder: BCJSONEncoderProtocol { get }
}

public extension BCDefaultJSONEncodable {
    var json: Data {
        get throws {
            try Self.jsonDefaultEncoder.encode(self)
        }
    }
}

public extension Sequence where Self: Encodable, Element: BCDefaultJSONEncodable {
    var json: Data {
        get throws {
            try Element.jsonDefaultEncoder.encode(self)
        }
    }
}

public protocol BCDefaultJSONCodable: Codable, BCDefaultJSONEncodable & BCDefaultJSONDecodable {}

// MARK: plist de/encoders

///
public protocol BCPlistDecoderProtocol: BCDecoder {}
///
public protocol BCPlistEncoderProtocol: BCEncoder {}

extension PropertyListDecoder: BCPlistDecoderProtocol {}
extension PropertyListEncoder: BCPlistEncoderProtocol {}

///
public protocol BCPlistDecoderProvider {
    ///
    associatedtype BCPlistDecoder: BCPlistDecoderProtocol
    ///
    var plistDecoder: BCPlistDecoder { get }
}

public extension BCPlistDecoderProvider {
    ///
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try plistDecoder.decode(type, from: data)
    }
}

public protocol BCPlistEncoderProvider {
    associatedtype BCPlistEncoder: BCPlistEncoderProtocol
    var plistEncoder: BCPlistEncoder { get }
}

public extension BCPlistEncoderProvider {
    func encode<T: Encodable>(_ value: T) throws -> Data {
        try plistEncoder.encode(value)
    }
}

///
public protocol BCPlistCoderProvider: BCPlistDecoderProvider & BCPlistEncoderProvider {}

public protocol BCPlistDecodable<PlistDecoders>: Decodable {
    associatedtype PlistDecoders: BCPlistDecoderProvider
}

public extension BCPlistDecodable {
    init(plist data: Data, using: PlistDecoders) throws {
        self = try using.decode(Self.self, from: data)
    }
}

public extension Sequence where Self: Decodable, Element: BCPlistDecodable {
    init(plist data: Data, using: Element.PlistDecoders) throws {
        self = try using.decode(Self.self, from: data)
    }
}

public protocol BCPlistEncodable<PlistEncoders>: Encodable {
    associatedtype PlistEncoders: BCPlistEncoderProvider
}

public extension BCPlistEncodable {
    func plist(_ using: PlistEncoders) throws -> Data {
        try using.encode(self)
    }
}

public extension Sequence where Self: Encodable, Element: BCPlistEncodable {
    func plist(_ using: Element.PlistEncoders) throws -> Data {
        try using.encode(self)
    }
}

public protocol BCPlistCodable: Codable, BCPlistDecodable & BCPlistEncodable {}

public protocol BCCodable: Codable, BCJSONCodable & BCPlistCodable {}

// Single de/encoder setup

public protocol BCDefaultPlistDecodable: Decodable {
    static var plistDefaultDecoder: BCPlistDecoderProtocol { get }
}

public extension BCDefaultPlistDecodable {
    init(plist data: Data) throws {
        self = try Self.plistDefaultDecoder.decode(Self.self, from: data)
    }
}

public extension Sequence where Self: Decodable, Element: BCDefaultPlistDecodable {
    init(plist data: Data) throws {
        self = try Element.plistDefaultDecoder.decode(Self.self, from: data)
    }
}

public protocol BCDefaultPlistEncodable: Encodable {
    static var plistDefaultEncoder: BCPlistEncoderProtocol { get }
}

public extension BCDefaultPlistEncodable {
    var plist: Data {
        get throws {
            try Self.plistDefaultEncoder.encode(self)
        }
    }
}

public extension Sequence where Self: Encodable, Element: BCDefaultPlistEncodable {
    var plist: Data {
        get throws {
            try Element.plistDefaultEncoder.encode(self)
        }
    }
}

public protocol BCDefaultPlistCodable: Codable, BCDefaultPlistDecodable & BCDefaultPlistEncodable {}

public protocol BCDCodable: Codable, BCJSONCodable & BCPlistCodable, BCDefaultJSONCodable & BCDefaultPlistCodable {}

#if BCFileHelper

@_exported import struct Foundation.URL
@_exported import class Foundation.FileManager

public extension BCJSONDecodable {
    init(json path: URL, using: JSONDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCJSONDecodable {
    init(json path: URL, using: Element.JSONDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCJSONEncodable {
    func write(json path: URL, using: JSONEncoders) throws {
        try using.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCJSONEncodable {
    func write(json path: URL, using: Element.JSONEncoders) throws {
        try using.encode(self).write(to: path)
    }
}

public extension BCDefaultJSONDecodable {
    init(json path: URL) throws {
        self = try Self.jsonDefaultDecoder.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCDefaultJSONDecodable {
    init(json path: URL) throws {
        self = try Element.jsonDefaultDecoder.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCDefaultJSONEncodable {
    func write(json path: URL) throws {
        try Self.jsonDefaultEncoder.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCDefaultJSONEncodable {
    func write(json path: URL) throws {
        try Element.jsonDefaultEncoder.encode(self).write(to: path)
    }
}

public extension BCPlistDecodable {
    init(plist path: URL, using: PlistDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCPlistDecodable {
    init(plist path: URL, using: Element.PlistDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCPlistEncodable {
    func write(plist path: URL, using: PlistEncoders) throws {
        try using.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCPlistEncodable {
    func write(plist path: URL, using: Element.PlistEncoders) throws {
        try using.encode(self).write(to: path)
    }
}
    
public extension BCDefaultPlistDecodable {
    init(plist path: URL) throws {
        self = try Self.plistDefaultDecoder.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCDefaultPlistDecodable {
    init(plist path: URL) throws {
        self = try Element.plistDefaultDecoder.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCDefaultPlistEncodable {
    func write(plist path: URL) throws {
        try Self.plistDefaultEncoder.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCDefaultPlistEncodable {
    func write(plist path: URL) throws {
        try Element.plistDefaultEncoder.encode(self).write(to: path)
    }
}

#endif // BCFileHelper
