//
//  SoundResultsObserver.swift
//  Birdyy
//
//  Created by Selnekovic on 01/05/2022.
//

import Foundation
import SoundAnalysis

class SoundResultsObserver: NSObject, SNResultsObserving, ObservableObject {
    var value = ""
    
    func request(_ request: SNRequest, didProduce result: SNResult) {

        
        guard let result = result as? SNClassificationResult else  { return }

        guard let classification = result.classifications.first else { return }

        let confidence = classification.confidence * 100.0
        let percentString = String(format: "%.2f%%", confidence)

        print("\(classification.identifier): \(percentString) confidence.\n")
        value = "\(classification.identifier): \(percentString) confidence.\n"
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}

