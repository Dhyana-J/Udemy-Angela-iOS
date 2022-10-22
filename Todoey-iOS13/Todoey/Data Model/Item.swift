//
//  Item.swift
//  Todoey
//
//  Created by Kaala on 2022/10/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
