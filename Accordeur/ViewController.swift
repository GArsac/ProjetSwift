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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet private var noteChoice: UIPickerView!
    @IBOutlet private var accordChoice: UIPickerView!
    @IBOutlet private var audioInputPlot: EZAudioPlot!

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var referenceFrequencyChosen = 40000
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
        //Préparer les pickersView
        //Pour les notes
        self.noteChoice.delegate = self
        self.noteChoice.dataSource = self
        //Pour les accords
        self.accordChoice.delegate = self
        self.accordChoice.dataSource = self
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.output = silence
        AudioKit.start()
        Timer.scheduledTimer(timeInterval: 0.1,
                            target: self,
                             selector: #selector(ViewController.updateUI),
                             userInfo: nil,
                             repeats: true)
    }
    
    /*Fonction comparant la fréquence reçue par le smartphone par rapport à la fréquence de référence*/
    func compareFrequencies(referenceFrequency:Float,frequencyEmitted:Float)->Float{
        let difference :Float = (100 * frequencyEmitted)/referenceFrequency
        var angle :Float = 0
        if difference > 100 {
            angle = 90
        }
        if difference > 90 {
            angle = 120
        }
        if difference == 90 {
            angle = 0
        }
        if difference < 20{
            angle = -90
        }
        return angle
    }
    /*Met à jour l'aiguille*/
    @objc func updateUI() {
        print("Fréquence : \(tracker.frequency)")
        rotate(compareFrequencies(referenceFrequency: Float(referenceFrequencyChosen), frequencyEmitted: Float(tracker.frequency)))
    }
    
    /*Début partie sélection note et accord*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /*Renvoie le nombre de lignes*/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var valueNumberRows = noteNamesWithSharps.count
        if pickerView == noteChoice {
            valueNumberRows = 6
        }
        return valueNumberRows
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var data = noteNamesWithSharps[row]
        if pickerView == noteChoice{
            data = noteNamesWithFlats[row]
        }
        print("Data: \(data)")
        return data
    }
    /*Renvoie la ligne choisie*/
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == noteChoice {
            //TODO: Change la fréquence de référence pour la comparaison
            //(cf avec Guillaume pour utiliser sa classe et les fonctions)
        }
        if pickerView == accordChoice {
            //TODO:Faire la recherche et lié les boutons lançant les sons des cordes de la Guitare
        }
    }
    /*Fin partie sélection note et accord */
    
    /*Début partie rotation aiguille*/
    @IBOutlet weak var Aiguille: UIImageView!
    func rotate(_ degrees : Float){
        UIView.animate(withDuration: 1.0, animations: {
            self.Aiguille.transform = CGAffineTransform(rotationAngle: CGFloat(degrees))
            })
    }
    /*Fin partie rotation aiguille*/
}
