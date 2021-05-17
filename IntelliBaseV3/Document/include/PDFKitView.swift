//
//  PDFKitView.swift
//  IntelliBaseV3
//
//  Created by てぃん on 2021/01/26.
//

import SwiftUI

struct PDFKitView: View {
    var url: URL
    var pdfKitRepresentedView: PDFKitRepresentedView
    
    init(url: URL) {
        self.url = url
        self.pdfKitRepresentedView = PDFKitRepresentedView(url)
        
        return
    }

    var body: some View {
        pdfKitRepresentedView
    }
}
