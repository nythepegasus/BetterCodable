
import Foundation


// MARK: Codable Data JSON extensions

public protocol JSONDecodable: Decodable {
    static var jsonDecoder: JSONDecoder { get }
}

public extension JSONDecodable {
    init(json data: Data) throws { self = try Self.jsonDecoder.decode(Self.self, from: data) }
}

public protocol JSONEncodable: Encodable {
    static var jsonEncoder: JSONEncoder { get }
}

public extension JSONEncodable {
    var json: Data { get throws { try Self.jsonEncoder.encode(self) } }
}

public protocol JSONCodable: Codable, JSONEncodable & JSONDecodable {}

// MARK: Codable Data plist extensions

public protocol PlistDecodable: Decodable {
    static var plistDecoder: PropertyListDecoder { get }
}

public extension PlistDecodable {
    init(plist data: Data) throws { self = try Self.plistDecoder.decode(Self.self, from: data) }
}

public protocol PlistEncodable: Encodable {
    static var plistEncoder: PropertyListEncoder { get }
}

public extension PlistEncodable {
    var plist: Data { get throws { try Self.plistEncoder.encode(self) } }
}

public protocol PlistCodable: Codable, PlistEncodable & PlistDecodable {}

