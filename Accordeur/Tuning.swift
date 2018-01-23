//
//  Tuning.swift
//  Accordeur
//
//  Created by Developer on 15/01/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}

class Tuning {
    
    init(pTuning: [String: Double]) {
        CurrentTuning = ["E2" : 82.41,
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
    
    var CurrentTuning: [String: Double]
    
    var wavePath: String
    
    static func getNoteFrequ(pNote: String, pOctave: Int) -> Double {
        return frequencesList[pNote]! * Double(truncating: pow(2, pOctave-2) as NSNumber)
    }
    
    static func getNoteFrequV2(pNote: String) -> Double {
        print("La note")
        print(pNote)
        let pNotelol = " " + pNote
        let pNotelol2 = pNote
        let lolenculé = pNote.endIndex
        let charactere = pNotelol[lolenculé]
        let chaine = String(describing: charactere)
        let octave = Double(chaine)
        return frequencesList[pNotelol2.dropLast()]! * Double(truncating: pow(2, octave! - 2) as NSNumber)
    }
}
