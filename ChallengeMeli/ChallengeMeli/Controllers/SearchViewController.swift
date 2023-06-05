//
//  ViewController.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 14/11/21.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var viewError: UIStackView!

    // Reintentar busqueda
    @IBAction func reloadSearch(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.newSearch()
        }
    }

    let searchController = UISearchController(searchResultsController: nil)

    private enum ReuseIdentifiers: String {
        case searchItemUITableViewCell
    }

    private var firstTime = true
    var viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Se inicializan los componentes UI y los handlers del viewModel
        self.configureSearchBar()
        self.configureTableView()
        self.initViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.dismiss(animated: true, completion: nil)
    }

    // Apenas muestre la pantalla se enfoca el buscador
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
                self.firstTime = false
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController, let indexPath = self.tableView.indexPathForSelectedRow {
            destination.productResult =  self.viewModel.getResultItem(at: indexPath)
        }
    }

}
// MARK: - Private Methods
extension SearchViewController {

    // Configuracion de la tableView
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsMultipleSelection = false
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = 108

        self.tableView.register(UINib(nibName: "SearchItemUITableViewCell", bundle: nil), forCellReuseIdentifier: ReuseIdentifiers.searchItemUITableViewCell.rawValue)
    }

    private func initViewModel() {
        self.viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }

        self.viewModel.showNoResultsFound = {
            DispatchQueue.main.async {
                self.setVisibilityNoResultsFound(hidden: false)
            }
        }

        self.viewModel.showError = {
            DispatchQueue.main.async {
                self.setVisibilityError(hidden: false)
            }
        }
    }

    // Refrescar UI TableView
    private func reloadData() {
        self.tableView.reloadData()
    }

    // Mostrar u ocultar, vista de cuando hay un error al invocar el servicio
    private func setVisibilityError(hidden: Bool) {
        self.viewError.isHidden = hidden
    }

    // Mostrar u ocultar, label sin resultados
    private func setVisibilityNoResultsFound(hidden: Bool) {
        self.labelEmpty.isHidden = hidden
    }

}

// MARK: - UISearchBar
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
    }

    // Este metodo se llama cuando se da tap al boton buscar del teclado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.newSearch()
        }
    }

    // Metodo para generar una nueva busqueda
    func newSearch() {
        // Se verifica que el texto a buscar de por lo menos una letra y se invoca el servicio desde el ViewModel (API Service)
        if let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchText.count > 0 {
            self.searchController.searchBar.resignFirstResponder()
            self.viewModel.clearCells()
            self.setVisibilityNoResultsFound(hidden: true)
            self.setVisibilityError(hidden: true)
            self.viewModel.searchFromService(searchText: searchText)
        } else {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

}

// MARK: - UITableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.searchItemUITableViewCell.rawValue, for: indexPath) as? SearchItemUITableViewCell else {
            return UITableViewCell()
        }

        let cellVM = self.viewModel.getCellViewModel(at: indexPath)

        cell.imageViewThumbnail.sd_setImage(with: cellVM.url, placeholderImage: UIImage(), options: [], completed: nil)
        cell.labelTitle.text = cellVM.title
        cell.labelPrice.text = cellVM.price
        cell.labelDiscount.text = cellVM.discount

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openDetailProduct", sender: self)
    }

}
// MARK: - UI
extension SearchViewController {

    // Configuracion UI, se agrega un searchController para el buscador
    private func configureSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setNewcolor(color: UIColor.black)

        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.searchBar.delegate = self

        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
    }

}
