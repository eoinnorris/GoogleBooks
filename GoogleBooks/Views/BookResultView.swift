//
//  ContentView.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

// This file contains the BookResult swiftUi view and subviews private to it.

/// The main result page - works on iOS and macOS
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

extension SearchableView {
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
}

///  The searchable list view, composited from the BookResults, BookListView and BottomBar views
struct SearchableView: View {
    
    @State var books:BookResults
    @State private var searchText = ""
    @State private var isSearching = false
   
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
            BottomBar(books: $books,
                      isSearching: $isSearching,
                      page: GoogleApi.shared.page)
        }.searchable(text: $searchText) {
            Text("Search Google Books for \(searchText)?")
        }.onSubmit(of: .search) {
            isSearching = true
            startSearch()
        }
        .navigationTitle("Search Google Books")
    }
}


struct LinkButton: ButtonStyle {
    
    var disabled:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
#if os(iOS)
        .buttonStyle(DefaultButtonStyle())
#else
        .buttonStyle(.borderless)
#endif
        .foregroundColor(disabled ? .gray : .blue)

    }
}

/// The UI for the returned list of bootks
struct BookList : View {
    
    @ObservedObject var books:BookResults
    @State private var isPresentingModal = false
    @Environment(\.openURL) var openURL

    var body: some View {
        List(books.items) { book in
            let imageUrlStr = book.getThumbnail() // get the thumbnail
            HStack{
            if imageUrlStr.isEmpty == false {
                if let url =  URL(string: imageUrlStr) {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 120, height: 170)
                        .cornerRadius(10).padding(3)
                        .shadow(color: .gray, radius: 2.0, x: 1.0, y: 2.0)
                }
            }
            else{
                Image("thumbnail").resizable()
                    .frame(width: 120, height: 170)
                    .cornerRadius(10).padding(3)
                    .shadow(color: .gray, radius: 2.0, x: 1.0, y: 2.0)
            }
                
            VStack(alignment: .leading, spacing: 8) {
                Text(book.volumeInfo?.title ?? "").fontWeight(.heavy) // title
                Text(book.volumeInfo?.getAuthors() ?? "n/a") // authors
                Text(book.volumeInfo?.volumeInfoDescription ?? "n/a")
                    .font(.caption)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading) // description
#if os(iOS)
                NavigationLink(destination: PDFViewer()) {
                    Text("Download")
                }
#else
                Button("Download") {
                    openURL(URL(string:"GoogleBooks://viewer")!) // download
                }.buttonStyle(LinkButton(disabled: false))
#endif
            }
        }
    }
  }
}

// The extension which encapsulates all the methods used by Bottom Bar
extension BottomBar {
    
    var isNextDisabled:Bool {
        books.totalItems == 0
    }
    
    var isPrevDisabled:Bool {
        return page == 0 || books.totalItems == 0
    }

    /// increments  the page and re-runs a search
    func getNextPage() {
        isSearching = true
        books = BookResults(empty: true)
        GoogleApi.shared.getNextPage { result in
            isSearching = false
            switch(result) {
            case .success(let bookResults):
                books = bookResults
            case .failure(let error):
                print("error in book results \(error)")
            }
        }
    }
    
    
    /// decrements the page and re-runs a search
    func getPrevPage() {
        isSearching = true
        books = BookResults(empty: true)
        GoogleApi.shared.getPreviousPage { result in
            isSearching = false
            switch(result) {
            case .success(let bookResults):
                books = bookResults
            case .failure(let error):
                print("error in book results \(error)")
            }
        }
    }
}

/// The bottom bar for the next and previous buttons
struct BottomBar : View {
    
    @Binding var books:BookResults
    @Binding var isSearching:Bool
    var page:Int
   
    var body: some View {
        HStack {
            Button("Previous") {
                getPrevPage()
            }.padding()
                .buttonStyle(LinkButton(disabled: isPrevDisabled))
            Spacer()
            Button("Next") {
                getNextPage()
            }.padding()
                .buttonStyle(LinkButton(disabled: isNextDisabled))
        }
    }
}
            

