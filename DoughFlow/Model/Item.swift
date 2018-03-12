//
//  Item.swift
//  DoughFlow
//
//  Created by admin on 3/12/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var price: String = ""
    
}
