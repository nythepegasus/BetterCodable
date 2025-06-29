
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

#if BCFileHelper

public extension JSONDecodable {
    init(jsonPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { throw BCFileError.missing }
        self = try Self.init(json: data)
    }
}

public extension JSONEncodable {
    func write(json path: URL) -> Bool {
        guard let data = try? json else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

public extension PlistDecodable {
    init(plistPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path) else { throw BCFileError.missing }
        self = try Self.init(plist: data)
    }
}

public extension PlistEncodable {
    func write(plist path: URL) -> Bool {
        guard let data = try? plist else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

enum BCFileError: Error {
    case missing
}

#endif

