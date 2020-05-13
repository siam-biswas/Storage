//
// Storage+UserDefaults.swift
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
import UIKit

extension UserDefaults:StorageContainable {
    
    
    public subscript<T>(value key: String) -> T? {
        get {
            
            if T.self == String.self{
                return string(forKey: key) as? T
            }else if T.self == Float.self{
                return float(forKey: key) as? T
            }else if T.self == Double.self{
                return double(forKey: key) as? T
            }else if T.self == Int.self{
                return integer(forKey: key) as? T
            }else if T.self == Bool.self{
                return bool(forKey: key) as? T
            }else if T.self == URL.self{
                return url(forKey: key) as? T
            }else if T.self == Data.self{
                return data(forKey: key) as? T
            }else if T.self == [String:Any].self{
                return dictionary(forKey: key) as? T
            }else if T.self == UIImage.self{
                return self[keyedArchiver: key]
            }else{
                return object(forKey: key) as? T
            }
            
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            
            if T.self == UIImage.self{
                self[keyedArchiver: key] = value
            }else{
                set(value, forKey: key)
            }
        }
    }
    
    public subscript<T:Collection>(values key: String) -> T?{
        get {
            return array(forKey: key) as? T
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            set(value, forKey: key)
        }
    }
    
    public subscript<T>(object key: String) -> T? {
         get {
              return self[value: key]
         }
         set {
              self[value: key] = newValue
         }
    }
    
    public subscript<T:Collection>(objects key: String) -> T? {
        get {
             return self[values: key]
        }
        set {
             self[values: key] = newValue
        }
    }
    
    public subscript<T:Codable>(codable key: String) -> T? {
        get {
            guard let data = data(forKey: key) else { return nil }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
            return value
        }
        set {
            guard let value = validate(key: key, value: newValue) else { return }
            let data = try? JSONEncoder().encode(value)
            set(data, forKey: key)
        }
    }
    
    
    public subscript<T>(keyedArchiver key: String) -> T? {
        get {
            guard let data = data(forKey: key) else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        set {
            guard let value = validate(key: key, value: newValue) else{ return }
            let data = NSKeyedArchiver.archivedData(withRootObject: value) as NSData?
            set(data, forKey: key)
        }
    }
    
    public func has(key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    public func remove(key: String) {
        removeObject(forKey: key)
    }
    
}
