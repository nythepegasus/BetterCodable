//
//  NYDecodable.swift
//  BetterCodable
//
//  Created by ny on 10/27/24.
//


import Foundation

import NYDecodable

// MARK: Protocols/typealiases

public typealias ErrorLogger<LoggedType> = (Result<LoggedType?, Error>, LoggedType?) -> Void
public typealias ThrowingErrorLogger<LoggedType> = (Result<LoggedType?, Error>, LoggedType?) throws -> Void

public protocol HasErrorLogger<LoggedType>: Sendable {
    associatedtype LoggedType
    
    @inlinable
    @Sendable
    static func handleError(_ result: Result<LoggedType?, Error>, _ logged: LoggedType?)
}

public protocol HasThrowingErrorLogger<LoggedType>: Sendable {
    associatedtype LoggedType
    
    @inlinable
    @Sendable
    static func handleError(result: Result<LoggedType?, Error>, _ logged: LoggedType?) throws
}

public protocol NYErrorLogger: HasErrorLogger & HasThrowingErrorLogger {}

public extension NYErrorLogger {
    @inlinable
    @Sendable
    static func handleError(result: Result<LoggedType?, Error>, _ logged: LoggedType?) throws { try handleError(result: result, logged) }
}

public typealias ErrorHandler = (Error) -> Void
public typealias ThrowingErrorHandler = (Error) throws -> Void

public protocol HasErrorHandler {
    @inlinable
    @Sendable
    static func handleError(_ error: Error)
}

public protocol HasThrowingErrorHandler: Sendable {
    @Sendable
    @inlinable
    static func handleError(error: Error) throws
}

public protocol NYErrorHandler: HasErrorHandler & HasThrowingErrorHandler {}

public extension NYErrorHandler {
    @inlinable
    @Sendable
    static func handleError(error: any Error) throws { handleError(error) }
}

public typealias EmptyErrorHandler = () -> Void
public typealias ThrowingEmptyErrorHandler = () throws -> Void

public protocol HasEmptyErrorHandler {
    @Sendable
    static func handleError()
}

public protocol HasThrowingEmptyErrorHandler: Sendable {
    @Sendable
    static func HandleError() throws
}

public protocol NYEmptyErrorHandler: HasEmptyErrorHandler & HasThrowingEmptyErrorHandler {}

public extension NYEmptyErrorHandler {
    @Sendable
    static func HandleError() throws { handleError() }
}

// MARK: Decodable Data json extensions

public extension NYDecodable where Self: HasThrowingErrorLogger<Data> {
    init?(_ json: Data?, errorHandler: @escaping @Sendable ThrowingErrorLogger<Data> = Self.handleError(result:_:)) throws {
        do { self = try .init(json: json)
        } catch { try errorHandler(.failure(error), json); return nil }
    }
}

public extension NYDecodable where Self: HasErrorLogger<Data> {
    init?(_ json: Data?, errorHandler: @escaping @Sendable ErrorLogger<Data> = Self.handleError(_:_:)) {
        do { self = try .init(json: json)
        } catch { errorHandler(.failure(error), json); return nil }
    }
}

public extension NYDecodable where Self: HasErrorHandler {
    init?(_ json: Data?, errorHandler: @escaping ErrorHandler = Self.handleError(_:)) {
        do { self = try .init(json: json)
        } catch { errorHandler(error); return nil }
    }
}

public extension NYDecodable where Self: HasThrowingErrorHandler {
    init?(_ json: Data?, errorHandler: @escaping ThrowingErrorHandler = Self.handleError(error:)) throws {
        do { self = try .init(json: json)
        } catch { try errorHandler(error); return nil }
    }
}

public extension NYDecodable where Self: HasEmptyErrorHandler {
    init?(_ json: Data?, errorHandler: @escaping EmptyErrorHandler = Self.handleError) {
        do { self = try .init(json: json)
        } catch { errorHandler(); return nil }
    }
}

public extension NYDecodable where Self: HasThrowingEmptyErrorHandler {
    init?(_ json: Data?, errorHandler: @escaping ThrowingEmptyErrorHandler = Self.HandleError) throws {
        do { self = try .init(json: json)
        } catch { try errorHandler(); return nil }
    }
}
