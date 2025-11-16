
@_exported import struct Foundation.Data
@_exported import class Foundation.JSONDecoder
@_exported import class Foundation.JSONEncoder
@_exported import class Foundation.PropertyListDecoder
@_exported import class Foundation.PropertyListEncoder


// MARK: Codable Data JSON extensions

/// Protocol for adding helpers to Decodable for JSON data.
public protocol JSONDecodable: Decodable {
    /// The default JSONDecoder to use for this type.
    static var jsonDecoder: JSONDecoder { get }
}

public extension JSONDecodable {
    /// Helper init to use default JSONDecoder on passed json Data.
    init(json data: Data) throws { self = try Self.jsonDecoder.decode(Self.self, from: data) }
}

public extension Array where Element: JSONDecodable {
    /// Helper init to use default JSONDecoder of Array Element on passed json Data.
    init(json data: Data) throws { self = try Element.jsonDecoder.decode(Self.self, from: data) }
}

/// Helper Protocol to use multiple JSONDecoders in a type safe way.
public protocol JSONDecoders: CaseIterable {
    /// Chosen JSONDecoder
    /// Should be a computed property of an enum type
    var decoder: JSONDecoder { get }
}

/// Protocol for adding helpers to Decodable for JSON data using multiple JSONDecoders in a type safe way.
public protocol MultiJSONDecodable: Decodable {
    associatedtype Decoders: JSONDecoders
}

/// Protocol for adding helpers to Decodable for JSON data using multiple JSONDecoders with a default in a type safe way.
public protocol MultiDefaultJSONDecodable: MultiJSONDecodable & JSONDecodable {}

public extension MultiJSONDecodable {
    /// Helper init to use chosen JSONDecoder of this type's Decoders on passed json Data.
    init(json data: Data, using: Decoders) throws { self = try using.decoder.decode(Self.self, from: data) }
}

public extension Array where Element: MultiJSONDecodable {
    /// Helper init to use chosen JSONDecoder of Array Element type's Decoders on passed json Data.
    init(json data: Data, using: Element.Decoders) throws { self = try using.decoder.decode(Self.self, from: data) }   
}

/// Protocol for adding helpers to Encodable for JSON data.
public protocol JSONEncodable: Encodable {
    /// The default JSONEncoder to use for this type.
    static var jsonEncoder: JSONEncoder { get }
}

/// Protocol for adding helpers to Encodable for JSON data.
public extension JSONEncodable {
    /// The current object as Data returned by this type's default JSONEncoder.
    var json: Data { get throws { try Self.jsonEncoder.encode(self) } }
}

public extension Array where Element: JSONEncodable {
    /// The current object as Data returned by the Array Element type's default JSONEncoder.
    var json: Data { get throws { try Element.jsonEncoder.encode(self) } }
}

/// Helper Protocol to use multiple JSONEncoders in a type safe way.
public protocol JSONEncoders: CaseIterable {
    /// Chosen JSONEncoder
    /// Should be a computed property of an enum type
    var encoder: JSONEncoder { get }
}

/// Protocol for adding helpers to Encodable for JSON data using multiple JSONEncoders in a type safe way.
public protocol MultiJSONEncodable: Encodable {
    associatedtype Encoders: JSONEncoders
}

/// Protocol for adding helpers to Decodable for JSON data using multiple JSONDecoders with a default in a type safe way.
public protocol MultiDefaultJSONEncodable: MultiJSONEncodable & JSONEncodable {}

public extension MultiJSONEncodable {
    /// The current object as Data returned by this type's Encoders chosen JSONEncoder.
    func json(using: Encoders) throws -> Data { try using.encoder.encode(self) }
}

public extension Array where Element: MultiJSONEncodable {
    /// The current object as Data returned by the Array Element type's Encoders chosen JSONEncoder.
    func json(using: Element.Encoders) throws -> Data { try using.encoder.encode(self) }
}

/// Protocol for adding helpers to Codable for JSON data.
public protocol JSONCodable: Codable, JSONEncodable & JSONDecodable {}
public protocol MultiJSONCodable: MultiJSONEncodable & MultiJSONDecodable {}
public protocol MultiDefaultJSONCodable: MultiDefaultJSONEncodable & MultiDefaultJSONDecodable {}

// MARK: Codable Data plist extensions

