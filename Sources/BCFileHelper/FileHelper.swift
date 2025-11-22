@_exported import struct Foundation.URL
@_exported import class Foundation.FileManager

@_exported import BetterCodable

public extension BCMultiJSONDecodable {
    init(json path: URL, using: JSONDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCMultiJSONDecodable {
    init(json path: URL, using: Element.JSONDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCMultiJSONEncodable {
    func write(json path: URL, using: JSONEncoders) throws {
        try using.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCMultiJSONEncodable {
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

public extension BCMultiPlistDecodable {
    init(plist path: URL, using: PlistDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension Sequence where Self: Decodable, Element: BCMultiPlistDecodable {
    init(plist path: URL, using: Element.PlistDecoders) throws {
        self = try using.decode(Self.self, from: Data(contentsOf: path))
    }
}

public extension BCMultiPlistEncodable {
    func write(plist path: URL, using: PlistEncoders) throws {
        try using.encode(self).write(to: path)
    }
}

public extension Sequence where Self: Encodable, Element: BCMultiPlistEncodable {
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

