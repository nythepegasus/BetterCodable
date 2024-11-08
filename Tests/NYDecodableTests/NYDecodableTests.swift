import Testing
import Foundation
@testable import NYDecodable


let validJSON = """
{
    "name": "John Doe",
    "age": 30
}
""".data(using: .utf8)

let invalidJSON = """
{
    "name": "John Doe"
    // missing age
}
""".data(using: .utf8)

public struct TestModel: Sendable, NYDecodable, Equatable {
    @MainActor static var tested: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name, age
    }
    
    let name: String
    let age: Int
}



@Suite("Decodable JSON Parsing")
struct DecodableExtensionsTests {
    // MARK: - Tests for Initializers without errorHandler

    @MainActor
    @Test("Init with valid JSON")
    func initWithValidJSON() throws {
        #expect(try TestModel(json: validJSON) == TestModel(name: "John Doe", age: 30))
    }

    @MainActor
    @Test("Init with invalid JSON")
    func initWithInvalidJSON() throws {
        #expect(throws: DecodingError.self) { try TestModel(json: invalidJSON) }
    }

    // MARK: - Tests for Initializers with Void errorHandler

    @MainActor
    @Test("Init with error handler void and valid JSON")
    func initWithErrorHandlerVoidValidJSON() throws {
        let model = TestModel(validJSON) {
            #expect(Bool(false), "Error handler should not be called with valid JSON")
            TestModel.tested = true
        }
        #expect(model == TestModel(name: "John Doe", age: 30))
        #expect(!TestModel.tested)
        TestModel.tested = false
    }

    @MainActor
    @Test("Init with error handler void and invalid JSON")
    func initWithErrorHandlerVoidInvalidJSON() throws {
        let model = TestModel(invalidJSON) {
            TestModel.tested = true
        }
        #expect(nil == model)
        #expect(TestModel.tested)
        TestModel.tested = false
    }

    // MARK: - Tests for Initializers with (Error) -> Void errorHandler

    @MainActor
    @Test("Init with error handler error and valid JSON")
    func initWithErrorHandlerErrorValidJSON() throws {
        let model = TestModel(validJSON) {
            #expect(Bool(false), "Error handler should not be called with valid JSON")
        }
        #expect(model == TestModel(name: "John Doe", age: 30))
        #expect(!TestModel.tested)
        TestModel.tested = false
    }

    @MainActor
    @Test("Init with error handler error and invalid JSON")
    func initWithErrorHandlerErrorInvalidJSON() throws {
        let model = TestModel(invalidJSON) { error in
            TestModel.tested = true
            #expect(error != nil)
        }
        #expect(nil == model)
        #expect(TestModel.tested)
        TestModel.tested = false
    }

    // MARK: - Tests for Optional Initializers

    @MainActor
    @Test("Optional init with valid JSON")
    func optionalInitWithValidJSON() throws {
        let model = TestModel(validJSON) {
            #expect(Bool(false), "Error handler should not be called with valid JSON")
        }
        #expect(model == TestModel(name: "John Doe", age: 30))
        TestModel.tested = false
    }

    @MainActor
    @Test("Optional init with invalid JSON")
    func optionalInitWithInvalidJSON() throws {
        let model = TestModel(invalidJSON) {
            TestModel.tested = true
        }
        #expect(nil == model)
        #expect(TestModel.tested)
        TestModel.tested = false
    }

    @MainActor
    @Test("Optional init with error handler error and valid JSON")
    func optionalInitWithErrorHandlerErrorValidJSON() throws {
        let model = TestModel(validJSON) { error in
            #expect(Bool(false), "Error handler should not be called with valid JSON")
            TestModel.tested = true
        }
        #expect(model == TestModel(name: "John Doe", age: 30))
        #expect(!TestModel.tested)
        TestModel.tested = false
    }

    @MainActor
    @Test("Optional init with error handler error and invalid JSON")
    func optionalInitWithErrorHandlerErrorInvalidJSON() throws {
        let model = TestModel(invalidJSON) { error in
            TestModel.tested = true
            #expect(error != nil)
        }
        #expect(nil == model)
        #expect(TestModel.tested)
        TestModel.tested = false
    }
}

@testable import NYDecodableErrorLoggers

// We cannot conform to all 3 at once (unsure why you would anyway..), so to test we must comment each like below

//extension TestModel: NYErrorHandler {
//extension TestModel: NYEmptyErrorHandler {
extension TestModel: NYErrorLogger {
    static public func handleError(_ result: Result<Data?, any Error>, _ logged: Data?) {
        switch result {
            case .success: return
            case .failure(let error):
                print("Received \(error.localizedDescription) on \(logged?.description ?? "nil")")
        }
    }

    @MainActor
    static public func handleError(_ error: any Error) {
        print(error.localizedDescription)
    }

    @MainActor
    static public func handleError() {
        print("Error occurred!")
    }
}

@Suite("NYDecodableErrorLoggerTests")
struct NYDecodableErrorsTests {
    @MainActor
    @Test("Init with invalid JSON")
    func testErrorLogger() throws {
        let t = TestModel(invalidJSON)
        #expect(nil == t)
    }
}
