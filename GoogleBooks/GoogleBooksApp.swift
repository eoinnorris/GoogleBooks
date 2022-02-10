//
//  GoogleBooksApp.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import SwiftUI

@main
struct GoogleBooksApp: App {
    
    let emptyResult = BookResults(empty: true)
    let emptyDownloadedFile = DownloadedFile(localURL: nil, type: .PDF)

    var body: some Scene {
        // main window
        WindowGroup {
            BookResultView(results: emptyResult)
        }
        
        // this is needed to open the second window
        WindowGroup("Viewer") { // other scene
            PDFViewer(file:emptyDownloadedFile)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity, alignment: .center)
         }.handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
       
}
