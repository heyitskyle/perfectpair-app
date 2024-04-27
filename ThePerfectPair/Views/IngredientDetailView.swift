//
//  IngredientDetailView.swift
//  ThePerfectPair
//
//  Created by Kyle Lehmann on 4/23/24.
//

import SwiftUI

struct IngredientDetailView: View {
    @EnvironmentObject var ingredientModelContainer: IngredientModelService
    var ingredient: Ingredient

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ingredient: \(ingredient.name)")
        }
        .padding()
        .navigationTitle(ingredient.formattedName)
    }
}


#Preview {
    let ingredientModelService = IngredientModelService()
    ingredientModelService.populateFromJSON(ingredientsFilename: "test_ingredient_data")
    return IngredientSelectionView()
        .modelContainer(ingredientModelService.container)
}
