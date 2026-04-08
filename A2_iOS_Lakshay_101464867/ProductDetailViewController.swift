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
    
    private let previousButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let counterLabel = UILabel()
    
    // MARK: - Data
    private var products: [Product] = []
    private var currentIndex: Int = 0
    var selectedProductIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        view.backgroundColor = .systemBackground
        setupUI()
        fetchProducts()
        if let index = selectedProductIndex {
            currentIndex = index
        }
        displayCurrentProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
        if selectedProductIndex == nil && currentIndex >= products.count {
            currentIndex = max(products.count - 1, 0)
        }
        displayCurrentProduct()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Card container
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
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
        
        // Navigation buttons
        previousButton.setTitle("← Previous", for: .normal)
        previousButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        nextButton.setTitle("Next →", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        counterLabel.font = .systemFont(ofSize: 14)
        counterLabel.textColor = .secondaryLabel
        counterLabel.textAlignment = .center
        
        let navStack = UIStackView(arrangedSubviews: [previousButton, counterLabel, nextButton])
        navStack.axis = .horizontal
        navStack.distribution = .equalSpacing
        navStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navStack)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            fieldsStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            fieldsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            fieldsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            fieldsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            
            navStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            navStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            navStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
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
        counterLabel.text = "\(currentIndex + 1) of \(products.count)"
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
    }
    
    // MARK: - Navigation Actions
    @objc private func previousTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            displayCurrentProduct()
        }
    }
    
    @objc private func nextTapped() {
        if currentIndex < products.count - 1 {
            currentIndex += 1
            displayCurrentProduct()
        }
    }
}
