//
//  RealmModel.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/11/02.
//

import Foundation
import RealmSwift

class ShoppingData: Object {
    @Persisted var shoppingItem: String = ""
    @Persisted var createdDate = Date()
    var a = "ADfasdfasdf"
    convenience init(item: String, currentDate: Date) {
        self.init()
        self.shoppingItem = item
        self.createdDate = currentDate
    }
}

