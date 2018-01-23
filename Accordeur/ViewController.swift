//
//  ViewController.swift
//  MicrophoneAnalysis
//
//  Created by Kanstantsin Linou on 6/9/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

class ViewController: UIViewController {
    

    @IBOutlet private var noteChoice: UIPickerView!
    @IBOutlet private var accordChoice: UIPickerView!
    @IBOutlet private var noteNameWithSharpsLabel: UILabel!
    @IBOutlet private var noteNameWithFlatsLabel: UILabel!
    @IBOutlet private var audioInputPlot: EZAudioPlot!

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!

    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    func setupPlot() {
        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AudioKit.output = silence
        AudioKit.start()
        //setupPlot()
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    
    func compareFrequencies(referenceFrequency:Float,frequencyEmitted:Float)->Float{
        var difference :Float = (100 * frequencyEmitted)/referenceFrequency
        var angle :Float = 0
        if difference > 100 {
            angle = -90
        }
        if difference > 90 {
            angle = -120
        }
        if difference == 90 {
            angle = 0
        }
        if difference == 90{
            angle = 90
        }
        return angle
    }
    
    @objc func updateUI() {
        rotate(compareFrequencies(referenceFrequency: 30000, frequencyEmitted: Float(tracker.frequency)))
    }
    
    /*Début partie rotation aiguille*/
    @IBOutlet weak var Aiguille: UIImageView!
    
    func rotate(_ degrees : Float){
        
        UIView.animate(withDuration: 1.0, animations: {
            self.Aiguille.transform = CGAffineTransform(rotationAngle: CGFloat(degrees))
            })
    }
    /*Fin partie rotation aiguille*/
}
