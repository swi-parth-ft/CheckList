//
//  Category.swift
//  CheckList
//
//  Created by Parth Antala on 2022-09-27.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
