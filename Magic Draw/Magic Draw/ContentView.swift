//
//  ContentView.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/1/24.
//

import SwiftUI
import PencilKit
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Drawing1.title, ascending: true)], animation: .default)
    var drawings1: FetchedResults<Drawing1>
    
    //when returning here to edit, set drawing to chosen one
    //@State var drawing: Drawing?
    @State var drawing: Drawing1
    
    @State private var canvas = PKCanvasView()
    @State private var isSpeaking = false
    @State private var drawingType: DrawingType = .base
    @State private var isSharing = false
    @State private var isAdding = false
    
    @State var addT:String = ""
    @ObservedObject var drawings: DrawingList = DrawingList()
    
    var body: some View {
        NavigationView {
            ZStack {
                CanvasView(canvas: $canvas, onSaved: saveDrawing).padding(10.0).background(Color.black).navigationBarTitle(Text("Magic Draw")
                    .font(.title)
                    .foregroundColor(Color.white)
                    , displayMode: .inline).navigationBarItems(
                    leading: HStack {
                        NavigationLink(destination: GalleryView(drawings1: drawings1)) {
                            Image(systemName: "square.stack.3d.up")
                        }
                        
                        Button {
                            isSpeaking = true
                        } label: {
                            Image(systemName: "mic")
                        }.popover(isPresented: $isSpeaking, arrowEdge: .top)
                        {
                            SpeakingView()
                        }
                        Picker("Drawing Type", selection: $drawingType) {
                            Text("Choose a drawing").tag(DrawingType.base)
                            Text("Car").tag(DrawingType.car)
                            Text("House").tag(DrawingType.house)
                            Text("Dog").tag(DrawingType.dog)
                        }.pickerStyle(.menu)
                    }, trailing: HStack {
                        Button(action: {
                            isAdding = true
                        }) {
                            Image(systemName: "plus.app")
                        }
                        Button(action: shareDrawing) {
                            Image(systemName: "square.and.arrow.up")
                        }.sheet(isPresented: $isSharing) {
                            ShareView(activityItems: [UIImage(data: drawing.image!) as Any], excludedActivityTypes: [])
                        }
                        Button(action: deleteDrawing) {
                            Image(systemName: "trash")
                        }
                        Button(action: undoDelete) {
                            Image(systemName: "arrow.uturn.left")
                        }
                    })
                
            }.alert("Save Drawing", isPresented: $isAdding, actions: {
                TextField("Title", text: $addT)
                Button("Add", action: {
                    addNewDrawing(t:addT)
                    isAdding = false
                })
                Button("Cancel", role: .cancel, action: {
                    isAdding = false
                })
            }, message: { Text("Enter title")})
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SpeakingView:View {
    
    
    var body: some View {
        Text("").foregroundColor(Color.black).toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Image("microphone")
                }
            }
        }
    }
    
}

private extension ContentView {
    
    /*
    func addDrawing(t:String) {
        let image = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        drawings.addNewDrawing(t, canvas.drawing, image)
    }
     */
    
    func addNewDrawing(t:String) {
        withAnimation {
            let image = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
            let imageData = image.pngData()
            let drawingData = canvas.drawing.dataRepresentation()
            
            let newDrawing = Drawing1(context: viewContext)
            newDrawing.title = t
            newDrawing.image = imageData
            newDrawing.drawing = drawingData
            newDrawing.date = Date.now
            
            do {
                try viewContext.save()
            } catch {
                //finish
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveDrawing() {
        //create image representation of the drawing
        let image = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        let imageData = image.pngData()
        let drawingData = canvas.drawing.dataRepresentation()
        //create drawing
        //will be a problem saving here, adds to list
        let drawing = Drawing1(context: viewContext)
        drawing.image = imageData
        drawing.drawing = drawingData
        drawing.date = .now
        
        //update state variable
        self.drawing = drawing
    }
    
    func deleteDrawing() {
        canvas.drawing = PKDrawing()
    }
    
    func undoDelete() {
        /*
        if let drawing = drawing {
            canvas.drawing = drawing.drawing
        }
         */
        do {
            try canvas.drawing = PKDrawing.init(from: drawing.drawing as! Decoder)
        } catch {
            
        }
        
    }
    
    func shareDrawing() {
        if drawing != nil {
            isSharing = true
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
