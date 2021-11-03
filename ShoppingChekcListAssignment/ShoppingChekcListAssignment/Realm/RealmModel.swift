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
    @Persisted var done = false
    @Persisted var special = false
    

    convenience init(item: String, currentDate: Date) {
        self.init()
        self.shoppingItem = item
        self.createdDate = currentDate
    }
}

