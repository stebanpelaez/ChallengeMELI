//
//  ViewModels.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 14/11/21.
//
import Foundation

// Este modelo es el minimo viable para esta prueba, para el buscador

// MARK: - DataML
struct SearchData: Codable {
    let results: [ResultItem]
}

// MARK: - Result
struct ResultItem: Codable {
    let id: String
    let title: String
    let price: Int
    let originalPrice: Int?
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case originalPrice = "original_price"
        case thumbnail
    }
}

struct Price: Codable {
    let type: String
    let amount: Int
}