/// Protocol for adding helpers to Decodable for plist data.
public protocol PlistDecodable: Decodable {
    /// The default PropertyListDecoder to use for this type.
    static var plistDecoder: PropertyListDecoder { get }
}

public extension PlistDecodable {
    /// Helper init to use default PropertyListDecoder on passed plist Data.
    init(plist data: Data) throws { self = try Self.plistDecoder.decode(Self.self, from: data) }
}

public extension Array where Element: PlistDecodable {
    /// Helper init to use Array Element type's default PropertyListDecoder on passed plist Data.
    init(plist data: Data) throws { self = try Element.plistDecoder.decode(Self.self, from: data) }
}

/// Helper Protocol to use multiple PropertyListDecoders in a type safe way.
public protocol PlistDecoders: CaseIterable {
    /// Chosen PropertyListDecoder
    /// Should be a computed property of an enum type
    var decoder: PropertyListDecoder { get }
}

/// Protocol for adding helpers to Decodable for plist data using multiple PropertyListDecoders in a type safe way.
public protocol MultiPlistDecodable: Decodable {
    associatedtype Decoders: PlistDecoders
}

/// Protocol for adding helpers to Decodable for plist data using multiple PropertyListDecoders with a default in a type safe way.
public protocol MultiDefaultPlistDecodable: MultiPlistDecodable & PlistDecodable {}

public extension MultiPlistDecodable {
    /// Helper init to use chosen PlistDecoder of Decoders on passed Plist Data.
    init(plist data: Data, using: Decoders) throws { self = try using.decoder.decode(Self.self, from: data) }
}

public extension Array where Element: MultiPlistDecodable {
    /// Helper init to use chosen PlistDecoder of Array Element Decoders on passed Plist Data.
    init(plist data: Data, using: Element.Decoders) throws { self = try using.decoder.decode(Self.self, from: data) }   
}

/// Protocol for adding helpers to Encodable for plist data.
public protocol PlistEncodable: Encodable {
    /// The default PropertyListEncoder to use for this type.
    static var plistEncoder: PropertyListEncoder { get }
}

public extension PlistEncodable {
    /// The current object as Data returned by this type's default PropertyListEncoder.
    var plist: Data { get throws { try Self.plistEncoder.encode(self) } }
}

public extension Array where Element: PlistEncodable {
    /// The current object as Data returned by the Array Element type's default PropertyListEncoder.
    var plist: Data { get throws { try Element.plistEncoder.encode(self) } }
}

/// Helper Protocol to use multiple PropertyListEncoders in a type safe way.
public protocol PlistEncoders: CaseIterable {
    /// Chosen PropertyListEncoder
    /// Should be a computed property of an enum type
    var encoder: PropertyListEncoder { get }
}

/// Protocol for adding helpers to Decodable for plist data using multiple PropertyListEncoders in a type safe way.
public protocol MultiPlistEncodable: Encodable {
    associatedtype Encoders: PlistEncoders
}

/// Protocol for adding helpers to Decodable for plist data using multiple PropertyListEncoders with a default in a type safe way.
public protocol MultiDefaultPlistEncodable: MultiPlistEncodable & PlistEncodable {}

public extension MultiPlistEncodable {
    /// Helper func to return the current object as Data returned by the type's Encoders chosen PropertyListEncoder.
    func json(using: Encoders) throws -> Data { try using.encoder.encode(self) }
}

public extension Array where Element: MultiPlistEncodable {
    /// Helper func to return the current object as Data returned by the Array Element type's Encoders chosen PropertyListEncoder.
    func json(using: Element.Encoders) throws -> Data { try using.encoder.encode(self) }
}

/// Protocol for adding helpers to Codable for plist data.
public protocol PlistCodable: Codable, PlistEncodable & PlistDecodable {}
public protocol MultiPlistCodable: MultiPlistEncodable & MultiPlistDecodable {}
public protocol MultiDefaultPlistCodable: MultiDefaultPlistEncodable & MultiDefaultPlistDecodable {}

// MARK: Codable protocols for JSON and plist Data

