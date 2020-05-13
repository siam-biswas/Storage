//
// Storage+Container.swift
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



public protocol StorageContainable {
    
    subscript<T>(value key: String) -> T? { get set }
    subscript<T:Collection>(values key: String) -> T? { get set }
    subscript<T>(object key: String) -> T? { get set }
    subscript<T:Collection>(objects key: String) -> T? { get set }
    subscript<T:Codable>(codable key: String) -> T? { get set }
    subscript<T>(keyedArchiver key: String) -> T? { get set }
    
    func has(key: String) -> Bool
    func remove(key:String)
    func validate<T>(key:String, value: T?) -> T?

}

extension StorageContainable{
    public func validate<T>(key:String, value: T?) -> T?{
        guard let value = value else{
            remove(key: key)
            return nil
        }
        return value
    }
}


public struct StorageContainer{
    public static var `default`: StorageContainable = UserDefaults.standard
}
