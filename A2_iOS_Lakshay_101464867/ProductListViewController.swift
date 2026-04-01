//
//  ProductListViewController.swift
//  A2_iOS_Lakshay_101464867
//
//  Created by Lakshay on 2026-03-30.
//

import UIKit
import CoreData

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Data
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    
    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupSearchController()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or description"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Data Fetching
    private func fetchProducts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]
        do {
            products = try context.fetch(request)
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = product.productName
        config.secondaryText = product.productDescription
        config.secondaryTextProperties.color = .secondaryLabel
        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        
        if let index = products.firstIndex(where: { $0.productID == product.productID }) {
            let detailVC = ProductDetailViewController()
            detailVC.selectedProductIndex = index
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredProducts = []
            tableView.reloadData()
            return
        }
        filteredProducts = products.filter { product in
            let nameMatch = product.productName?.localizedCaseInsensitiveContains(searchText) ?? false
            let descMatch = product.productDescription?.localizedCaseInsensitiveContains(searchText) ?? false
            return nameMatch || descMatch
        }
        tableView.reloadData()
    }
}
