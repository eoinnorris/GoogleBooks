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


class GoogleApi {
    
    var network:NetworkProtocol?
    let url = NetworkValues.baseURL
    
    // for paging
    
    var page:Int = 0
    var lastSearch:String = ""
    
    static let shared = GoogleApi()

    /// Using the NetworkProtocol here allows dependency injection for testing
    /// - Parameter network: any object conforming to NetworkProtocol
    init(_ network:NetworkProtocol? = Network()) {
        self.network = network
    }
    
    func buildURL(from base:String,
                searchTerm term:String,
                page:Int,
                resultNumber:Int) -> String{
        let normalisedSearch = term.replacingOccurrences(of: " ", with: "+")
        let startIndex = page * resultNumber
        let params = "&startIndex=\(startIndex)&maxResults=\(resultNumber)&projection=lite"
        return base + normalisedSearch + params
    }
    
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func getPreviousPage(completion:  @escaping BookResultBlock) {
        page = page-1
        if page < 0  { page = 0 }
        
        getBooks(forSearch: lastSearch, page: page) { result in
            completion(result)
        }
    }
    
    func getNextPage(completion:  @escaping BookResultBlock) {
        page = page+1
        
        getBooks(forSearch: lastSearch, page: page) { result in
            completion(result)
        }
    }
    

    func getBooks(forSearch term:String,
                  page:Int,
                  number:Int=20,
                  completion:  @escaping BookResultBlock) {
        
        self.page = page
        self.lastSearch = term
        
        // url encode
        let urlStr = buildURL(from: url.rawValue,
                              searchTerm: term,
                              page: page,
                              resultNumber: 20)
        
        if let url = URL(string: urlStr) {
            network?.getData(fromURL: url) { result in
            switch(result) {
                case .success(let data):
                    do {
                        let books = try self.jsonDecoder().decode(BookResults.self, from: data)
                        completion(.success(books))
                    } catch {
                        print(error)
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
