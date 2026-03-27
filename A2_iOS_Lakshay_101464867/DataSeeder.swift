//
//  DataSeeder.swift
//  A2_iOS_Lakshay_101464867
//
//  Created by Lakshay on 2026-03-27.
//

import UIKit
import CoreData

class DataSeeder {
    
    static func seedIfNeeded(context: NSManagedObjectContext) {
        let hasSeeded = UserDefaults.standard.bool(forKey: "hasSeededData")
        guard !hasSeeded else { return }
        
        let products: [(Int32, String, String, Double, String)] = [
            (1, "iPhone 15 Pro", "Latest Apple smartphone with A17 Pro chip and titanium design", 1199.99, "Apple"),
            (2, "MacBook Pro 16", "Professional laptop with M3 Max chip and Liquid Retina XDR display", 2499.99, "Apple"),
            (3, "iPad Air", "Lightweight tablet with M1 chip for everyday productivity", 599.99, "Apple"),
            (4, "Samsung Galaxy S24 Ultra", "Flagship Android smartphone with AI features and S Pen", 1299.99, "Samsung"),
            (5, "Sony WH-1000XM5", "Premium wireless noise-cancelling headphones with 30hr battery", 349.99, "Sony"),
            (6, "Dell XPS 15", "High-performance Windows laptop with OLED display", 1799.99, "Dell"),
            (7, "Nintendo Switch OLED", "Hybrid gaming console with vibrant 7-inch OLED screen", 349.99, "Nintendo"),
            (8, "Amazon Echo Dot 5th Gen", "Compact smart speaker with improved audio and Alexa built-in", 49.99, "Amazon"),
            (9, "Google Pixel 8 Pro", "Google flagship phone with Tensor G3 chip and advanced AI camera", 999.99, "Google"),
            (10, "AirPods Pro 2nd Gen", "Wireless earbuds with active noise cancellation and adaptive audio", 249.99, "Apple")
        ]
        
        for (id, name, desc, price, provider) in products {
            let product = Product(context: context)
            product.productID = id
            product.productName = name
            product.productDescription = desc
            product.productPrice = price
            product.productProvider = provider
        }
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "hasSeededData")
        } catch {
            print("Failed to seed data: \(error)")
        }
    }
}
