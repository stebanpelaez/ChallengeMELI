//
//  APIService+Extension.swift
//  Test ML
//
//  Created by Juan Esteban Peláez Martínez on 3/06/23.
//

import Foundation

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(Int)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

enum Constants: String {
    case urlSearch = "https://api.mercadolibre.com/sites/MCO/search?q="
    case urlDetail = "https://api.mercadolibre.com/items/"
    case urlDetailDescription = "/description?api_version=2"
}
