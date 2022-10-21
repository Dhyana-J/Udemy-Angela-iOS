//
//  Data.swift
//  Todoey
//
//  Created by Kaala on 2022/10/20.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // dynamic dispatch. realm DB가 변수의 변화를 감지하고 업데이트함. objc API에서 온거라 어노테이션 써줘야한다.
    @objc dynamic var name:String = ""
    @objc dynamic var age:Int = 0
}
