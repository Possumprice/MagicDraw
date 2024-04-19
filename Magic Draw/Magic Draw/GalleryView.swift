//
//  GalleryView.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/5/24.
//

import Foundation
import UIKit
import PencilKit
import SwiftUI

struct GalleryView: View {
    //@ObservedObject var drawings: DrawingList
    var drawings1: FetchedResults<Drawing1>
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(drawings1) {
                    Drawing in
                    NavigationLink(destination: DisplayView(drawing: Drawing, drawings: drawings1)) {
                        Text(Drawing.title!)
                        //will need to convert data back to image
                        Image(uiImage:UIImage(data: Drawing.image!)!).aspectRatio(contentMode:.fit)
                        Text(Self.dateFormatter.string(from:Drawing.date!))
                    }
                }.onDelete(perform: { indexSet in
                    //fill in
                })
            }
        }
    }
}

//use PKDrawing.init(from: Drawing.drawing as! Decoder) to get drawing
