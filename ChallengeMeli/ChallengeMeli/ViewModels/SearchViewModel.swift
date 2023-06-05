//
//  SearchViewModel.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 15/11/21.
//

import Foundation

struct DataCellSearchViewModel {
    let title: String
    let price: String
    let url: URL
    let discount: String
}

class SearchViewModel: BaseViewModel {

    private var cellViewModels: [DataCellSearchViewModel] = [DataCellSearchViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }

    var numberOfCells: Int {
        return self.cellViewModels.count
    }

    var reloadTableView: HandlerCompletion?
    var showError: HandlerCompletion?
    var showNoResultsFound: HandlerCompletion?

    private var resultItems: [ResultItem] = [ResultItem]()

    // Invocar servicio api para el buscador
    func searchFromService(searchText: String) {
        let url = "\(Constants.urlSearch.rawValue)\(searchText)"
        self.apiService.getService(url: url, type: SearchData.self) { [weak self] response in
            switch response {
            case .success(let searchData):
                self?.createCells(resultItems: searchData.results)
            case .failure(let error):
                print(error.localizedDescription)
                self?.clearCells()
                self?.showError?()
            }
        }
    }

    func getResultItem(at indexPath: IndexPath) -> ResultItem {
        return self.resultItems[indexPath.row]
    }

    func getCellViewModel(at indexPath: IndexPath) -> DataCellSearchViewModel {
        return self.cellViewModels[indexPath.row]
    }

    func createCells(resultItems: [ResultItem]) {

        if resultItems.isEmpty {
            self.clearCells()
            self.showNoResultsFound?()
            return
        }

        var dataList = [DataCellSearchViewModel]()
        var items = [ResultItem]()
        for item in resultItems {
            if let url = URL(string: item.thumbnail), let price = self.currencyFormatter.string(from: NSNumber(value: item.price)) {
                var discount = ""
                if let originalPrice = item.originalPrice, originalPrice>item.price {
                    let valueDiscount = (Double(item.price-originalPrice)/Double(originalPrice))*(-100)
                    discount = "\(Int(valueDiscount))% OFF"
                }
                dataList.append(DataCellSearchViewModel(title: item.title, price: "$ \(price)", url: url, discount: discount))
                items.append(item)
            }
        }

        self.resultItems = items
        self.cellViewModels = dataList
    }

    func clearCells() {
        self.cellViewModels = []
        self.resultItems = []
    }

}
