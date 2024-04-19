//
//  CanvasView.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/1/24.
//

import SwiftUI
import PencilKit

struct CanvasView {
    @Binding var canvas: PKCanvasView
    let onSaved: () -> Void
    @State var tools = PKToolPicker()
}

private extension CanvasView {
    func showToolPicker() {
        
        //tie tool picker's visibility to whether the canvas view is active
        tools.setVisible(true, forFirstResponder: canvas)
        
        //ensure canvas view is notified of any changes to the tool picked
        tools.addObserver(canvas)
        
        //ask canvas view to become first responder, making toolpicker visible
        canvas.becomeFirstResponder()
    }
}

extension CanvasView: UIViewRepresentable {
    func updateUIView(_ uiView: PKCanvasView, context: Context){
    
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pen, color:.black, width: 8)
        #if targetEnvironment(simulator)
        canvas.drawingPolicy = .anyInput
        #endif
        canvas.delegate = context.coordinator
        showToolPicker()
        return canvas
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $canvas, save: onSaved)
    }
}

//communicates between UI view and canvas view
class Coordinator: NSObject {
    var canvas:Binding<PKCanvasView>
    let onSaved: () -> Void
    
    init(canvas: Binding<PKCanvasView>, save: @escaping () -> Void) {
        self.canvas = canvas
        self.onSaved = save
    }
}

extension Coordinator: PKCanvasViewDelegate {
    //called whenever the contents of the canvas view change
    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        if !canvas.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
