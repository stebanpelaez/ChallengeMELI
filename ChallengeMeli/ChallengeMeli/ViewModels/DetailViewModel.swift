//
//  DetailViewModel.swift
//  Test ML
//
//  Created by Juan Esteban Peláez Martínez on 3/06/23.
//

import Foundation

class DetailViewModel: BaseViewModel {

    var product: Product? {
        didSet {
            self.reloadUI?()
        }
    }

    var productDescription: String = "" {
        didSet {
            self.reloadUIDescription?()
        }
    }

    var reloadUI: HandlerCompletion?
    var reloadUIDescription: HandlerCompletion?

    // Obtener información del producto
    func detailProductFromService(id: String) {
        let url = "\(Constants.urlDetail.rawValue)\(id)"
        self.apiService.getService(url: url, type: Product.self) { [weak self] response in
            switch response {
            case .success(let product):
                self?.product = product
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // Obtener descripcion del producto
    func detailProductDescriptionFromService(id: String) {
        let url = "\(Constants.urlDetail.rawValue)\(id)\(Constants.urlDetailDescription.rawValue)"
        self.apiService.getService(url: url, type: Description.self) { [weak self] response in
            switch response {
            case .success(let description):
                if let plainText = description.plainText {
                    self?.productDescription = plainText
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
