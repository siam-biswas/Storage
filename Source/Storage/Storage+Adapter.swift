//
// Storage+Adapter.swift
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

public protocol StorageAdaptable{
    
    associatedtype S:Storable
    
    subscript<T:Storagable>(dynamicMember keyPath: KeyPath<S, Bucket<T>>) -> T.T where T: OptionalType, T.T == T { get set }
    subscript<T:Storagable>(dynamicMember keyPath: KeyPath<S, Bucket<T>>) -> T.T where T.T == T { get set }
    subscript<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>) -> T.T where T: OptionalType, T.T == T { get set }
    subscript<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>) -> T.T where T.T == T { get set }
    
    func getValue<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>) -> T.T where T: OptionalType, T.T == T
    func getValue<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>) -> T.T where T.T == T
    func setValue<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>,newValue:T.T) where T.T == T
    
    func has<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>) -> Bool
    func remove<T:Storagable>(keyPath: KeyPath<S, Bucket<T>>)
}


@dynamicMemberLookup
public struct StorageAdapter<StoreType: Storable> : StorageAdaptable {
    
    public let debug = StorageDebug()
    public let store: StoreType

    public init(store: StoreType) {
        self.store = store
    }
    
    @available(*, unavailable)
    public subscript(dynamicMember member: String) -> Never {
        fatalError()
    }

    public subscript<T:Storagable>(dynamicMember keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T: OptionalType, T.T == T {
        get {
            getValue(keyPath: keyPath)
        }
        set {
            setValue(keyPath: keyPath,newValue: newValue)
        }
    }
    
    public subscript<T:Storagable>(dynamicMember keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T.T == T {
        get {
            getValue(keyPath: keyPath)
        }
        set {
            setValue(keyPath: keyPath,newValue: newValue)
        }
    }
    
    public subscript<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T: OptionalType, T.T == T {
        get {
            getValue(keyPath: keyPath)
        }
        set {
            setValue(keyPath: keyPath,newValue: newValue)
        }
    }
    
    public subscript<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T.T == T {
        get {
            getValue(keyPath: keyPath)
        }
        set {
            setValue(keyPath: keyPath,newValue: newValue)
        }
    }

    
    public func getValue<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T: OptionalType, T.T == T{
        if let value = store[keyPath: keyPath]._value, let _value = value as? T.T.Wrapped {
            return _value as! T
        } else {
            return T.T.empty
        }
    }
    
    public func getValue<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) -> T.T where T.T == T{
        if let value = store[keyPath: keyPath]._value{
            return value
        } else {
            fatalError("This was not suppose to happen, Report an Issue")
        }
    }
    
    public func setValue<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>,newValue:T.T) where T.T == T{
        var newKey = store[keyPath: keyPath]
        newKey._value = newValue
    }
    
    public func has<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) -> Bool{
        store[keyPath: keyPath].has()
    }
    
    public func remove<T:Storagable>(keyPath: KeyPath<StoreType, Bucket<T>>) {
        store[keyPath: keyPath].remove()
    }
}
