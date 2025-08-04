
import Foundation


// MARK: Codable Data JSON extensions

public protocol JSONDecodable: Decodable {
    static var jsonDecoder: JSONDecoder { get }
}

public extension JSONDecodable {
    init(json data: Data) throws { self = try Self.jsonDecoder.decode(Self.self, from: data) }
}

public extension Array where Element: JSONDecodable {
    init(json data: Data) throws { self = try Element.jsonDecoder.decode(Self.self, from: data) }
}

public protocol JSONEncodable: Encodable {
    static var jsonEncoder: JSONEncoder { get }
}

public extension JSONEncodable {
    var json: Data { get throws { try Self.jsonEncoder.encode(self) } }
}

public extension Array where Element: JSONEncodable {
    var json: Data { get throws { try Element.jsonEncoder.encode(self) } }
}

public protocol JSONCodable: Codable, JSONEncodable & JSONDecodable {}

// MARK: Codable Data plist extensions

public protocol PlistDecodable: Decodable {
    static var plistDecoder: PropertyListDecoder { get }
}

public extension PlistDecodable {
    init(plist data: Data) throws { self = try Self.plistDecoder.decode(Self.self, from: data) }
}

public extension Array where Element: PlistDecodable {
    init(plist data: Data) throws { self = try Element.plistDecoder.decode(Self.self, from: data) }
}

public protocol PlistEncodable: Encodable {
    static var plistEncoder: PropertyListEncoder { get }
}

public extension PlistEncodable {
    var plist: Data { get throws { try Self.plistEncoder.encode(self) } }
}

public extension Array where Element: PlistEncodable {
    var plist: Data { get throws { try Element.plistEncoder.encode(self) } }
}

public protocol PlistCodable: Codable, PlistEncodable & PlistDecodable {}

#if BCFileHelper

public extension JSONDecodable {
    init?(jsonPath path: URL) {
        guard let data = FileManager.default.contents(atPath: path.path),
              let s = try? Self.init(json: data) else { return nil }
        self = s
    }
}

public extension Array where Element: JSONDecodable {
    init?(jsonPath path: URL) {
        guard let data = FileManager.default.contents(atPath: path.path),
              let s = try? Self.init(json: data) else { return nil }
        self = s
    }
}

public extension JSONEncodable {
    @discardableResult
    func write(json path: URL) -> Bool {
        guard let data = try? json else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

public extension Array where Element: JSONEncodable {
    @discardableResult
    func write(json path: URL) -> Bool {
        guard let data = try? json else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

public extension PlistDecodable {
    init?(plistPath path: URL) throws {
        guard let data = FileManager.default.contents(atPath: path.path),
              let s = try? Self.init(plist: data) else { return nil }
        self = s
    }
}

public extension Array where Element: PlistDecodable {
    init?(jsonPath path: URL) {
        guard let data = FileManager.default.contents(atPath: path.path),
              let s = try? Self.init(plist: data) else { return nil }
        self = s
    }
}

public extension PlistEncodable {
    @discardableResult
    func write(plist path: URL) -> Bool {
        guard let data = try? plist else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

public extension Array where Element: PlistEncodable {
    @discardableResult
    func write(json path: URL) -> Bool {
        guard let data = try? plist else { return false }
        do {
            try data.write(to: path)
            return true
        } catch { return false }
    }
}

#endif

