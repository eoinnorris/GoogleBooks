//
//  GoogleBooksTests.swift
//  GoogleBooksTests
//
//  Created by Eoin Norris on 08/02/2022.
//

import XCTest
@testable import GoogleBooks
import SwiftUI

struct BadJsonNetworkAPI: NetworkProtocol {
    
    func getData(fromURL url: URL, completion: @escaping DataResultBlock) {
        if let badData = "Bad JSON".data(using: .utf8) {
            completion(.success(badData))
        } else  {
            completion(.failure(.noData))
        }
    }
    
}

class GoogleBooksTests: XCTestCase {
    
    let network = Network()


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testDownload() throws {
        let exp = expectation(description: "testDownload")
        let url = URL(string: "https://www.bloomsbury.com/media/hmqifwq2/harry-potter-and-the-philosopher-s-stone-discussion-guide.pdf")!
        var localfile:DownloadedFile? = nil
        
        network.downLoadFile(forURL: url) { result in
            
            switch(result) {
                case .success(let url):
                    localfile = url
                case .failure(let error):
                    print("error in network cal \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
        XCTAssert(localfile?.localURL != nil)
    }
    
    func testDownloadFailure() throws {
         let exp = expectation(description: "testDownloadFailure")
         let url = URL(string: "badURL")!
         var resultError:Error? = nil
        
         network.downLoadFile(forURL: url) { result in
             switch(result) {
                 case .success(_):
                 print("success")
                 case .failure(let error):
                 resultError = error
                     print("error in network cal \(error)")
             }
             exp.fulfill()
         }
         waitForExpectations(timeout: 10)
         XCTAssert(resultError != nil)
        
    }
    
    func testDownloadIsPDF() throws {
        let exp = expectation(description: "testDownloadIsPDF")
        let url = URL(string: "https://www.bloomsbury.com/media/hmqifwq2/harry-potter-and-the-philosopher-s-stone-discussion-guide.pdf")!
        var localfile:DownloadedFile? = nil
        
        network.downLoadFile(forURL: url) { result in
            
            switch(result) {
                case .success(let url):
                    localfile = url
                case .failure(let error):
                    print("error in network cal \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
        XCTAssert(localfile?.localURL?.pathExtension == "pdf")
    }
    
    func testDownloadIsOnLocalDisk() throws {
        let exp = expectation(description: "testDownloadIsOnLocalDisk")
        let url = URL(string: "https://www.bloomsbury.com/media/hmqifwq2/harry-potter-and-the-philosopher-s-stone-discussion-guide.pdf")!
        var localfile:DownloadedFile? = nil
        
        network.downLoadFile(forURL: url) { result in
            
            switch(result) {
                case .success(let url):
                    localfile = url
                case .failure(let error):
                    print("error in network call \(error)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        let exists = FileManager.default.fileExists(atPath: localfile?.localURL?.path ?? "")
        XCTAssert(exists == true)
    }
    
    func testGoogleSearch() {
        let api = GoogleApi(network)
        let exp = expectation(description: "testGoogleSearch")
        var results:BookResults?  = nil
        
        api.getBooks(forSearch: "harry potter", page: 0) { result in
            switch(result) {
                case .success(let books):
                results = books
                case .failure(let error):
                    print("error in book results \(error)")
            }
            exp.fulfill()

        }
        waitForExpectations(timeout: 30)
        
        XCTAssert(results?.totalItems != nil)
    }
    
    func testGoogleSearchFails() {
        let api = GoogleApi()
        let exp = expectation(description: "testGoogleSearch")
        var resultError:Error?  = nil
        
        api.getBooks(forSearch: "", page: 0) { result in
            switch(result) {
                case .success(_):
                break;
                case .failure(let error):
                resultError = error
                    print("error in book results \(error)")
            }
            exp.fulfill()

        }
        waitForExpectations(timeout: 30)
        
        XCTAssert(resultError != nil)
    }
    
    func testGoogleSearchBadJson() {
        let network = BadJsonNetworkAPI()
        let api = GoogleApi(network)
        let exp = expectation(description: "testGoogleSearch")
        var resultError:DataResultError?  = nil
        
        // the search term is right but the JSOn is corrupt
        api.getBooks(forSearch: "harry potter", page: 0) { result in
            switch(result) {
                case .success(_):
                break;
                case .failure(let error):
                resultError = error
                    print("error in book results \(error)")
            }
            exp.fulfill()

        }
        waitForExpectations(timeout: 30)
        
        if case DataResultError.jsonDecodeFailed = resultError! {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }


}
