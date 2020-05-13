//
// Storage+FileManager.swift
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


extension FileManager:StorageContainable {
    
    
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
            guard let data = try? read(fileNamed: key) else { return nil }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
            return value
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            guard let data = try? JSONEncoder().encode(value) else { return }
            guard let _ = try? save(fileNamed: key, data: data) else { return }
        }
    }
    
    public subscript<T>(keyedArchiver key: String) -> T? {
        get {
            guard let data = try? read(fileNamed: key) else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            guard let _ = try? save(fileNamed: key, data: data) else { return }
        }
    }
    
    public func has(key: String) -> Bool {
        guard let url = makeURL(forFileNamed: key) else { return false }
        return self.fileExists(atPath: url.absoluteString)
    }
    
    public func remove(key:String){
        guard let url = makeURL(forFileNamed: key),self.fileExists(atPath: url.absoluteString) else { return }
        guard let _ = try? self.removeItem(at: url) else { return }
    }
    
}


extension FileManager{
    
    enum Error: Swift.Error {
        case fileNotExists
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case readingFailed
    }
    
    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        if self.fileExists(atPath: url.absoluteString) {
            throw Error.fileAlreadyExists
        }
        do {
            try data.write(to: url)
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard self.fileExists(atPath: url.absoluteString.replacingOccurrences(of: "file:///", with: "")) else {
            throw Error.fileNotExists
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName + ".file")
    }
    
    
}
