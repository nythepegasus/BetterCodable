# BetterDecodable
A "garbage" `Decodable` utility to make parsing JSON `String`s easier.

Example:
```swift

// OLD

struct User: Decodable {
  var name: String
  var age: UInt8
}

let data = "{'name': 'ny', 'age': 84}".data(using: .utf8)!

let u = JSONDecoder().decode(User.self, from: data)
```

```swift
// NEW

import BetterCodable

struct User: JSONDecodable {
  static let jsonDecoder = JSONDecoder()

  var name: String
  var age: UInt8
}

let data = "{'name': 'ny', 'age': 84}".data(using: .utf8)!

let u = try User(json: data)
```


This is just a basic example, and this package provides similar for the corresponding plist types.
