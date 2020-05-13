//
//  Storage+Extension.swift
//  Example
//
//  Created by Md. Siam Biswas on 10/5/20.
//  Copyright © 2020 siambiswas. All rights reserved.
//

import Foundation
import Storage

extension Store{
    
    var username:Bucket<String?> { .init(key: "username",expire: Date(), container: UserDefaults.standard, value: "Jhon Doe")}
    var phones:Bucket<[String]?> { .init(container: Keychain.default) }
    var age:Bucket<Int?> { .init(container: FileManager.default) }
    var isValid:Bucket<Bool?> { .init(container: Plist.default) }
    var fullName:Bucket<Name?> { .init() }
    var otherNames:Bucket<[Name]?> { .init() }
    var nameType:Bucket<[NameType]?> { .init() }
    var address:Bucket<String?> { .init() }

}


public var DataStorage = StorageAdapter<DataStore>(store: .init())

public struct DataStore:Storable{
    
    var username:Bucket<String?> { .init(key: "username",expire: Date(), container: UserDefaults.standard, value: "Jhon Doe")}
    var phones:Bucket<[String]?> { .init(container: Keychain.default) }
    var age:Bucket<Int?> { .init(container: FileManager.default) }
    var isValid:Bucket<Bool?> { .init(container: Plist.default) }
    var fullName:Bucket<Name?> { .init() }
    var otherNames:Bucket<[Name]?> { .init() }
    var nameType:Bucket<[NameType]?> { .init() }
    var address:Bucket<String?> { .init() }
}



