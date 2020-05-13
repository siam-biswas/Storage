//
// Storage+KeyChain.swift
// Storage
//
// Copyright (c) 2020 Siam Biswas.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import Security


extension Keychain:StorageContainable{

    
    public subscript<T>(value key: String) -> T? {
        get {
            return self[keyedArchiver: key]
        }
        set {
            self[keyedArchiver: key] = newValue
        }
    }
    
    public subscript<T:Collection>(values key: String) -> T?{
        get {
            return self[keyedArchiver: key]
        }
        set {
            self[keyedArchiver: key] = newValue
        }
    }
    
    public subscript<T>(object key: String) -> T? {
        get {
            return self[keyedArchiver: key]
        }
        set {
            self[keyedArchiver: key] = newValue
        }
    }
    
    public subscript<T:Collection>(objects key: String) -> T? {
        get {
            return self[keyedArchiver: key]
        }
        set {
            self[keyedArchiver: key] = newValue
        }
    }
    
    public subscript<T:Codable>(codable key: String) -> T? {
        get {
            guard let data = try? getData(for: key) else { return nil }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
            return value
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            guard let data = try? JSONEncoder().encode(value) else { return }
            guard let _ = try? setData(data, for: key) else { return }
        }
    }
    
    public subscript<T>(keyedArchiver key: String) -> T? {
        get {
            guard let data = try? getData(for: key) else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            guard let _ = try? setData(data, for: key) else { return }
        }
    }
    
    
    public func has(key: String) -> Bool {
        guard let _ = try? getData(for: key) else { return false }
        return true
    }
    
    public func remove(key: String) {
        guard let _ = try? removeValue(for: key) else { return }
    }
    
    
}

public class Keychain {
    
    open class var `default`: Keychain { return Keychain(service: "storage") }
    
    let keychainQueryable: KeychainQueryable
    
    public init(service: String, accessGroup: String? = nil) {
        self.keychainQueryable = KeychainQueryable(service: service, accessGroup: accessGroup)
    }
    
    
    public func setData(_ value: Data?, for key: String) throws {
        guard let encodedValue = value else {
            throw KeychainError.dataConversionError
        }
        
        var query = keychainQueryable.query
        query[String(kSecAttrAccount)] = key
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedValue
            
            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedValue
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    
    public func getData(for key: String) throws -> Data? {
        var query = keychainQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = key
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let data = queriedItem[String(kSecValueData)] as? Data
                else {
                    throw KeychainError.dataConversionError
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }
    
    
    
    public func removeValue(for key: String) throws {
        var query = keychainQueryable.query
        query[String(kSecAttrAccount)] = key
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    public func removeAllValues() throws {
        let query = keychainQueryable.query
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> KeychainError {
        if #available(iOS 11.3, *) {
            let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
            return KeychainError.unhandledError(message: message)
        } else {
            return KeychainError.unhandledError(message: NSLocalizedString("Unhandled Error", comment: ""))
        }
        
    }
}




public struct KeychainQueryable {
    let service: String
    let accessGroup: String?
    
    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension KeychainQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif
        return query
    }
}


public enum KeychainError: Error {
    case dataConversionError
    case unhandledError(message: String)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConversionError:
            return NSLocalizedString("Data conversion error", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
