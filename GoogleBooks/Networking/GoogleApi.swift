//
//  GoogleApi.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import Foundation
import Network

enum NetworkValues:String {
    case baseURL="https://www.googleapis.com/books/v1/volumes?q="
}

typealias BookResultBlock = (_ result:Result<BookResults,DataResultError>) -> Void


/// Class to handle the google Books API interaction
class GoogleApi {
    
    let network:NetworkProtocol?
    let googleBaseURL = NetworkValues.baseURL
    
    // for paging
    var page:Int = 0
    var lastSearch:String = ""
    
    static let shared = GoogleApi()

    /// Using the NetworkProtocol rather than Network allows dependency injection for testing
    /// - Parameter network: any object conforming to NetworkProtocol
    init(_ network:NetworkProtocol? = Network()) {
        self.network = network
    }
    
    
    /// Builds a URL from the paramaters
    /// - Parameters:
    ///   - base: the base UEL
    ///   - term: the search term
    ///   - page: the page we are requesting
    ///   - resultNumber: the number of items
    /// - Returns: A value url string
    func buildURL(from base:String,
                searchTerm term:String,
                page:Int,
                itemCount:Int) -> String {
        let normalisedSearch = term.replacingOccurrences(of: " ", with: "+")
        let startIndex = page * itemCount
        let params = "&startIndex=\(startIndex)&maxResults=\(itemCount)&projection=lite"
        return base + normalisedSearch + params
    }
    
    ///  wrapper for the prefferred JSON decoder.
    /// - Returns: a JSON decoder
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func getPreviousPage(completion:  @escaping BookResultBlock) {
        page-=1
        if page < 0  { page = 0 }
        getBooks(forSearch: lastSearch, page: page) { result in
            completion(result)
        }
    }
    
    func getNextPage(completion:  @escaping BookResultBlock) {
        page+=1
        getBooks(forSearch: lastSearch, page: page) { result in
            completion(result)
        }
    }
    

    
    /// Retriences the books from the search API
    /// - Parameters:
    ///   - term: the search term
    ///   - page: the page requested
    ///   - number: the number of items requested
    ///   - completion: A BookResultBlock with the BookResults or a DataResultError
    public func getBooks(forSearch term:String,
                  page:Int,
                  number:Int=20,
                  completion:  @escaping BookResultBlock) {
        
        self.page = page
        self.lastSearch = term
        
        // url encode
        let urlStr = buildURL(from: googleBaseURL.rawValue,
                              searchTerm: term,
                              page: page,
                              itemCount: number)
        
        if let url = URL(string: urlStr) {
            network?.getData(fromURL: url) { result in
            switch(result) {
                case .success(let data):
                    do {
                        let books = try self.jsonDecoder().decode(BookResults.self, from: data)
                        completion(.success(books))
                    } catch {
                        print("failed to decide: \(error)")
                        completion(.failure(.jsonDecodeFailed))
                    }
                case .failure(let error):
                    print("error in book results \(error)")
                    completion(.failure(error))
                }
            }
        } else {
            print("error in creating URL from \(urlStr)")
            completion(.failure(.badURL))
        }
        
    }
    
}
