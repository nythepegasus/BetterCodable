@_exported import struct Foundation.URL
@_exported import class Foundation.URLSession
@_exported import class Foundation.URLResponse
@_exported import struct Foundation.URLRequest

@_exported import BetterCodable

public extension URLSession {
    func json<T: BCMultiJSONDecodable>(from url: URL, using decoder: T.JSONDecoders) async throws -> (T, URLResponse) {
        let r = try await data(from: url)
        return (try T(json: r.0, using: decoder), r.1)
    }

    func upload<T: BCMultiJSONEncodable>(json data: T, with request: URLRequest, using: T.JSONEncoders) async throws -> (Data, URLResponse) {
        try await upload(for: request, from: data.json(using))
    }

    func upload<T: BCMultiJSONEncodable, R: BCMultiJSONDecodable>(with request: URLRequest, json data: T, using: T.JSONEncoders, decoder: R.JSONDecoders) async throws -> (R, URLResponse) {
        let r = try await upload(json: data, with: request, using: using)
        return (try R(json: r.0, using: decoder), r.1)
    }

    func upload<T: BCMultiJSONEncodable, R: BCMultiPlistDecodable>(with request: URLRequest, json data: T, using: T.JSONEncoders, decoder: R.PlistDecoders) async throws -> (R, URLResponse) {
        let r = try await upload(json: data, with: request, using: using)
        return (try R(plist: r.0, using: decoder), r.1)
    }

    func json<T: BCDefaultJSONDecodable>(from url: URL) async throws -> (T, URLResponse) {
        let r = try await data(from: url)
        return (try T(json: r.0), r.1)
    }

    func upload<T: BCDefaultJSONEncodable>(json data: T, with request: URLRequest) async throws -> (Data, URLResponse) {
        try await upload(for: request, from: data.json)
    }

    func upload<T: BCDefaultJSONEncodable, R: BCDefaultJSONDecodable>(json data: T, with request: URLRequest) async throws -> (R, URLResponse) {
        let r = try await upload(json: data, with: request)
        return (try R(json: r.0), r.1)
    }

    func upload<T: BCDefaultJSONEncodable, R: BCDefaultPlistDecodable>(json data: T, with request: URLRequest) async throws -> (R, URLResponse) {
        let r = try await upload(json: data, with: request)
        return (try R(plist: r.0), r.1)
    }

    func plist<T: BCMultiPlistDecodable>(from url: URL, using decoder: T.PlistDecoders) async throws -> (T, URLResponse) {
        let r = try await data(from: url)
        return (try T(plist: r.0, using: decoder), r.1)
    }

    func upload<T: BCMultiPlistEncodable>(plist data: T, with request: URLRequest, using encoder: T.PlistEncoders) async throws -> (Data, URLResponse) {
        try await upload(for: request, from: data.plist(encoder))
    }

    func upload<T: BCMultiPlistEncodable, R: BCMultiPlistDecodable>(plist data: T, with request: URLRequest, using encoder: T.PlistEncoders, decoder: R.PlistDecoders) async throws -> (R, URLResponse) {
        let r = try await upload(plist: data, with: request, using: encoder)
        return (try R(plist: r.0, using: decoder), r.1)
    }

    func upload<T: BCMultiPlistEncodable, R: BCMultiJSONDecodable>(plist data: T, with request: URLRequest, using encoder: T.PlistEncoders, decoder: R.JSONDecoders) async throws -> (R, URLResponse) {
        let r = try await upload(plist: data, with: request, using: encoder)
        return (try R(json: r.0, using: decoder), r.1)
    }

    func upload<T: BCMultiPlistEncodable, R: BCDefaultPlistDecodable>(plist data: T, with request: URLRequest, using encoder: T.PlistEncoders) async throws -> (R, URLResponse) {
        let r = try await upload(plist: data, with: request, using: encoder)
        return (try R(plist: r.0), r.1)
    }

    func upload<T: BCMultiPlistEncodable, R: BCDefaultJSONDecodable>(plist data: T, with request: URLRequest, using encoder: T.PlistEncoders) async throws -> (R, URLResponse) {
        let r = try await upload(plist: data, with: request, using: encoder)
        return (try R(json: r.0), r.1)
    }

    func upload<T: BCDefaultPlistEncodable>(plist data: T, with request: URLRequest) async throws -> (Data, URLResponse) {
        try await upload(for: request, from: data.plist)
    }

    func upload<T: BCDefaultPlistEncodable, R: BCDefaultPlistDecodable>(plist data: T, with request: URLRequest) async throws -> (R, URLResponse) {
        let r = try await upload(for: request, from: data.plist)
        return (try R(plist: r.0), r.1)
    }

    func upload<T: BCDefaultPlistEncodable, R: BCDefaultJSONDecodable>(plist data: T, with request: URLRequest) async throws -> (R, URLResponse) {
        let r = try await upload(for: request, from: data.plist)
        return (try R(json: r.0), r.1)
    }
}

