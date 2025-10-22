
@_exported import Foundation


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

/// Protocol for adding helpers to Codable for JSON data.
public protocol JSONCodable: Codable, JSONEncodable & JSONDecodable {}

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

/// Protocol for adding helpers to Encodable for plist data.
public protocol PlistEncodable: Encodable {
    /// The default PropertyListEncoder to use for this type.
    static var plistEncoder: PropertyListEncoder { get }
}

// MARK: Codable protocols for JSON and plist Data

/// Protocol for adding helpers to Encodable for JSON and plist Data.
public protocol JPEncodable: JSONEncodable & PlistEncodable {}
/// Protocol for adding helpers to Decodable for JSON and plist Data.
public protocol JPDecodable: JSONDecodable & PlistDecodable {}
/// Protocol for adding helpers to Codable for JSON and plist Data.
public protocol JPCodable: JPEncodable & JPDecodable {}

public extension PlistEncodable {
    /// The current object as Data returned by this type's default PropertyListEncoder.
    var plist: Data { get throws { try Self.plistEncoder.encode(self) } }
}

public extension Array where Element: PlistEncodable {
    /// The current object as Data returned by the Array Element type's default PropertyListEncoder.
    var plist: Data { get throws { try Element.plistEncoder.encode(self) } }
}

/// Protocol for adding helpers to Codable for plist data.
public protocol PlistCodable: Codable, PlistEncodable & PlistDecodable {}

#if BCFileHelper

public extension JSONDecodable {
    /// Read Data from URL jsonPath and attempt to decode using type's default JSONDecoder.
    init?(jsonPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data)
    }
}

public extension Array where Element: JSONDecodable {
    /// Read Data from URL jsonPath and attempt to decode using Array Element type's default JSONDecoder.
    init?(jsonPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(json: data)
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

public extension PlistDecodable {
    /// Read Data from URL plistPath and attempt to decode using type's default PropertyListDecoder.
    init?(plistPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data)
    }
}

public extension Array where Element: PlistDecodable {
    /// Read Data from URL plistPath and attempt to decode using Array Element type's default PropertyListDecoder.
    init?(plistPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { return nil }
        self = try Self.init(plist: data)
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

#endif

