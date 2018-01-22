//
//  Tunning.swift
//  Accordeur
//
//  Created by Developer on 22/01/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

class Tuning {
    
    init(pTuning: [String: Double]) {
        Tuning = ["E2" : 82.41,
                  "A2" : 110.00,
                  "D3" : 146.83,
                  "G3" : 196.00,
                  "B3" : 246.94,
                  "E4" : 329.63]
        wavePath = "C://"
    }
    
    static var frequencesList = ["C" : 65.41,
                                 "C#" : 69.30,
                                 "D" : 73.42,
                                 "D#" : 77.78,
                                 "E" : 82.41,
                                 "F" : 87.31,
                                 "F#" : 92.50,
                                 "G" : 98.00,
                                 "G#" : 103.83,
                                 "A" : 110.00,
                                 "A#" : 116.54,
                                 "B" : 123.47]
    
    var Tuning: [String: Double]
    
    var wavePath: String
    
    static func getNoteFrequ(pNote: String, pOctave: Int) -> Double {
        return frequencesList[pNote]! * Double((pOctave-2)*(pOctave-2))
    }
}
