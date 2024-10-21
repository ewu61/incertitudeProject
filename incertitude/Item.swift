//
//  Item.swift
//  incertitude
//
//  Created by Eric Wu on 10/20/24.
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
