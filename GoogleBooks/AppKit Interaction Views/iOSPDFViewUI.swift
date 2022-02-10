//
//  iOSPDFViewUI.swift
//  GoogleBooksIOS
//
//  Created by Eoin Norris on 09/02/2022.
//

import PDFKit
import SwiftUI


/// A  wrapper around the PDFKit PDFView to alliw it work in SwiftUI in iOS
struct PDFViewUI : UIViewRepresentable {

    var url: URL?
    
    init(url : URL?) {
        self.url = url
    }

    func makeUIView(context: Context) -> UIView {
        let pdfView = PDFView()

        if let url = url {
            pdfView.document = PDFDocument(url: url)
        }

        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }

}
