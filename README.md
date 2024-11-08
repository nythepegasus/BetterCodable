# NYDecodable
A "garbage" `Decodable` utility to make parsing JSON `String`s easier.

Example:
```swift

// OLD

struct User: Decodable {
  var name: String
  var age: UInt8
}

let data = "{'name': 'ny', 'age': 84}".data(using: .utf8)

let u = JSONDecoder().decode(User.self, data)
```

```swift
// NEW

import NYDecodable

struct User: NYDecodable {
  var name: String
  var age: UInt8
}

let data = "{'name': 'ny', 'age': 84}".data(using: .utf8)

let u = User(json: data)
```


This is just a basic example, and this package also provides some error handler protocols in `NYDecodableErrorLoggers`.
