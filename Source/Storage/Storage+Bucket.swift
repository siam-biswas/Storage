//
// Storage+Bucket.swift
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


public struct Bucket<Type:Storagable>:Bucketable{
    
    public typealias T = Type
    
    public var key: String
    public var container: StorageContainable = StorageContainer.default
    
    
    public init(key: String = #function,expire:Date? = nil,container: StorageContainable = StorageContainer.default,value:T.T) {
        
        self.key = key
        self.container = container
        
        if let expire = expire{
           self._expire = expire
        }
        
        self._value = value
    }
    
}

public extension Bucket where Type: Storagable, Type: OptionalType, Type.Wrapped: Storagable {
    
    init(key: String = #function,expire:Date? = nil,container: StorageContainable = StorageContainer.default) {
        
           self.key = key
           self.container = container
           
           if let expire = expire{
              self._expire = expire
           }
           
    }

    init(key: String = #function,expire:Date? = nil,container: StorageContainable = StorageContainer.default, value:T.T) {
           
           self.key = key
           self.container = container
           
           if let expire = expire{
              self._expire = expire
           }
          
           self._value = value
           
    }
}


public protocol Bucketable:CustomStringConvertible{
    
    associatedtype T:Storagable
    typealias Bridge = T.T
    
    var key:String { get }
    var container: StorageContainable { get set }

}

extension Bucketable{
    
    public var description: String {
        guard let update = _update else { return "\(key) : NA @ NA" }
        guard let value = _value else { return "\(key) : NA @ \(update)" }
        return "\(key) : \(value) @ \(update)"
    }
}


extension Bucketable  {
    
    public var _value: Bridge? {
        get {
            validateExpiration()
            return T.Bridge.get(key: key, container: container)
        }
        set {
            T.Bridge.save(key: key, value: newValue, container: container)
            setUpdate(value: newValue)
            StorageDebug.addUnit(value: description)
        }
    }
    
}



extension Bucketable{
    
    var expireKey:String { return "\(self.key)-expire" }
    var updateKey:String { return "\(self.key)-update" }
    
    public var _update:Date?{
        get {
            
            return UserDefaults(suiteName: "com.storage")?[value: updateKey]
        }
        
        nonmutating set {
            UserDefaults(suiteName: "com.storage")?[value: updateKey] = newValue
        }
    }
    
    public var _expire:Date?{
        get {
            return UserDefaults(suiteName: "com.storage")?[value: expireKey]
        }
        
        nonmutating set {
            UserDefaults(suiteName: "com.storage")?[value: expireKey] = newValue
        }
    }
    
    func setUpdate(value:Bridge?){
        guard value != nil else{
            _update = nil
            _expire = nil
            return
        }
        _update = Date()
    }
    
    @discardableResult
    func validateExpiration() -> Bool{

        guard let expire = _expire else {
            return true
        }
        
        guard expire < Date() else{
            remove()
            return false
        }
        
        return true
    }
    
    func has() -> Bool{
       return container.has(key: key)
    }
    
    func remove(){
        _update = nil
        _expire = nil
        container.remove(key: key)
    }
}
