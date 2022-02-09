//
//  PDFViewUI.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFViewUI : NSViewRepresentable {
 
    typealias NSViewType = PDFView
    
    var url: URL?
    init(url : URL?) {
        self.url = url
    }

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()

        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }

        return pdfView
    }

    func updateNSView(_ uiView: PDFView, context: Context) {
        // Empty
    }

}
