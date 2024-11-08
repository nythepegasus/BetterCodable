
import Foundation


// MARK: Decodable Data json extensions

public protocol NYDecodable: Decodable {}

public extension NYDecodable {
    init(json: Data? = nil) throws { self = try JSONDecoder().decode(Self.self, from: json ?? Data()) }
}

public extension NYDecodable {
    init?(_ json: Data? = nil) { do { self = try JSONDecoder().decode(Self.self, from: json ?? Data()) } catch { return nil } }

    init?(_ json: Data?, errorHandler: @escaping () -> Void = {}) {
        do { self = try .init(json: json)
        } catch { errorHandler(); return nil }
    }
    
    init?(_ json: Data?, errorHandler: @escaping () throws -> Void = {}) throws {
        do { self = try .init(json: json)
        } catch { try errorHandler(); return nil }
    }

    init?(_ json: Data?, errorHandler: @escaping (Result<Data?, Error>) -> Void = { _ in }) {
        do { self = try .init(json: json)
        } catch { errorHandler(.failure(error)); return nil }
    }

    init?(_ json: Data?, errorHandler: @escaping (Result<Data?, Error>) throws -> Void = { _ in }) throws {
        do { self = try .init(json: json)
        } catch { try errorHandler(.failure(error)); return nil }
    }
}
