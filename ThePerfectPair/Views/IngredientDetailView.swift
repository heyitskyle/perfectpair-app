//
//  IngredientDetailView.swift
//  ThePerfectPair
//
//  Created by Kyle Lehmann on 4/23/24.
//

import SwiftUI

struct IngredientDetailView: View {
    @EnvironmentObject var ingredientModelContainer: IngredientModelContainer
    var ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ingredient: \(ingredient.name)")
            Text("Category ID: \(ingredient.categoryId)")
            // Assuming you have a method to fetch the category name by ID
            if let categoryName = ingredientModelContainer.categories?.first(where: { $0.id == ingredient.categoryId })?.name {
                Text("Category: \(categoryName)")
            }
        }
        .padding()
        .navigationTitle(ingredient.formattedName)
    }
}
