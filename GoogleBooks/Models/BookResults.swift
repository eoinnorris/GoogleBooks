//
//  BookModels.swift
//  GoogleBooks
//
//  Created by Eoin Norris on 09/02/2022. Generated from Swify-Json
//


import Foundation

// MARK: - Book
class BookResults: Codable, ObservableObject {
    let kind: String?
    let totalItems: Int?
    let items: [Item]
    
    init(empty:Bool) {
        self.kind = ""
        self.totalItems = 0
        self.items = []
    }
}

// MARK: - Item
struct Item: Codable, Identifiable {
    let kind: Kind?
    let id, etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let accessInfo: AccessInfo?
    let searchInfo: SearchInfo?
    
    func getThumbnail() -> String {
        if let result = volumeInfo?.imageLinks?.thumbnail {
           return result.replacingOccurrences(of: "http", with: "https")
       }
       return  ""
   }
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let country: Country?
    let viewability: Viewability?
    let embeddable, publicDomain: Bool?
    let textToSpeechPermission: TextToSpeechPermission?
    let epub, pdf: Epub?
    let webReaderLink: String?
    let accessViewStatus: AccessViewStatus?
    let quoteSharingAllowed: Bool?
}

enum AccessViewStatus: String, Codable {
    case none = "NONE"
    case sample = "SAMPLE"
    case fullPublicDomain = "FULL_PUBLIC_DOMAIN"

}

enum Country: String, Codable {
    case ie = "IE"
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

enum TextToSpeechPermission: String, Codable {
    case allowed = "ALLOWED"
    case allowedForAccessibility = "ALLOWED_FOR_ACCESSIBILITY"
}

enum Viewability: String, Codable {
    case noPages = "NO_PAGES"
    case partial = "PARTIAL"
}

enum Kind: String, Codable {
    case booksVolume = "books#volume"
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: Country?
    let saleability: Saleability?
    let isEbook: Bool?
    let listPrice, retailPrice: SaleInfoListPrice?
    let buyLink: String?
    let offers: [Offer]?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Double?
    let currencyCode: String?
}

// MARK: - Offer
struct Offer: Codable {
    let finskyOfferType: Int?
    let listPrice, retailPrice: OfferListPrice?
}

// MARK: - OfferListPrice
struct OfferListPrice: Codable {
    let amountInMicros: Int?
    let currencyCode: String?
}

enum Saleability: String, Codable {
    case forSale = "FOR_SALE"
    case notForSale = "NOT_FOR_SALE"
    case free = "FREE"
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publishedDate, volumeInfoDescription: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes?
    let pageCount: Int?
    let printType: PrintType?
    let averageRating: Double?
    let ratingsCount: Int?
    let maturityRating: MaturityRating?
    let allowAnonLogging: Bool?
    let contentVersion: String?
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLinks?
    let language: Language?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
    let publisher: String?
    let categories: [String]?
    let subtitle: String?

    enum CodingKeys: String, CodingKey {
        case title, authors, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, readingModes, pageCount, printType, averageRating, ratingsCount, maturityRating, allowAnonLogging, contentVersion, panelizationSummary, imageLinks, language, previewLink, infoLink, canonicalVolumeLink, publisher, categories, subtitle
    }
    
    func getAuthors() -> String {
          var result = "Written by:"
          if let authors = authors {
              for author in authors {
                  result = result + " \(author)"
              }
          }
          
          return result
      }
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let type: TypeEnum?
    let identifier: String?
}

enum TypeEnum: String, Codable {
    case isbn10 = "ISBN_10"
    case isbn13 = "ISBN_13"
    case other = "OTHER"
}

enum Language: String, Codable {
    case en = "en"
    case ptBR = "pt-BR"
    case ur = "ur"
}

enum MaturityRating: String, Codable {
    case notMature = "NOT_MATURE"
    case mature = "MATURE"

}

// MARK: - PanelizationSummary
struct PanelizationSummary: Codable {
    let containsEpubBubbles, containsImageBubbles: Bool?
}

enum PrintType: String, Codable {
    case book = "BOOK"
}

// MARK: - ReadingModes
struct ReadingModes: Codable {
    let text, image: Bool?
}
