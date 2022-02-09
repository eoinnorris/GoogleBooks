//
//  DownloadFileModeal.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import Foundation


enum FileType {
    case PDF
    case other
}

class DownloadedFile:ObservableObject {
    // for the test just hardcoding this
    let serverURL = URL(string: "https://www.bloomsbury.com/media/hmqifwq2/harry-potter-and-the-philosopher-s-stone-discussion-guide.pdf")!
    @Published var localURL:URL?
    @Published var type:FileType
    
    init(localURL:URL?, type:FileType) {
        self.localURL = localURL
        self.type = type
    }
}
