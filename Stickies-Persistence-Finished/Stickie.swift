//
//  Stickie.swift
//  Stickies-Persistence-Finished
//
//  Created by Justin Wong on 4/3/25.
//

import Foundation
import SwiftData

@Model
class Stickie: Identifiable {
    var id = UUID()
    var text: String = ""
    var zIndex: Double = 0
    var positionWidth: Double = 0
    var positionHeight: Double = 0
    
    init(zIndex: Double) {
        self.zIndex = zIndex
    }
    
    func getPositionCGSize() -> CGSize {
        CGSize(width: positionWidth, height: positionHeight)
    }
}
