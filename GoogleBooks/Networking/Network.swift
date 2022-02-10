//
//  Network.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022.
//

import Foundation

typealias DataResultBlock = (_ result:Result<Data,DataResultError>) -> Void
typealias DownloadFileBlock = (_ result:Result<DownloadedFile,DataResultError>) -> Void


enum DataResultError:Error {
    case none
    case downloadFailed(Error)
    case downloadMissingURL
    case failedRename
    case jsonDecodeFailed
    case badURL
    case noData
}

protocol DownloadManager {
    func downLoadFile(forURL url:URL,completion:  @escaping DownloadFileBlock)
}

// mark: Download Manager - the extension to download the PDFs
extension Network: DownloadManager{
    
    enum ValidExtension:String {
        case pdf
    }
    
    /// Renames and moves the downloaded file to  a PDF for sanity
    /// - Parameters:
    ///   - url: the local downloaded url
    ///   - suffix: the new suffix to chante to
    /// - Returns: the renamed URL, or nil. Throws
    private func renameURL(_ url:URL,
                           toExtension suffix:ValidExtension) throws -> URL? {
        if url.pathExtension != suffix.rawValue {
            let newURL = url.deletingPathExtension().appendingPathExtension(suffix.rawValue)
            try FileManager.default.moveItem(at: url, to: newURL)
            return newURL
        }
        return url
    }
    
    
    /// Downloads a file from url and returns a DownloadedFile object
    /// - Parameters:
    ///   - url: the download URL
    ///   - completion: A  downloadedfile object with the correct paths, or an error
    public func downLoadFile(forURL url:URL,completion:  @escaping DownloadFileBlock) {
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let error = error {
                completion(.failure(.downloadFailed(error)))
            } else {
                if let localURL = localURL {
                    if let newURL = try? renameURL(localURL, toExtension: .pdf) {
                        let downloadFile = DownloadedFile(localURL: newURL, type: .PDF)
                        completion(.success(downloadFile))
                    } else {
                        completion(.failure(.failedRename))
                    }
                } else {
                    completion(.failure(.downloadMissingURL))
                }
            }
        }
        task.resume()
    }
}

protocol NetworkProtocol {
    func getData(fromURL url:URL,
                    completion:  @escaping DataResultBlock)
}

/// General Network handling classes.
struct Network:NetworkProtocol  {
    static let shared = Network()
    
    enum APIMethod:String{
        case get = "GET"
        case post = "POST"
        case head = "HEAD"
    }
    
    /// Simple wrapper ofr a GET networking call. 
    /// - Parameters:
    ///   - url: the  url to get the data from
    ///   - completion: the result closue which will return the data or an erro
    func getData(fromURL url:URL,
                    completion:  @escaping DataResultBlock) {
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.httpMethod = APIMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                completion(.failure(.downloadFailed(error)))
            } else {
                if let jsonData = data {
                    completion(.success(jsonData))
                    // use result
                } else {
                    completion(.failure(.noData))
             }
          }
        }
        task.resume()
    }
}
