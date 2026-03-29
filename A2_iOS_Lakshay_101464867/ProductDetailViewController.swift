//
//  ProductDetailViewController.swift
//  A2_iOS_Lakshay_101464867
//
//  Created by Lakshay on 2026-03-28.
//

import UIKit
import CoreData

class ProductDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    private let cardView = UIView()
    
    private let idTitleLabel = UILabel()
    private let idValueLabel = UILabel()
    private let nameTitleLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descriptionValueLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let priceValueLabel = UILabel()
    private let providerTitleLabel = UILabel()
    private let providerValueLabel = UILabel()
    
    // MARK: - Data
    private var products: [Product] = []
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        view.backgroundColor = .systemBackground
        setupUI()
        fetchProducts()
        displayCurrentProduct()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Card container
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        
        // Configure title labels
        let titleLabels = [idTitleLabel, nameTitleLabel, descriptionTitleLabel, priceTitleLabel, providerTitleLabel]
        let titles = ["Product ID", "Name", "Description", "Price", "Provider"]
        for (label, titleText) in zip(titleLabels, titles) {
            label.text = titleText
            label.font = .systemFont(ofSize: 13, weight: .medium)
            label.textColor = .secondaryLabel
        }
        
        // Configure value labels
        let valueLabels = [idValueLabel, nameValueLabel, descriptionValueLabel, priceValueLabel, providerValueLabel]
        for label in valueLabels {
            label.font = .systemFont(ofSize: 17)
            label.textColor = .label
            label.numberOfLines = 0
        }
        nameValueLabel.font = .systemFont(ofSize: 22, weight: .bold)
        priceValueLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        priceValueLabel.textColor = .systemGreen
        
        // Build fields stack
        let fieldsStack = UIStackView()
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 16
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        
        for (titleLabel, valueLabel) in zip(titleLabels, valueLabels) {
            let fieldStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            fieldStack.axis = .vertical
            fieldStack.spacing = 4
            fieldsStack.addArrangedSubview(fieldStack)
        }
        
        cardView.addSubview(fieldsStack)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            fieldsStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            fieldsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            fieldsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            fieldsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])
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
    
    // MARK: - Display
    private func displayCurrentProduct() {
        guard !products.isEmpty else {
            nameValueLabel.text = "No products available"
            return
        }
        let product = products[currentIndex]
        idValueLabel.text = "\(product.productID)"
        nameValueLabel.text = product.productName ?? "N/A"
        descriptionValueLabel.text = product.productDescription ?? "N/A"
        priceValueLabel.text = String(format: "$%.2f", product.productPrice)
        providerValueLabel.text = product.productProvider ?? "N/A"
    }
}
