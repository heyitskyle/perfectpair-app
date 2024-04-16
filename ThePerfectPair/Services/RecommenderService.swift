import CoreML
import Foundation

class RecommenderService {
    private var model: PairModel?
    private var embeddings: MLMultiArray?
    private var ids: MLMultiArray?

    init() {
        do {
            model = try PairModel(configuration: .init())
        } catch {
            print("Failed to initialize PairModel: \(error.localizedDescription)")
        }
    }
    
    func loadEmbeddings(embeddingsArray: [Double], idsArray: [Int]) {
        do {
            embeddings = try convertArrayToMLMultiArray(embeddingsArray)
            ids = try convertArrayToMLMultiArray(idsArray)
        } catch {
            print()
        }
    }

    func getSimilarIngredients(selectedId: Int, numResults: Int) -> ([Int], [Double]) {
        do {
            guard let embeddings = embeddings, let ids = ids else {
                print("Error loading embedding information.")
                return ([],[])
            }
            
            let selectedIdArray = try convertArrayToMLMultiArray([selectedId])
            let numResultsArray = try convertArrayToMLMultiArray([numResults])

            let input = PairModelInput(
                embeddings: embeddings,
                ingredient_ids: ids,
                selected_ingredient_id: selectedIdArray,
                num_results: numResultsArray
            )

            if let results = try model?.prediction(input: input) {
                let ids = convertMLMultiArrayToIntArray(results.similar_ingredient_ids)
                let scores = convertMLMultiArrayToDoubleArray(results.similarity_scores)
                return (ids, scores)
            } else {
                print("Failed to run PAIR model.")
            }
        } catch {
            print("Error in model prediction: \(error.localizedDescription)")
        }
        return ([], [])
    }

    private func convertMLMultiArrayToIntArray(_ mlArray: MLMultiArray) -> [Int] {
        let count = mlArray.count
        var array = [Int](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = Int(truncating: mlArray[i])
        }
        return array
    }

    private func convertMLMultiArrayToDoubleArray(_ mlArray: MLMultiArray) -> [Double] {
        let count = mlArray.count
        var array = [Double](repeating: 0, count: count)
        for i in 0..<count {
            array[i] = Double(truncating: mlArray[i])
        }
        return array
    }

    private func convertArrayToMLMultiArray<T: Numeric>(_ array: [T]) throws -> MLMultiArray {
        let dataType: MLMultiArrayDataType = T.self == Double.self ? .double : .int32
        let multiArray = try MLMultiArray(shape: [NSNumber(value: array.count)], dataType: dataType)
        for (index, element) in array.enumerated() {
            multiArray[index] = NSNumber(value: element.toDouble)
        }
        return multiArray
    }
}

private extension Numeric {
    var toDouble: Double {
        return Double(truncating: self as? NSNumber ?? 0)
    }
}
