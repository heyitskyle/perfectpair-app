import SwiftUI
import SwiftData

struct IngredientSelectionView: View {
    @EnvironmentObject var ingredientModelService: IngredientModelService
    @Binding var ingredientDataStatus: AppConfig.States
    @Binding var embeddingDataStatus: AppConfig.States
    
    @State private var searchbarText = ""
    @State private var showAllIngredients: Bool = false

    let pageTitle = "Let's find your perfect pair."
    let searchablePrompt = "Search over 6,000 ingredients…"
    enum showIngredientsText: String {
        case blocked = "Please wait for ingredient data to load."
        case ready = "Show All Ingredients"
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                Text(pageTitle)
                    .font(.title)
                if showAllIngredients == true {
                    Text("List")
                } else {
                    if ingredientDataStatus == AppConfig.States.complete {
                        Button(action: { showAllIngredients = true }, label: {
                            Text(showIngredientsText.ready.rawValue)
                        })
                    } else {
                        Text(showIngredientsText.blocked.rawValue)
                    }
                }
            }
        } detail: {
            Text("Perfect Pair")
        }
    }
}
