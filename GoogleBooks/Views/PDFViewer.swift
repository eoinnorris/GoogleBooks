//
//  PDFViewer.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import SwiftUI


struct Viewer: View {
    
    @State var file:DownloadedFile
    @State private var isDownloading = false
    
    func startDownload() {
        Network.shared.downLoadFile(forURL: file.serverURL) { result in
            isDownloading = false
            switch(result) {
                case .success(let newfile):
                    file = newfile
                case .failure(let error):
                    print("error in downloads \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            if isDownloading == true {
                ProgressView("Downloading…")
            }
            Button("Open in Preview") {
                NSWorkspace.shared.open(file.localURL!)
            }.padding()
            
            if  file.localURL != nil {
                PDFViewUI(url: file.localURL).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.onAppear {
            isDownloading = true
            startDownload()
        }
    }
}
