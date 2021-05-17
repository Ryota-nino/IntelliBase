//
//  DrawingViewController.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2021/01/22.
//

///**
/**

DrawingDocApp
CREATED BY:  DEVTECHIE INTERACTIVE, INC. ON 10/10/20
COPYRIGHT (C) DEVTECHIE, DEVTECHIE INTERACTIVE, INC

*/

import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    var readOnly: Bool
    
    init(readOnly: Bool = false) {
        self.readOnly = readOnly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var canvas: PKCanvasView =  {
        let v = PKCanvasView()
        v.drawingPolicy = .anyInput
        v.minimumZoomScale = 1
        v.maximumZoomScale = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        // 背景透過
        v.backgroundColor = .clear
        v.isOpaque = false
        // disallow finger drawing.
        v.drawingPolicy = .pencilOnly
        return v
    }()
    
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    var drawingData = Data()
    
    var drawingChanged: (Data) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if readOnly {
            canvas.drawingGestureRecognizer.isEnabled = false
        } else {
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
        }
        canvas.delegate = self
        canvas.becomeFirstResponder()
        
        if let drawing = try? PKDrawing(data: drawingData) {
            canvas.drawing = drawing
        }
    }
}

// MARK:- PK Delegates
extension DrawingViewController: PKToolPickerObserver, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}

