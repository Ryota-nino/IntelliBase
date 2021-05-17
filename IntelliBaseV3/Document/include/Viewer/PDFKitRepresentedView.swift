//
//  PDFKitRepresentedView.swift
//  IntelliBaseV3
//
//  Created by てぃん on 2021/01/26.
//

import UIKit
import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    let pdfView: PDFView = PDFView()

    init(_ url: URL) {
        self.url = url
        pdfView.document = PDFDocument(url: self.url)
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(url: self.url)
        
//        print("Debug : document URL -> \(url)")
        
//        pdfView.autoScales = true
        pdfView.minScaleFactor = pdfView.scaleFactor
        pdfView.maxScaleFactor = pdfView.scaleFactor
        pdfView.displayDirection = .horizontal
        pdfView.displayMode = .singlePage
        pdfView.usePageViewController(false)
        
        pdfView.backgroundColor = .clear
        
//        pdfView.displayMode = .singlePage
        
//        pdfView.goToNextPage(nil)
        
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
