//
//  IngredientListView.swift
//  ThePerfectPair
//
//  Created by Kyle Lehmann on 4/23/24.
//

import SwiftUI

struct IngredientListView: View {
    @EnvironmentObject var ingredientModelContainer: IngredientModelContainer
    
    var body: some View {
        List(ingredientModelContainer.ingredients ?? [], id: \.id) { ingredient in
            NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                VStack(alignment: .leading) {
                    Text(ingredient.formattedName)
                }
            }
        }
    }
}

#Preview {
    let ingredientModelContainer = IngredientModelContainer()
    return IngredientListView()
        .modelContainer(ingredientModelContainer.container)

}
