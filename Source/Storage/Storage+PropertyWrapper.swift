//
// Storage+PropertyWrapper.swift
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


#if swift(>=5.1)
@propertyWrapper public struct StorageWrapper<T:Storagable> where T.T == T{
    
    
    public var bucket: Bucket<T>
    public var container: StorageContainable = StorageContainer.default
    
    public var wrappedValue:T.T{
        get{
            return bucket._value.unsafelyUnwrapped
        }
        set{
            bucket._value = newValue
        }
    }
    
    public init(bucket: Bucket<T>) {
        self.bucket = bucket
    }
    
    public init(keyPath: KeyPath<Store, Bucket<T>>) {
        self.bucket = Storage.store[keyPath: keyPath]
    }
    
    public init<S>(keyPath: KeyPath<S, Bucket<T>>, adapter: StorageAdapter<S>) {
        self.bucket = adapter.store[keyPath: keyPath]
    }
    
}
#endif
