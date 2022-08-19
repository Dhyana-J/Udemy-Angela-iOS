//
//  PostData.swift
//  H4XOR News
//
//  Created by Kaala on 2022/08/17.
//

import Foundation

struct Results:Decodable {
    let hits:[Post]
}

struct Post:Decodable, Identifiable {
    var id:String { objectID } // 한줄로 표현되면 return 생략 가능
    let objectID:String
    let points:Int
    let title:String
    let url:String?
}
 
