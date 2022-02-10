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

/// The class representing the downloaded file, the type,  its place on the local server and the hardcoded serverURL
struct DownloadedFile {
    // for the test just hardcoding this
    let serverURL = URL(string: "https://www.bloomsbury.com/media/hmqifwq2/harry-potter-and-the-philosopher-s-stone-discussion-guide.pdf")!
    var localURL:URL?
    var type:FileType
    
    init(localURL:URL?, type:FileType) {
        self.localURL = localURL
        self.type = type
    }
}
