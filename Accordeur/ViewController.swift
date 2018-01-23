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

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet private var noteChoice: UIPickerView!
    @IBOutlet private var accordChoice: UIPickerView!
    @IBOutlet private var audioInputPlot: EZAudioPlot!
    
    @IBAction func produceSound(_ sender: Any) {
        
    }
    let listeAccords:[String] = ["E3 A2 E2 G3 B3 E4","C#3 G#2 D#2 F#3 A#3 D#4","D2 A2 E2 G3 B3 E4","D2 G2 C3 F3 A3 D4"]
    let listNotes:[String] = ["E3","A2","E2","G3","B3","E4","C#3","C#3","G#2","D#2","F#3","A#3","D#4","D2","A2","E2","G3","B3","E4","D2","G2","C3","F3","A3","D4"]
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var listeNote : [String] = []
    var referenceFrequencyChosen : Double = 110
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    var valueToProduce : String = ""
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
        noteChoice.delegate = self
        noteChoice.dataSource = self
        //Pour les accords
        accordChoice.delegate = self
        accordChoice.dataSource = self
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
        print("Fréquence de référence: \(referenceFrequency)")
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
        //print("Fréquence : \(tracker.frequency)")
        rotate(compareFrequencies(referenceFrequency: Float(referenceFrequencyChosen), frequencyEmitted: Float(tracker.frequency)))
    }
    
    /*Début partie sélection note et accord*/
    
    /****************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == noteChoice {
            return listNotes.count
        }
        return listeAccords.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //self.noteChoice.reloadAllComponents()
        if pickerView == noteChoice {
            return listNotes[row]
        }
        return listeAccords[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let value = listeAccords[row]
        //print(listNotes[row])
        
        referenceFrequencyChosen = Tuning.getNoteFrequV2(pNote:listNotes[row])
        self.valueToProduce = listNotes[row]
    }
    /*******************/
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
