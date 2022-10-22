//
//  Category.swift
//  Todoey
//
//  Created by Kaala on 2022/10/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>() // List 자료형은 Realm에서옴
}
