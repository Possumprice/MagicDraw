//
//  DrawingList.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/5/24.
//

import Foundation
import UIKit
import PencilKit

class DrawingList:ObservableObject {
    @Published var drawingList = [Drawing] ()
    init() {}
    
    func addNewDrawing(_ title:String, _ drawing:PKDrawing, _ image: UIImage) {
        let newDate = Date.now
        for (drawings) in drawingList {
            if drawings.title == title {
                let newDrawing = Drawing(title: title, drawing: drawing, image: image, date: newDate)
                drawingList.append(newDrawing)
            } else {
                //alert user that drawing could not be added due to duplicate title
            }
        }
        
    }
    
    func deleteDrawing(t:String) {
        var index = 0
        for (drawing) in drawingList {
            if drawing.title == t {
                drawingList.remove(at: index)
            }
            index = index + 1
        }
    }
    
    /*
    func updateTitle(d:Drawing, t:String) {
        d.title = t
    }
     */
    
    
    
}
