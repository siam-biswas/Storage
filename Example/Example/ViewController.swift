//
//  ViewController.swift
//  Example
//
//  Created by Md. Siam Biswas on 10/5/20.
//  Copyright © 2020 siambiswas. All rights reserved.
//

import UIKit
import Storage


class ViewController: UIViewController {
    
    @StorageWrapper(keyPath: \.username) var username:String?
    @StorageWrapper(keyPath: \.phones) var phones:[String]?
    @StorageWrapper(keyPath: \.age) var age:Int?
    @StorageWrapper(keyPath: \.isValid) var isValid:Bool?
    @StorageWrapper(keyPath: \.fullName) var fullName:Name?
    @StorageWrapper(keyPath: \.otherNames) var otherNames:[Name]?
    
    @StorageWrapper(bucket: Bucket(key: "email", expire: Date(), container: UserDefaults.standard, value: "jhon.doe@icloud.com")) var email:String
    @StorageWrapper(keyPath: \.address, adapter: Storage) var address:String?
    
    lazy var label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
               
        view.addSubview(label)
        label.frame = view.frame
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Storage"
        
        StorageDebug.set(true)
        executeStore()
        label.text = StorageDebug.report
    }
    

    func executeStore(){
        
        Storage[\.username] = "siam.biswas"
        Storage[\.phones] = ["01716587132","8787"]

        self.age = 28
        self.isValid = true
        
        Storage.fullName  = Name(firstName: "Siam", lastName: "Biswas")
        Storage.otherNames  = [Name(firstName: "Siam", lastName: "Biswas"),Name(firstName: "Jhon", lastName: "Doe")]
        
        let _ = Bucket<[NameType]>(key:"name_type",value: [.family,.formar])
    }

}




