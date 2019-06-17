//
//  Item.swift
//  Doit
//
//  Created by jp on 2019-06-17.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
  
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