/// Protocol for adding helpers to Encodable for JSON and plist Data.
public protocol JPEncodable: JSONEncodable & PlistEncodable {}
public protocol MJPEncodable: MultiJSONEncodable & MultiPlistEncodable {}
public protocol MDJPEncodable: MultiDefaultJSONEncodable & MultiDefaultPlistEncodable {}
/// Protocol for adding helpers to Decodable for JSON and plist Data.
public protocol JPDecodable: JSONDecodable & PlistDecodable {}
public protocol MJPDecodable: MultiJSONDecodable & MultiPlistDecodable {}
public protocol MDJPDecodable: MultiDefaultJSONDecodable & MultiDefaultPlistDecodable {}
/// Protocol for adding helpers to Codable for JSON and plist Data.
public protocol JPCodable: JPEncodable & JPDecodable {}
public protocol MJPCodable: MJPEncodable & MJPDecodable {}
public protocol MDJPCodable: MDJPEncodable & MDJPDecodable {}

#if BCFileHelper

@_exported import struct Foundation.URL
@_exported import class Foundation.FileManager

public extension JSONDecodable {
    /// Read Data from URL json and attempt to decode using type's default JSONDecoder.
    init?(json path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data)
    }
}

public extension Array where Element: JSONDecodable {
    /// Read Data from URL json and attempt to decode using Array Element type's default JSONDecoder.
    init?(json path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data)
    }
}

public extension MultiJSONDecodable {
    /// Read Data from URL json and attempt to decode using type's Decoders chosen JSONDecoder.
    init?(json path: URL, using decoder: Decoders) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data, using: decoder)
    }
}

public extension Array where Element: MultiJSONDecodable {
    /// Read Data from URL json and attempt to decode using Array Element type's Decoders chosen JSONDecoder.
    init?(json path: URL, using decoder: Element.Decoders) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data, using: decoder)
    }
}


public extension JSONEncodable {
    /// Attempt to write type as encoded Data to URL json using the type's default JSONEncoder.
    func write(json path: URL) throws { try json.write(to: path) }
}

public extension Array where Element: JSONEncodable {
    /// Attempt to write type as encoded Data to URL json using the Array Element type's default JSONEncoder.
    func write(json path: URL) throws { try json.write(to: path) }
}

public extension MultiJSONEncodable {
    /// Attempt to write type as encoded Data to URL json using the type's Encoders chosen JSONEncoder.
    func write(json path: URL, using: Encoders) throws { try using.encoder.encode(self).write(to: path) }
}

public extension Array where Element: MultiJSONEncodable {
    /// Attempt to write type as encoded Data to URL json using the Array Element type's Encoders chosen JSONEncoder.
    func write(json path: URL, using: Element.Encoders) throws { try using.encoder.encode(self).write(to: path) }
}

public extension PlistDecodable {
    /// Read Data from URL plist and attempt to decode using type's default PropertyListDecoder.
    init?(plist path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data)
    }
}

public extension Array where Element: PlistDecodable {
    /// Read Data from URL plist and attempt to decode using Array Element type's default PropertyListDecoder.
    init?(plist path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data)
    }
}

public extension MultiPlistDecodable {
    /// Read Data from URL plist and attempt to decode using type's Decoders chosen JSONDecoder.
    init?(plist path: URL, using decoder: Decoders) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data, using: decoder)
    }
}

public extension Array where Element: MultiPlistDecodable {
    /// Read Data from URL plist and attempt to decode using Array Element type's Decoders chosen PropertyListDecoder.
    init?(plist path: URL, using decoder: Element.Decoders) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data, using: decoder)
    }
}

public extension PlistEncodable {
    /// Attempt to write type as encoded Data to URL plist using the type's default PropertyListEncoder.
    func write(plist path: URL) throws { try plist.write(to: path) }
}

public extension Array where Element: PlistEncodable {
    /// Attempt to write type as encoded Data to URL plist using the Array Element type's default PropertyListEncoder.
    func write(plist path: URL) throws { try plist.write(to: path) }
}

public extension MultiPlistEncodable {
    /// Attempt to write type as encoded Data to URL plist using the type's Encoders chosen PropertyListEncoder.
    func write(plist path: URL, using: Encoders) throws { try using.encoder.encode(self).write(to: path) }
}

public extension Array where Element: MultiPlistEncodable {
    /// Attempt to write type as encoded Data to URL plist using the Array Element type's Encoders chosen PropertyListEncoder.
    func write(plist path: URL, using: Element.Encoders) throws { try using.encoder.encode(self).write(to: path) }
}

#endif

