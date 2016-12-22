//
//  Element+JSON.swift
//  PeriodicTable
//
//  Created by Karen Fuentes on 12/21/16.
//  Copyright © 2016 Karen Fuentes. All rights reserved.
//

import Foundation

extension Element {
    func populate(from elementDict: [String:Any]) {
        
        guard let number = elementDict["number"] as? Int ,
            let weight = elementDict["weight"] as? Double,
            let name = elementDict["name"] as? String,
            let symbol = elementDict["symbol"] as? String,
            let group = elementDict["group"] as? Int else { return }
        
        self.group = Int32(group)
        self.name = name
        self.number = Int32(number)
        self.weight = Int32(weight)
        self.symbol = symbol
    }
}
