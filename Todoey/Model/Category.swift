//
//  Category.swift
//  Todoey
//
//  Created by Faiz Mohideen on 11/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
