//
//  MockConstants.swift
//  vssh-ios-communicationTests
//
//  Created by Juan Esteban Peláez Martínez on 18/10/22.
//  Copyright © 2022 Valid Colombia. All rights reserved.
//

import Foundation
@testable import ChallengeMeli

enum MockConstants {

    static let resultItem = ResultItem(id: "MCO917849431", title: "Moto G22 128 Gb Iceberg Blue 4 Gb Ram", price: 629900, originalPrice: 1299000, thumbnail: "http://http2.mlstatic.com/D_724765-MLA50262139770_062022-I.jpg")

    static let responseDescription = [
        "plain_text": "plainText"
    ]

    static let empty = [ "results": [] as [Any]] as [String: Any]

    static let items = [ "results": [product]]

    static let product = [
        "id": "MCO917849431",
        "title": "Moto G22 128 Gb Iceberg Blue 4 Gb Ram",
        "price": 629900,
        "base_price": 629900,
        "original_price": 1299000,
        "currency_id": "COP",
        "initial_quantity": 90,
        "available_quantity": 1,
        "sold_quantity": 50,
        "condition": "new",
        "thumbnail": "http://http2.mlstatic.com/D_724765-MLA50262139770_062022-I.jpg",
        "pictures": [
            [
                "url": "http://http2.mlstatic.com/D_724765-MLA50262139770_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_724765-MLA50262139770_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_817967-MLA50262225265_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_817967-MLA50262225265_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_907256-MLA50262139771_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_907256-MLA50262139771_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_687753-MLA50291545774_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_687753-MLA50291545774_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_967776-MLA50291564546_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_967776-MLA50291564546_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_962087-MLA50291564545_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_962087-MLA50291564545_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_890022-MLA50262133849_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_890022-MLA50262133849_062022-O.jpg"
            ],
            [
                "url": "http://http2.mlstatic.com/D_604467-MLA50262316032_062022-O.jpg",
                "secure_url": "https://http2.mlstatic.com/D_604467-MLA50262316032_062022-O.jpg"
            ]
        ],
        "warranty": "Garantía del vendedor: 6 meses",
        "attributes": [
            [
                "name": "Marca",
                "value_name": "Motorola"
            ],
            [
                "name": "Modelo de GPU",
                "value_name": "PowerVR GE8320"
            ],
            [
                "name": "Condición del ítem",
                "value_name": "Nuevo"
            ],
            [
                "name": "Línea",
                "value_name": "Moto G"
            ],
            [
                "name": "Modelo",
                "value_name": "G22"
            ]
        ]
    ] as [String: Any]

}
