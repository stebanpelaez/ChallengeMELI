//
//  BaseViewModel.swift
//  Test ML
//
//  Created by Juan Esteban Peláez Martínez on 3/06/23.
//

import Foundation

typealias HandlerCompletion = (() -> Void)

class BaseViewModel {

    // Formato para mostrar el precio de un producto
    let currencyFormatter: NumberFormatter = {
        let formatter =  NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

}
