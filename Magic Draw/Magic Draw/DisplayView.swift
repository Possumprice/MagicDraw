//
//  DisplayView.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/5/24.
//

import Foundation
import UIKit
import PencilKit
import SwiftUI

struct DisplayView: View {
    //maybe observed
    var drawing:Drawing1
    //@ObservedObject var drawings: DrawingList
    var drawings: FetchedResults<Drawing1>
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    //add edit button with nav link back to content view that loads up the drawing, back button as well
    var body: some View {
        NavigationView {
            ZStack {
                Text("").navigationBarItems(leading:
                                                NavigationLink(destination: GalleryView(drawings1: drawings)) {
                    Image(systemName: "arrowshape.backward")
                }, trailing: NavigationLink(destination: ContentView(drawing: drawing)) {
                    Image(systemName: "pencil.tip")
                }
                )
                Text(drawing.title!)
                Spacer()
                Image(uiImage: UIImage(data: drawing.image!)!).aspectRatio(contentMode: .fit)
                Spacer()
                Text(Self.dateFormatter.string(from: drawing.date!))
            }
        }
    }
}

/*
struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}
 */


