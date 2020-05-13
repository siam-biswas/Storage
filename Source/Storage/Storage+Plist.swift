//
// Storage+Plist.swift
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


extension Plist:StorageContainable {
    
    
    public subscript<T>(value key: String) -> T? {
        get {
            return self.getValue(key: key)
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            self.setValue(value, key: key)
        }
    }
    
    public subscript<T:Collection>(values key: String) -> T?{
        get {
            return self[value: key]
        }
        set {
            self[value: key] = newValue
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
            guard let data =  getData(key: key) else { return nil }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
            return value
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            guard let data = try? JSONEncoder().encode(value) else { return }
            setData(data, key: key)
        }
    }
    
    public subscript<T>(keyedArchiver key: String) -> T? {
        get {
            guard let data =  getData(key: key) else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            setData(data, key: key)
        }
    }
    
    public func has(key: String) -> Bool {
        return keyAlreadyExists(key: key)
    }
    
    public func remove(key: String) {
        self.removeKeyValuePair(for: key)
    }

    
}




public class Plist {
    
    public enum PlistType{
        case existing(name:String)
        case new(name:String)
        
        var name:String{
            switch self {
            case let .existing(name): return name
            case let .new(name): return name
            }
        }
        
        var path:String?{
            switch self {
            case let .existing(name):
                return Bundle.main.path(forResource: name, ofType: "plist")
            case let .new(name):
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                return documentDirectory.appending("/\(name).plist")
            }
        }
    }
    
    open class var `default`: Plist { return Plist(.new(name: "storage")) }
    
    let _type:PlistType
    var name:String { return _type.name }

    
    var destPath:String?
    
    public init(_ type:PlistType) {
        
        _type = type
        
        
        guard let path =  _type.path else {
            fatalError("Plist not found")
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            let data = [String:String]()
            let someData = NSDictionary(dictionary: data)
            someData.write(toFile: path, atomically: true)
        }
        
        destPath = path

    }
    
    func getValuesInPlistFile() -> NSDictionary? {
    
        guard let destPath = destPath, FileManager.default.fileExists(atPath: destPath) else{ return nil }
        return NSDictionary(contentsOfFile: destPath)

    }
    
    func getMutablePlistFile() -> NSMutableDictionary? {
        
        guard let destPath = destPath,FileManager.default.fileExists(atPath: destPath) else{ return nil }
        return NSMutableDictionary(contentsOfFile: destPath)
        
    }
    
    func addValuesToPlistFile(dictionary:NSDictionary) {
       
        guard let destPath = destPath,FileManager.default.fileExists(atPath: destPath) else { return }
        dictionary.write(toFile: destPath, atomically: false)
    }
    
    
    
    
    public func removeKeyValuePair(for key: String) {
        
        guard keyAlreadyExists(key: key) else { return }
        guard let dict = getMutablePlistFile(),dict.allKeys.contains(where: { $0 as? String == key}) else { return }
        dict.removeObject(forKey: key)
        addValuesToPlistFile(dictionary: dict)
    }
    
    public func removeAllKeyValuePairs() {
        
        
        guard let dict = getMutablePlistFile() else { return }
        dict.removeAllObjects()
        addValuesToPlistFile(dictionary: dict)
    }
    
    
    public func setValue<T>(_ value: T, key: String) {
        

        guard let dict = getMutablePlistFile() else { return }
        dict[key] = value
        addValuesToPlistFile(dictionary: dict)
       
    }
    
    public func getValue<T>(key: String) -> T? {
        
        guard let dict = getMutablePlistFile(),let value = dict[key] else { return nil }
        return value as? T
        
    }
    
    public func setData(_ value: Data, key: String) {
        

        guard let dict = getMutablePlistFile() else { return }
        dict[key] = value.base64EncodedString()
        addValuesToPlistFile(dictionary: dict)
        
    }
    
    public func getData(key: String) -> Data? {
        
        guard let dict = getMutablePlistFile(),let value = dict[key] as? String else { return nil }
        return Data(base64Encoded: value)
        
    }
    
    
    func keyAlreadyExists(key: String) -> Bool {
        
        guard let dict = getMutablePlistFile() else { return false }
        let keys = dict.allKeys
        return keys.contains { $0 as? String == key }
        
    }
    
    
}
