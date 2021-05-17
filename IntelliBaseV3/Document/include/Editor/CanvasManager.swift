//
//  CanvasManager.swift
//  IntelliBaseV3
//
//  Created by てぃん on 2021/01/29.
//

import SwiftUI

class CanvasManager: ObservableObject {
    @Published var canvases: [DrawingWrapper] = []
    
    var drawingManager: DrawingManager
    @Published var currentPageIndex: [Int]
    
    init(drawingManager: DrawingManager, pageNum: Int = 1, readOnly: Bool = false){
        self.drawingManager = drawingManager
        self.currentPageIndex = [pageNum - 1]
        for index in 0..<drawingManager.docs.count {
            canvases.append(DrawingWrapper(manager: drawingManager, id: drawingManager.docs[index].id, readOnly: readOnly))
        }
    }
    
    func goToPreviousCanvas() {
        if currentPageIndex[0] > 0 {
            currentPageIndex[0] -= 1
        }
//        print("Debug : canvas page -> \(currentPageIndex)")
    }
    
    func goToNextCanvas() {
        if currentPageIndex[0] < drawingManager.docs.count - 1 {
            currentPageIndex[0] += 1
        }
//        print("Debug : canvas page -> \(currentPageIndex)")
    }
}
