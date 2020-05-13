//
// Storage+Bridge.swift
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

public protocol Storagable {
    typealias T = Bridge.T
    associatedtype Bridge:StorageBridge
    associatedtype ArrayBridge:StorageBridge
    
    static var _bridge:Bridge { get }
    static var _arrayBridge:ArrayBridge { get }
}


public protocol StorageBridge {
    associatedtype T
    
    static func get(key: String, container: StorageContainable) -> T?
    static func save(key: String,value:T?, container: StorageContainable)
}



public struct StorageValueBridge<Type>:StorageBridge{
    public typealias T = Type
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[value: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[value: key] = value
    }
}

public struct StorageObjectBridge<Type>:StorageBridge{
    public typealias T = Type
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[object: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[object: key] = value
    }
}


public struct StorageCodableBridge<Type:Codable>:StorageBridge{
    public typealias T = Type
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[codable: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[codable: key] = value
    }
}

public struct StorageCollectionBridge<Type:Collection>:StorageBridge{
    public typealias T = Type
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[values: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
         var setter = container
         setter[values: key] = value
    }
}

public struct StorageObjectCollectionBridge<Type:Collection>:StorageBridge{
    public typealias T = Type
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[objects: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
         var setter = container
         setter[objects: key] = value
    }
}

public struct StorageKeyedArchiverBridge<T>: StorageBridge {
    
    public static func get(key: String, container: StorageContainable) -> T?{
        return container[keyedArchiver: key]
    }
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[keyedArchiver: key] = value
    }
}

public struct StorageRawRepresentableBridge<T: RawRepresentable>: StorageBridge {
    
    public static func get(key: String, container: StorageContainable) -> T?{
        guard let rawValue:T.RawValue = container[value: key] else { return nil }
        return T(rawValue: rawValue)
    }
    
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[value: key] = value?.rawValue
    }
}

public struct StorageRawRepresentableCollectionBridge<T: Collection>: StorageBridge where T.Element:RawRepresentable{
    
    public static func get(key: String, container: StorageContainable) -> T?{
   
        guard let rawValue:[T.Element.RawValue] = container[value: key] else { return nil }
        return rawValue.compactMap{T.Element(rawValue: $0)} as? T
    }
    
    public static func save(key: String,value:T?, container: StorageContainable){
        var setter = container
        setter[value: key] = value?.map{$0.rawValue}
    }
}

public struct StorageOptionalBridge<Bridge: StorageBridge>: StorageBridge {

    public typealias T = Bridge.T?


    public static func get(key: String, container: StorageContainable) -> T?{
        return Bridge.get(key: key, container: container)
    }
    
    public static func save(key: String,value:T?, container: StorageContainable){
        Bridge.save(key: key, value: value as? Bridge.T, container: container)
    }
}



extension String:Storagable{
    public static var _bridge: StorageValueBridge<String> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[String]> {
        return StorageCollectionBridge()
    }
}

extension Int:Storagable{
    public static var _bridge: StorageValueBridge<Int> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[Int]> {
        return StorageCollectionBridge()
    }
}

extension Float:Storagable{
    public static var _bridge: StorageValueBridge<Float> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[Float]> {
        return StorageCollectionBridge()
    }
}

extension CGFloat:Storagable{
    public static var _bridge: StorageValueBridge<CGFloat> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[CGFloat]> {
        return StorageCollectionBridge()
    }
}

extension Double:Storagable{
    public static var _bridge: StorageValueBridge<Double> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[Double]> {
        return StorageCollectionBridge()
    }
}

extension Bool:Storagable{
    public static var _bridge: StorageValueBridge<Bool> {
        return StorageValueBridge()
    }
    public static var _arrayBridge: StorageCollectionBridge<[Bool]> {
           return StorageCollectionBridge()
       }
}

extension NSNumber:Storagable{
    public static var _bridge: StorageObjectBridge<NSNumber> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[NSNumber]> {
        return StorageObjectCollectionBridge()
    }
}


extension URL:Storagable{
    public static var _bridge: StorageObjectBridge<URL> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[URL]> {
        return StorageObjectCollectionBridge()
    }
}

extension Date:Storagable{
    public static var _bridge: StorageObjectBridge<Date> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[Date]> {
        return StorageObjectCollectionBridge()
    }
}

extension Data:Storagable{
    public static var _bridge: StorageObjectBridge<Data> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[Data]> {
        return StorageObjectCollectionBridge()
    }
}

extension Dictionary:Storagable where Key == String{
    public typealias T = [Key: Value]
    public static var _bridge: StorageObjectBridge<T> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[T]> {
           return StorageObjectCollectionBridge()
    }
    
}

extension UIImage:Storagable{
    public static var _bridge: StorageObjectBridge<UIImage> {
        return StorageObjectBridge()
    }
    public static var _arrayBridge: StorageObjectCollectionBridge<[UIImage]> {
        return StorageObjectCollectionBridge()
    }
}


extension Array:Storagable where Element: Storagable {
    
    
    public typealias T = [Element.T]
    public typealias Bridge = Element.ArrayBridge
    public typealias ArrayBridge = StorageCollectionBridge<[T]>
    
    public static var _bridge: Bridge {
        return Element._arrayBridge
    }
    public static var _arrayBridge: StorageCollectionBridge<[T]> {
        fatalError("Multidimensional array not supported")
    }
}

extension Optional: Storagable where Wrapped: Storagable {
    public typealias Bridge = StorageOptionalBridge<Wrapped.Bridge>
    public typealias ArrayBridge = StorageOptionalBridge<Wrapped.ArrayBridge>

    public static var _bridge: StorageOptionalBridge<Wrapped.Bridge> { return StorageOptionalBridge() }
    public static var _arrayBridge: StorageOptionalBridge<Wrapped.ArrayBridge> { return StorageOptionalBridge() }
}

extension Storagable where Self:Codable{
    public static var _bridge: StorageCodableBridge<Self> {
        return StorageCodableBridge()
    }
    public static var _arrayBridge: StorageCodableBridge<[Self]> {
        return StorageCodableBridge()
    }
}

extension Storagable where Self: RawRepresentable {
    public static var _bridge: StorageRawRepresentableBridge<Self> {
        return StorageRawRepresentableBridge()
    }
    public static var _arrayBridge: StorageRawRepresentableCollectionBridge<[Self]> {
        return StorageRawRepresentableCollectionBridge()
    }
}

extension Storagable where Self: NSCoding {
    public static var _bridge: StorageKeyedArchiverBridge<Self> {
        return StorageKeyedArchiverBridge()
    }
    public static var _arrayBridge: StorageKeyedArchiverBridge<[Self]> {
        return StorageKeyedArchiverBridge()
    }
}

extension Storagable where Self:Collection{
    public static var _bridge: StorageCollectionBridge<Self> {
        return StorageCollectionBridge()
    }
}


