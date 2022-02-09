//
//  ContentView.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookResultView: View {
    @State var results:BookResults
    
    var body: some View {
#if os(iOS)
        NavigationView {
            SearchableView(books: results)
        }
#else
        SearchableView(books: results)
#endif
    }
}



struct SearchableView: View {
    
    @State var books:BookResults
    @State private var searchText = ""
    @State private var isSearching = false
   
    /// Starts the search and updates the books state
    func startSearch() {
        books = BookResults(empty: true)
        GoogleApi.shared.getBooks(forSearch: searchText, page: 0) { result in
            isSearching = false
            switch(result) {
            case .success(let bookResults):
                books = bookResults
            case .failure(let error):
                print("error in book results \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            if isSearching {
                ProgressView("Searching").padding()
            } else if books.totalItems == 0 {
                VStack(alignment: .center) {
                    Text("No Results")
                        .fontWeight(.ultraLight)
                        .padding()
                }
            }
            BookList(books: books)
            BottomBar(books: $books)

        }.searchable(text: $searchText) {
            Text("Search Google Books for \(searchText)?")
        }.onSubmit(of: .search) {
            isSearching = true
            startSearch()
        }
        .navigationTitle("Search Google Books")
    }
}



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

struct BookList : View {
    
    @ObservedObject var books:BookResults
    @State private var isPresentingModal = false
    @Environment(\.openURL) var openURL

    var body: some View {
        List(books.items) { book in
            let imageUrlStr = book.getThumbnail()
            HStack{
            if imageUrlStr.isEmpty == false{
                if let url =  URL(string: imageUrlStr) {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 120, height: 170)
                        .cornerRadius(15).padding(3)
                }
            }
            else{
                Image("thumbnail").resizable().frame(width: 120, height: 170).cornerRadius(10)
            }
                
            VStack(alignment: .leading, spacing: 8) {
                Text(book.volumeInfo?.title ?? "").fontWeight(.heavy)
                Text(book.volumeInfo?.getAuthors() ?? "n/a")
                Text(book.volumeInfo?.volumeInfoDescription ?? "n/a")
                    .font(.caption)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                Button("Download") {
                    openURL(URL(string:"GoogleBooks://viewer")!)
                }.clipShape(Capsule())
            }
            }

        }
    }
}


struct BottomBar : View {
    
//    var books:BookResults
    @Binding var books:BookResults

    var body: some View {
        HStack {
        Text("Total result count is \(books.totalItems ?? 0)")
            .padding()
            Button("Next") {
                GoogleApi.shared.getNextPage { result in
                    switch(result) {
                    case .success(let bookResults):
                        books = bookResults
                    case .failure(let error):
                        print("error in book results \(error)")
                    }
                }
            }
        }
    }
}
            

