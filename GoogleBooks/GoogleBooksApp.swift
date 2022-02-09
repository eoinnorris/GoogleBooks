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
    @StateObject var downloadedFile = DownloadedFile(localURL: nil, type: .PDF)

    var body: some Scene {
        WindowGroup {
            BookResultView(results: emptyResult).environmentObject(downloadedFile)
        }
        
        // this is needed to open the second window
        WindowGroup("Viewer") { // other scene
            Viewer(file: downloadedFile).environmentObject(downloadedFile)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 1000, maxHeight: .infinity, alignment: .center)
         }.handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
       
}
