//
//  File.swift
//  Birdyy
//
//  Created by Selnekovic on 01/05/2022.
//

import Foundation
import AVFAudio
import SoundAnalysis

class Classification: ObservableObject {
    let birdy = Birdyy()
    
    let audioEngine: AVAudioEngine = AVAudioEngine()
    let inputBus: AVAudioNodeBus = AVAudioNodeBus(0)
    var inputFormat: AVAudioFormat!
    var streamAnalyzer: SNAudioStreamAnalyzer!
    let resultsObserver = SoundResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    private var timer: Timer! = nil
    
    @Published var value = ""
    
    
    func start() {
        inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)

        do {
            try audioEngine.start()

            audioEngine.inputNode.installTap(onBus: inputBus,
                                             bufferSize: 8192,
                                             format: inputFormat, block: analyzeAudio(buffer:at:))

            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)

            let request = try SNClassifySoundRequest(mlModel: birdy.model)

            try streamAnalyzer.add(request,
                                   withObserver: resultsObserver) 


        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }

    }

    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer,
                                        atAudioFramePosition: time.sampleTime)
        }
    }
    
    func getValue(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
           
                value = resultsObserver.value
                
        }
    }
}

