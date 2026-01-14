//
//  Item.swift
//  whatshouldieat
//
//  Created by Lucas Nguyen on 14/1/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
