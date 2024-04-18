import CoreML
import Foundation

class PairModelService {
    internal var model: PairModel?
    internal var embeddings: MLMultiArray?
    internal var ids: MLMultiArray?
    
    // Logging the last system error for debugging
    var lastSystemError: Error?

    init() {
        do {
            // Initialize the CoreML model
            model = try PairModel(configuration: .init())
        } catch {
            lastSystemError = error
            print("Failed to initialize PairModel: \(error.localizedDescription)")
        }
    }
    
    // Function to load the embeddings and ids into the model
    func loadEmbeddings(embeddingsArray: [Double], idsArray: [Int]) {
        do {
            // Convert the arrays to MLMultiArrays
            embeddings = try convertArrayToMLMultiArray(embeddingsArray)
            ids = try convertArrayToMLMultiArray(idsArray)
        } catch {
            print("Failed to load embeddings.")
        }
    }

    // Function to get similar ingredients based on the selected ingredient
    func getSimilarIngredients(selectedId: Int, numResults: Int) -> ([Int], [Double]) {
        do {
            // Check if the embeddings and ids are loaded
            guard let embeddings = self.embeddings, let ids = self.ids else {
                lastSystemError = NSError(domain: "PairModelService", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Embedding information not loaded"])
                return ([],[])
            }
            
            // Convert the selectedId and numResults to MLMultiArrays
            let selectedIdArray = try convertArrayToMLMultiArray([selectedId])
            let numResultsArray = try convertArrayToMLMultiArray([numResults])

            // Create the input for the model
            let input = PairModelInput(
                embeddings: embeddings,
                ingredient_ids: ids,
                selected_ingredient_id: selectedIdArray,
                num_results: numResultsArray
            )

            // Run the model
            if let results = try model?.prediction(input: input) {
                let ids = convertMLMultiArrayToIntArray(results.similar_ingredient_ids)
                let scores = convertMLMultiArrayToDoubleArray(results.similarity_scores)
                return (ids, scores)
            } else {
                lastSystemError = NSError(domain: "PairModelService", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Model failed to run prediction"])
            }
        } catch let error as NSError {
            lastSystemError = error
            //lastSystemError = NSError(domain: "PairModelService", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Model prediction failed"])
        }
        return ([], [])
    }

    // Function to convert MLMultiArray to Int array
    private func convertMLMultiArrayToIntArray(_ mlArray: MLMultiArray) -> [Int] {
        let count = mlArray.count
        var array = [Int](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = Int(truncating: mlArray[i])
        }
        return array
    }

    // Function to convert MLMultiArray to Double array
    private func convertMLMultiArrayToDoubleArray(_ mlArray: MLMultiArray) -> [Double] {
        let count = mlArray.count
        var array = [Double](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = Double(truncating: mlArray[i])
        }
        return array
    }

    // Function to convert an array to MLMultiArray
    private func convertArrayToMLMultiArray<T: Numeric>(_ array: [T]) throws -> MLMultiArray {
        let dataType: MLMultiArrayDataType = T.self == Double.self ? .double : .int32
        let multiArray = try MLMultiArray(shape: [NSNumber(value: array.count)], dataType: dataType)
        for (index, element) in array.enumerated() {
            multiArray[index] = NSNumber(value: element.toDouble)
        }
        return multiArray
    }
}

// Extension to convert Numeric to Double for the MLMultiArray
private extension Numeric {
    var toDouble: Double {
        return Double(truncating: self as? NSNumber ?? 0)
    }
}
