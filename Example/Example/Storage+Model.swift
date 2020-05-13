//
//  Storage+Model.swift
//  Example
//
//  Created by Md. Siam Biswas on 10/5/20.
//  Copyright © 2020 siambiswas. All rights reserved.
//

import Foundation
import Storage

struct Name:Codable,Storagable{
    var firstName:String
    var lastName:String
}


enum NameType: String, Storagable {
    case formar
    case family
    case official
}
