//
//  Category.swift
//  Doit
//
//  Created by jp on 2019-06-17.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
  @objc dynamic var name: String = ""
  let items = List<Item>()
}
