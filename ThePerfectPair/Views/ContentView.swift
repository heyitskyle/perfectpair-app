import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var ingredientModelService: IngredientModelService
    @State private var errors: [AppConfig.ErrorLog] = []
    @State var ingredientDataStatus: AppConfig.States = .none
    @State var embeddingDataStatus: AppConfig.States = .none
    
    let buildMode: AppConfig.BuildMode
    
    var body: some View {
        IngredientSelectionView(ingredientDataStatus: $ingredientDataStatus, embeddingDataStatus: $embeddingDataStatus)
            .task {
                do {
                    ingredientDataStatus = .running
                    try await ingredientModelService.populateFromJSON(model: .ingredients, buildMode: buildMode)
                    ingredientDataStatus = .complete
                } catch {
                    ingredientDataStatus = .blocked
                    errors.append(AppConfig.ErrorLog(error: error, code: 101))
                }
                do {
                    embeddingDataStatus = .running
                    try await ingredientModelService.populateFromJSON(model: .embeddings, buildMode: buildMode)
                } catch {
                    embeddingDataStatus = .blocked
                    errors.append(AppConfig.ErrorLog(error: error, code: 102))
                }
            }
    }
}

#Preview {
    return ContentView(buildMode: .debug)
        .environmentObject(IngredientModelService())
}
