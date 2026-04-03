//
//  AddProductViewController.swift
//  A2_iOS_Lakshay_101464867
//
//  Created by Lakshay on 2026-04-02.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let priceTextField = UITextField()
    private let providerTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Product"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Configure text fields
        let textFields = [nameTextField, descriptionTextField, priceTextField, providerTextField]
        let placeholders = ["Product Name", "Product Description", "Product Price", "Product Provider"]
        
        for (field, placeholder) in zip(textFields, placeholders) {
            field.placeholder = placeholder
            field.borderStyle = .roundedRect
            field.font = .systemFont(ofSize: 16)
            field.translatesAutoresizingMaskIntoConstraints = false
        }
        
        priceTextField.keyboardType = .decimalPad
        
        // Configure save button
        saveButton.setTitle("Save Product", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Stack view
        let stackView = UIStackView(arrangedSubviews: textFields + [saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        for field in textFields {
            field.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    // MARK: - Actions
    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty,
              let description = descriptionTextField.text, !description.trimmingCharacters(in: .whitespaces).isEmpty,
              let priceText = priceTextField.text, let price = Double(priceText),
              let provider = providerTextField.text, !provider.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Get next available ID
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: false)]
        request.fetchLimit = 1
        
        var nextID: Int32 = 1
        if let maxProduct = try? context.fetch(request).first {
            nextID = maxProduct.productID + 1
        }
        
        let product = Product(context: context)
        product.productID = nextID
        product.productName = name.trimmingCharacters(in: .whitespaces)
        product.productDescription = description.trimmingCharacters(in: .whitespaces)
        product.productPrice = price
        product.productProvider = provider.trimmingCharacters(in: .whitespaces)
        
        do {
            try context.save()
        } catch {
            print("Failed to save product: \(error)")
        }
    }
}
