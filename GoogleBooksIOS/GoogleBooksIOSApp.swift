//
//  GoogleBooksIOSApp.swift
//  GoogleBooksIOS
//
//  Created by Eoin Norris on 08/02/2022.
//

import SwiftUI

@main
struct GoogleBooksIOSApp: App {
    let googleApi = GoogleApi()
    let emptyResult = BookResults(empty: true)
    
    var body: some Scene {
        WindowGroup {
            BookResultView(results: emptyResult)
        }
    }
}
