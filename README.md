# Storage

![Platform](https://img.shields.io/badge/platforms-iOS%208.0-F28D00.svg)
![UserDefault](https://img.shields.io/badge/UserDeafult%20-F28D00.svg)
![Keychain](https://img.shields.io/badge/Keychain%20-F28D00.svg)
![FileManager](https://img.shields.io/badge/FileManager%20-F28D00.svg)
![Plist](https://img.shields.io/badge/Plist%20-F28D00.svg)


#### Elegant way to store data in Swift

##### Storage is a generic solution for data persistency in swift. As there are multiple ways to store data locally in iOS apps, Storage made it easier for you to use them with one single tool. Currently storage has support to work with `UserDefaults`, `Keychain`, `FileManager` & `Plist`.


# Version 1.0.2



## Usage

Lets start by creating some Buckets in Store

```swift
extension Store{
    
    var username:Bucket<String?> { .init() }
    var phones:Bucket<[String]?> { .init() }
    var age:Bucket<Int?> { .init() }
    var isValid:Bucket<Bool?> { .init() }
}
```

And just use it anywhere with `Subscript` , `KeyPath` & `DynamicMemberLookup`

```swift
Storage[\.username] = "jhon.doe"
let username = Storage[\.username]

Storage[\.phones] = ["01711223344","93456789"]

Storage.age = 28
Storage.isValid = true
```

## Bucket

Bucket is basically a generic data type holder. You can intialize a bucket with a key, a data container, expiration date & default value. If you are using optinal value then all this parameters are not mandatory. But if you want to have a non-optional value, then providing a default value is mandatory. If you just use `.init()` to initialize a bucket than the variable name will be used as a key to store the value.

```swift
extension Store{
    var username:Bucket<String?> { .init() }
    var phones:Bucket<[String]?> { .init(key: "phones") }
    var age:Bucket<Int?> { .init(key: "age", expire: Date()) }
    var isValid:Bucket<Bool?> { .init(key: "username", expire: Date(), container: UserDefaults.standard) }
    var email:Bucket<String> { .init(key: "email", expire: Date(), container: UserDefaults.standard, value: "jhon.doe@icloud.com") }
}
```


## Container

Container is a gateway between storage and different data storing protocols. Currently storage has container support for `UserDefault`,  `Keychain`, `FileManager` & `Plist`. By default Storage use `UserDefault` as container. You can set your preferred container while creating `Bucket`.

```swift
extension Store{
    var phone:Bucket<String?> { .init(container: UserDefaults.standard)}
    var email:Bucket<String?> { .init(container: UserDefaults(suiteName: "com.storage.example"))}
}
```

```swift
extension Store{
    var name:Bucket<String?> { .init(container: Keychain.default)}
    var phone:Bucket<String?> { .init(container: Keychain(service: "storage"))}
    var email:Bucket<String?> { .init(container: Keychain(service: "storage",accessGroup: "com.storage"))}
}
```

```swift
extension Store{
    var name:Bucket<String?> { .init(container: FileManager.default)}
}
```

```swift
extension Store{
    var name:Bucket<String?> { .init(container: Plist.default)}
    var phone:Bucket<String?> { .init(container: Plist(.existing(name: "Info")))}
    var email:Bucket<String?> { .init(container: Plist(.new(name: "Credentials")))}
    
}
```

You can also change the default container by set the value for `StorageContainer.default`

```swift
 StorageContainer.default = FileManager.default
```

## Store

Store is where you put all your `Buckets` from different `Containers`. Stoarge has a default store with name `Store`.  As mentioned before you can just use its extension for bucket storing purpose.

```swift
extension Store{
    var username:Bucket<String?> { .init() }
    var phone:Bucket<String?> { .init(container: Keychain.default)}
    var email:Bucket<String?> { .init(container: Plist.default)}
}
```

You can also create your custom `Store` by conform to `Storable` in your custom class or struct.

```swift
public struct DataStore:Storable{
    var username:Bucket<String?> { .init() }
    var phone:Bucket<String?> { .init(container: Keychain.default)}
    var email:Bucket<String?> { .init(container: Plist.default)}
}
```

Then define a custom global  `Adapter` variable with `StorageAdapter`.

```
public var DataStorage = StorageAdapter<DataStore>(store: .init())
```

And the usage is as before 

```swift
DataStorage[\.username] = "jhon.doe"
let username = DataStorage[\.username]

DataStorage[\.phones] = ["01711223344","93456789"]

DataStorage.email = "jhon.doe@icloud.com"
```

## Codable, NSCoding & RawRepresentable

Storage  support `Codable` ,`NSCoding` &  `RawRepresentable` with all the `Containers` ! Just conform to `Storagable` in your custom type or enum. It also works with array of your custom  types.

```swift
struct Name:Codable,Storagable{
    
    var firstName:String
    var lastName:String
    
}
```

```swift
struct Name:NSObject, NSCoding, Storagable{ ... }
```

```swift
enum NameType: String, Storagable {
    case former
    case family
    case official
}
```

## Supported types

Here's a full table of supported types with Storage:

| Single value     | Array                |
| ---------------- | -------------------- |
| `String`         | `[String]`           |
| `Int`            | `[Int]`              |
| `Double`         | `[Double]`           |
| `Float`         | `[Float]`           |
| `CGFloat`     | `[CGFloat]`       |
| `NSNumber`   | `[NSNumber]`     |
| `Bool`           | `[Bool]`             |
| `Data`           | `[Data]`             |
| `Date`           | `[Date]`             |
| `URL`             | `[URL]`               |
| `UIImage`    | `[UIImage]`       |
| `[String: Any]`  | `[[String: Any]]`    |
| `Codable`    | `[Codable]`     |
| `NSCoding`  | `[NSCoding]`   |
| `RawRepresentable`  | `[RawRepresentable]`     |


## Property Wrapper

You can use the property wrapper  `@StorageWrapper` to  attach storage behaviors and logic directly to your custom  properties.  `@StorageWrapper` can be used with a previously created buckets `KeyPath` and `Adapter` or you can initalize it with a new `Bucket `.


```swift
extension Store {
    var username: Bucket<String> { .init() }
}
```

```swift
class CustomClass {
    @StorageWrapper(keyPath: \.username)
    var username: String?
    
    @StorageWrapper(keyPath: \.address, adapter: Storage) 
    var address:String?

    @StorageWrapper(bucket: Bucket(key: "email", expire: Date(), container: UserDefaults.standard, value: "jhon.doe@icloud.com"))
    var email: String?
}
```



## Debug

We have added a debugger for your convenience to check the current `Storage` session. 

For enable the debugger 
```swift
StorageDebug.set(true)
```

Get the debug report
```swift
let report = StorageDebug.report
```


## Installation

### CocoaPods

You can use [CocoaPods](http://cocoapods.org/) to install `Storage` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'Storage', :git => 'https://github.com/siam-biswas/Storage.git'
end
```

### Manually

To use this library in your project manually you may:  

1. for Projects, just drag all the (.swift) files from (Source\Storage) to the project tree
2. for Workspaces, include the whole Storage.xcodeproj


## Reference & Inspiration

The design of the Storage architecture gets huge inspiration from `SwiftyUserDefaults`, and we invite the reader to take a look at its repo & documentation. Also check out this awesome articles and repos which were really helpfull while creating Storage.

- [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults)
- [Data Persistence](https://www.iosapptemplates.com/blog/ios-development/data-persistence-ios-swift)
- [Property Wrapper](https://www.swiftbysundell.com/articles/property-wrappers-in-swift/)
- [Key Paths](https://www.swiftbysundell.com/articles/the-power-of-key-paths-in-swift/)
- [Keychain Service](https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift)
- [SwiftyPlistManager](https://github.com/rebeloper/SwiftyPlistManager)




