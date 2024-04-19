//
//  Drawing.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/1/24.
//

import Foundation
import UIKit
import PencilKit

struct Drawing: Identifiable {
    var id = UUID()
    let title: String
    let drawing: PKDrawing
    let image: UIImage
    let date: Date
}



enum DrawingType: String, CaseIterable {
    case base = ""
    case car = "Car"
    case house = "House"
    case dog = "Dog"
}
