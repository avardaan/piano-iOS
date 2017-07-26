//
//  ViewController.swift
//  Piano
//
//  Created by Vardaan Aashish on 2/8/17.
//  Copyright © 2017 Vardaan. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds


// MULTI THREADING
//

class ViewController: UIViewController
{
    
    
    // array of sustained piano sounds
    var sustainSounds = ["C1s", "C#1s", "D1s", "D#1s", "E1s", "F1s", "F#1s", "G1s", "G#1s", "A1s", "A#1s", "B1s", "C2s", "C#2s", "D2s", "D#2s", "E2s", "F2s", "F#2s", "G2s", "G#2s", "A2s", "A#2s", "B2s", "C3s", "C#3s", "D3s", "D#3s", "E3s", "F3s", "F#3s", "G3s", "G#3s", "A3s", "A#3s", "B3s", "C4s", "C#4s", "D4s", "D#4s", "E4s", "F4s", "F#4s", "G4s", "G#4s", "A4s", "A#4s", "B4s", "C5s", "C#5s", "D5s", "D#5s", "E5s", "F5s", "F#5s", "G5s", "G#5s", "A5s", "A#5s", "B5s", "C6s", "C#6s", "D6s", "D#6s", "E6s", "F6s", "F#6s", "G6s", "G#6s"]
    
    // array of sustained piano sounds
    var pianoSounds = ["C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5", "C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6"]
    
    
    // initialize empty audio array
    var soundsArray = [AVAudioPlayer]()
    
    // variable for single
    
    // audio players to use for arpeggio and chord
    var root = AVAudioPlayer()
    var third = AVAudioPlayer()
    var fifth = AVAudioPlayer()
    var root2 = AVAudioPlayer()
    var third2 = AVAudioPlayer()
    var fifth2 = AVAudioPlayer()
    
    
    
    
    // KEY LABEL OUTLETS
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var cs1: UIButton!
    @IBOutlet weak var d1: UIButton!
    @IBOutlet weak var ds1: UIButton!
    @IBOutlet weak var e1: UIButton!
    @IBOutlet weak var f1: UIButton!
    @IBOutlet weak var fs1: UIButton!
    @IBOutlet weak var g1: UIButton!
    @IBOutlet weak var gs1: UIButton!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var as1: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var cs2: UIButton!
    @IBOutlet weak var d2: UIButton!
    @IBOutlet weak var ds2: UIButton!
    @IBOutlet weak var e2: UIButton!
    @IBOutlet weak var f2: UIButton!
    @IBOutlet weak var fs2: UIButton!
    @IBOutlet weak var g2: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var as2: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var gs2: UIButton!
    
    
    // NOTE LABEL OUTLETS
    @IBOutlet weak var c1l: UILabel!
    @IBOutlet weak var d1l: UILabel!
    @IBOutlet weak var e1l: UILabel!
    @IBOutlet weak var f1l: UILabel!
    @IBOutlet weak var g1l: UILabel!
    @IBOutlet weak var a1l: UILabel!
    @IBOutlet weak var b1l: UILabel!
    @IBOutlet weak var c2l: UILabel!
    @IBOutlet weak var d2l: UILabel!
    @IBOutlet weak var e2l: UILabel!
    @IBOutlet weak var f2l: UILabel!
    @IBOutlet weak var g2l: UILabel!
    @IBOutlet weak var a2l: UILabel!
    @IBOutlet weak var b2l: UILabel!
    
    
    
    @IBOutlet var buttons: [UIButton]!
    
    
    
    // outlet for chord toggle
    @IBOutlet weak var typeButton: UIButton!
    
    // toggle major/minor with type button
    @IBAction func typeButton(_ sender: UIButton)
    {
        if (sender.title(for: .normal) == "Major")
        { sender.setTitle("Minor", for: .normal) }
        else
        { sender.setTitle("Major", for: .normal) }
        
        chordType = sender.title(for: .normal)!
        
    }
    
    
    // BANNER AD OUTLET
    @IBOutlet weak var bannerAD: GADBannerView!
    
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        // set up AD
        let request = GADRequest()
        
        // simulator ID
        request.testDevices = ["bbf8bd30c2e03138a77c845414c85e02"]
        
        bannerAD.adUnitID = "ca-app-pub-7144250879516193/7928827664"
        bannerAD.rootViewController = self
        bannerAD.load(request)
        
        // set chord toggle to settings value
        typeButton.setTitle(chordType, for: .normal)
        typeButton.layer.masksToBounds = true
        typeButton.layer.cornerRadius = CGFloat(11)
        
        // round labels
        roundLabels()
        
        // remember octave
        octaveHandler(stepperat: octave)
        
        // highlight appropriate key, if any
        highlighter()
        
        // mute notes off key, if required
        muter()
        
        // hide chord toggle if chord/arpeggio is off
        hideChordToggle()
        
        // load sustain notes into soundsArray
        noteLoader()
        
        do
        { try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback) }
        catch
        { // report for an error 
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //@IBOutlet weak var topCarpet: UIImageView!
    
    // stepper pressed
    @IBAction func octaveStepper(_ sender: UIStepper)
    {
        octaveHandler(stepperat: Int(sender.value))
        highlighter()
        // push value into global variable to remember when coming back from settings
        octave = Int(sender.value)
        
    }
    
    // key press on keyboard
    @IBAction func pressC1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
        // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
        // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
        // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
        note.setVolume(3.0, fadeDuration: 1.0)
        note.play()
        }
        // if play chord is on, play chord
        else if (playChord == "on")
        {
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressCsharp1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    
    @IBAction func pressD1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }

    
    @IBAction func pressDsharp1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    
    @IBAction func pressE1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressF1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressFsharp1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressG1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }

    
    
    @IBAction func pressGsharp1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressA1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressAsharp1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressB1(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressC2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressCsharp2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    
    @IBAction func pressD2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressDsharp2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    
    @IBAction func pressE2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressF2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressFsharp2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }

    
    
    @IBAction func pressG2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressGsharp2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressA2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    
    @IBAction func pressAsharp2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    @IBAction func pressB2(_ sender: UIButton)
    {
        // assign index to variable in order to manipulate it later
        var begin = sender.tag
        
        // if first octave, retain tag as index
        if c1l.text == "C1"
        { begin = sender.tag }
            // if second octave, skip 12 indices in sounds array
        else if c1l.text == "C2"
        { begin = sender.tag + 12 }
            // if third octave,skip 24 indices in sounds array
        else if c1l.text == "C3"
        { begin = sender.tag + 24 }
            // if fourth octave, skip 36 indices in sounds array
        else // if c1l.text == "C4"
        { begin = sender.tag + 36 }
        
        // let the note be soundsArray[appropriate index from above]
        let note = soundsArray[begin]
        
        // play chord is off, just play note
        if (playChord == "off" && arpeggiate == "off")
        {
            note.currentTime = 0
            note.setVolume(3.0, fadeDuration: 1.0)
            note.play()
        }
            // if play chord is on, play chord
        else if (playChord == "on")
        {
            note.currentTime = 0
            // initialize chord function with appropriate tag
            chord(tag: begin)
        }
        else // arpeggio = on
        {
            note.currentTime = 0
            // initialize arpeggio function with appropriate tag
            arpeggiator(tag: begin)
        }
    }
    
    // CUSTOM FUNCTIONS
    
    
    
    func noteLoader()
    {
        //if (sustain == "on")
        //{
            // sounds load up. for every note in pianoSounds, load into app.
            for note in sustainSounds
            {
                do
                {
                    // create url for the sound using it's name from the array
                    let url = URL(fileURLWithPath: Bundle.main.path(forResource: note, ofType: "mp3")!)
                    // assign that sound to audioPlayer
                    let pianoNote = try AVAudioPlayer(contentsOf: url)
                    // add this audioPlayer to the array of ACTUAL SOUNDS in order because LOOP
                    soundsArray.append(pianoNote)
                    // preloads buffers, minimizes hardware delay
                    pianoNote.prepareToPlay()
                }
                
                // catch errors
                catch
                { // insert empty audio to avoid misplacement
                    soundsArray.append(AVAudioPlayer())
                }
            }
        //}
        
        /*
        else // sustain == off
        {
            // sounds load up. for every note in pianoSounds, load into app.
            for note in pianoSounds
            {
                do
                {
                    // create url for the sound using it's name from the array
                    let url = URL(fileURLWithPath: Bundle.main.path(forResource: note, ofType: "mp3")!)
                    // assign that sound to audioPlayer
                    let pianoNote = try AVAudioPlayer(contentsOf: url)
                    // add this audioPlayer to the array of ACTUAL SOUNDS in order because LOOP
                    soundsArray.append(pianoNote)
                    // preloads buffers, minimizes hardware delay
                    pianoNote.prepareToPlay()
                }
                    
                    // catch errors
                catch
                { // insert empty audio to avoid misplacement
                    soundsArray.append(AVAudioPlayer())
                }
            }

        }
        */
        
    }
    
    // function to implement chord playing
    func chord(tag: Int)
    {
        // get root note and fifth from sounds array
        root = soundsArray[tag]
        fifth = soundsArray[tag + 7]
        
        if chordType == "Major"
        {
            // get MAJOR third
            third = soundsArray[tag + 4]
            
            // override old chord for new chord
            if (root.isPlaying || third.isPlaying || fifth.isPlaying)
            {
                root.stop()
                root.currentTime = 0.0
                third.stop()
                third.currentTime = 0.0
                fifth.stop()
                fifth.currentTime = 0.0
            }
            
            // play chord
            root.play()
            third.play(atTime: root.deviceCurrentTime)
            fifth.play(atTime: root.deviceCurrentTime)
        }
            
        else // if chordType == "Minor"
        {
            // get MINOR third
            third = soundsArray[tag + 3]
            // override old chord for new chord
            if (root.isPlaying || third.isPlaying || fifth.isPlaying)
            {
                root.stop()
                root.currentTime = 0.0
                third.stop()
                third.currentTime = 0.0
                fifth.stop()
                fifth.currentTime = 0.0
            }
            
            // play chord
            root.play()
            third.play(atTime: root.deviceCurrentTime)
            fifth.play(atTime: root.deviceCurrentTime)
        }
    }
    
    
    /*
    // alternate implementation URGGGHHH
    func arpeggiator(tag: Int)
    {
        let arpeggio: [AVAudioPlayer] = [ soundsArray[tag], soundsArray[tag+3], soundsArray[tag+4], soundsArray[tag+7]  ]
        
        for sound in arpeggio
        { sound.prepareToPlay() }
        
        if chordType == "Major"
        {
            arpeggio[0].play()
            arpeggio[2].play(atTime: arpeggio[0].deviceCurrentTime + arpInterval)
            arpeggio[3].play(atTime: arpeggio[0].deviceCurrentTime + (2*arpInterval))
        }
        
        else // if chord minor
        {
            arpeggio[0].play()
            arpeggio[1].play(atTime: arpeggio[0].deviceCurrentTime + arpInterval)
            arpeggio[3].play(atTime: arpeggio[0].deviceCurrentTime + (2*arpInterval))
        }
        
    }
    */
    
    
    // function to stop all notes
    func noteStopper()
    {
        // if any of these notes are playing, stop them
        if ((arpRange == 6) && (root.isPlaying || third.isPlaying || fifth.isPlaying || root2.isPlaying || third2.isPlaying || fifth2.isPlaying))
        {
            root.stop()
            root.currentTime = 0.0
            third.stop()
            third.currentTime = 0.0
            fifth.stop()
            fifth.currentTime = 0.0
            
            root2.stop()
            root2.currentTime = 0.0
            third2.stop()
            third2.currentTime = 0.0
            fifth2.stop()
            fifth2.currentTime = 0.0
            
        }
        
        // arpRange is 3 so only stop root, third and fith
        else if (root.isPlaying || third.isPlaying || fifth.isPlaying) {
            root.stop()
            root.currentTime = 0.0
            third.stop()
            third.currentTime = 0.0
            fifth.stop()
            fifth.currentTime = 0.0
        }

    }
    
    // function to implement arpeggio
    func arpeggiator(tag: Int)
    {
        // get root note and fifth from sounds array
        root = soundsArray[tag]
        fifth = soundsArray[tag + 7]
        root2 = soundsArray[tag + 12]
        fifth2 = soundsArray[tag + 7 + 12]
        
        if (arpRange == 3)
        {
            if chordType == "Major"
            {
                // get MAJOR third
                third = soundsArray[tag + 4]
                // override old arpeggio for new arpeggio
                noteStopper()
                // play arpeggio
                root.play()
                third.play(atTime: root.deviceCurrentTime + arpInterval)
                fifth.play(atTime: root.deviceCurrentTime + (2*arpInterval))
            }
            
            else // if chordType == "Minor"
            {
                // get MINOR third
                third = soundsArray[tag + 3]
                // override old arpeggio for new arpeggio
                noteStopper()
                // play arpeggio
                root.play()
                third.play(atTime: root.deviceCurrentTime + arpInterval)
                fifth.play(atTime: root.deviceCurrentTime + (2*arpInterval))
            }
        }
        
        else // arpRange is 6
        {
            if chordType == "Major"
            {
                // get MAJOR third
                third = soundsArray[tag + 4]
                third2 = soundsArray[tag + 4 + 12]
                // override old arpeggio for new arpeggio
                noteStopper()
                // play arpeggio
                root.play()
                third.play(atTime: root.deviceCurrentTime + arpInterval)
                fifth.play(atTime: root.deviceCurrentTime + (2*arpInterval))
                root2.play(atTime: root.deviceCurrentTime + (3*arpInterval))
                third2.play(atTime: root.deviceCurrentTime + (4*arpInterval))
                fifth2.play(atTime: root.deviceCurrentTime + (5*arpInterval))
                
            }
                
            else // if chordType == "Minor"
            {
                // get MINOR third
                third = soundsArray[tag + 3]
                third2 = soundsArray[tag + 3 + 12]
                // override old arpeggio for new arpeggio
                noteStopper()
                // play arpeggio
                root.play()
                third.play(atTime: root.deviceCurrentTime + arpInterval)
                fifth.play(atTime: root.deviceCurrentTime + (2*arpInterval))
                root2.play(atTime: root.deviceCurrentTime + (3*arpInterval))
                third2.play(atTime: root.deviceCurrentTime + (4*arpInterval))
                fifth2.play(atTime: root.deviceCurrentTime + (5*arpInterval))
            }
        }
    }
 
    
    // this functions rounds the corners of the label before the view appears on screen
    // used in viewDidLoad
    func roundLabels()
    {
        // radius of the label corners
        let radius = CGFloat(11)
        
        c1l.layer.masksToBounds = true
        c1l.layer.cornerRadius = radius
        
        d1l.layer.masksToBounds = true
        d1l.layer.cornerRadius = radius
        
        e1l.layer.masksToBounds = true
        e1l.layer.cornerRadius = radius
        
        f1l.layer.masksToBounds = true
        f1l.layer.cornerRadius = radius
        
        g1l.layer.masksToBounds = true
        g1l.layer.cornerRadius = radius
        
        a1l.layer.masksToBounds = true
        a1l.layer.cornerRadius = radius
        
        b1l.layer.masksToBounds = true
        b1l.layer.cornerRadius = radius
        
        c2l.layer.masksToBounds = true
        c2l.layer.cornerRadius = radius
        
        d2l.layer.masksToBounds = true
        d2l.layer.cornerRadius = radius
        
        e2l.layer.masksToBounds = true
        e2l.layer.cornerRadius = radius
        
        f2l.layer.masksToBounds = true
        f2l.layer.cornerRadius = radius
        
        g2l.layer.masksToBounds = true
        g2l.layer.cornerRadius = radius
        
        a2l.layer.masksToBounds = true
        a2l.layer.cornerRadius = radius
        
        b2l.layer.masksToBounds = true
        b2l.layer.cornerRadius = radius
    }
    
    // function for the octave stepper
    func octaveHandler(stepperat: Int)
    {
        // common alpha for all labels, and colors corresponding to octaves
        let noteLabelAlpha = CGFloat(0.6)
        let c1Color = UIColor.red
        let c2Color = UIColor.yellow
        let c3Color = UIColor.green
        let c4Color = UIColor.orange
        let c5Color = UIColor.cyan
        
        // at 0, we have octaves 1 and 2
        if (stepperat == 0)
        {
            c1l.backgroundColor = c1Color
            c1l.text = "C1"
            c1l.alpha = noteLabelAlpha 
            d1l.backgroundColor = c1Color
            d1l.text = "D1"
            d1l.alpha = noteLabelAlpha 
            e1l.backgroundColor = c1Color
            e1l.text = "E1"
            e1l.alpha = noteLabelAlpha 
            f1l.backgroundColor = c1Color
            f1l.text = "F1"
            f1l.alpha = noteLabelAlpha 
            g1l.backgroundColor = c1Color
            g1l.text = "G1"
            g1l.alpha = noteLabelAlpha 
            a1l.backgroundColor = c1Color
            a1l.text = "A1"
            a1l.alpha = noteLabelAlpha 
            b1l.backgroundColor = c1Color
            b1l.text = "B1"
            b1l.alpha = noteLabelAlpha 
            
            c2l.backgroundColor = c2Color
            c2l.text = "C2"
            c2l.alpha = noteLabelAlpha 
            d2l.backgroundColor = c2Color
            d2l.text = "D2"
            d2l.alpha = noteLabelAlpha 
            e2l.backgroundColor = c2Color
            e2l.text = "E2"
            e2l.alpha = noteLabelAlpha 
            f2l.backgroundColor = c2Color
            f2l.text = "F2"
            f2l.alpha = noteLabelAlpha 
            g2l.backgroundColor = c2Color
            g2l.text = "G2"
            g2l.alpha = noteLabelAlpha 
            a2l.backgroundColor = c2Color
            a2l.text = "A2"
            a2l.alpha = noteLabelAlpha 
            b2l.backgroundColor = c2Color
            b2l.text = "B2"
            b2l.alpha = noteLabelAlpha 
        }
         
        // at 1, we have octaves 2 and 3
        else if (stepperat == 1)
        {
            c1l.backgroundColor = c2Color
            c1l.text = "C2"
            c1l.alpha = noteLabelAlpha 
            d1l.backgroundColor = c2Color
            d1l.text = "D2"
            d1l.alpha = noteLabelAlpha 
            e1l.backgroundColor = c2Color
            e1l.text = "E2"
            e1l.alpha = noteLabelAlpha 
            f1l.backgroundColor = c2Color
            f1l.text = "F2"
            f1l.alpha = noteLabelAlpha 
            g1l.backgroundColor = c2Color
            g1l.text = "G2"
            g1l.alpha = noteLabelAlpha 
            a1l.backgroundColor = c2Color
            a1l.text = "A2"
            a1l.alpha = noteLabelAlpha 
            b1l.backgroundColor = c2Color
            b1l.text = "B2"
            b1l.alpha = noteLabelAlpha 
            
            c2l.backgroundColor = c3Color
            c2l.text = "C3"
            c2l.alpha = noteLabelAlpha 
            d2l.backgroundColor = c3Color
            d2l.text = "D3"
            d2l.alpha = noteLabelAlpha 
            e2l.backgroundColor = c3Color
            e2l.text = "E3"
            e2l.alpha = noteLabelAlpha 
            f2l.backgroundColor = c3Color
            f2l.text = "F3"
            f2l.alpha = noteLabelAlpha 
            g2l.backgroundColor = c3Color
            g2l.text = "G3"
            g2l.alpha = noteLabelAlpha 
            a2l.backgroundColor = c3Color
            a2l.text = "A3"
            a2l.alpha = noteLabelAlpha 
            b2l.backgroundColor = c3Color
            b2l.text = "B3"
            b2l.alpha = noteLabelAlpha 
        }
        
        // at 2, we have octaves 3 and 4
        else if (stepperat == 2)
        {
            c1l.backgroundColor = c3Color
            c1l.text = "C3"
            c1l.alpha = noteLabelAlpha 
            d1l.backgroundColor = c3Color
            d1l.text = "D3"
            d1l.alpha = noteLabelAlpha 
            e1l.backgroundColor = c3Color
            e1l.text = "E3"
            e1l.alpha = noteLabelAlpha 
            f1l.backgroundColor = c3Color
            f1l.text = "F3"
            f1l.alpha = noteLabelAlpha 
            g1l.backgroundColor = c3Color
            g1l.text = "G3"
            g1l.alpha = noteLabelAlpha 
            a1l.backgroundColor = c3Color
            a1l.text = "A3"
            a1l.alpha = noteLabelAlpha 
            b1l.backgroundColor = c3Color
            b1l.text = "B3"
            b1l.alpha = noteLabelAlpha 
            
            c2l.backgroundColor = c4Color
            c2l.text = "C4"
            c2l.alpha = noteLabelAlpha 
            d2l.backgroundColor = c4Color
            d2l.text = "D4"
            d2l.alpha = noteLabelAlpha 
            e2l.backgroundColor = c4Color
            e2l.text = "E4"
            e2l.alpha = noteLabelAlpha 
            f2l.backgroundColor = c4Color
            f2l.text = "F4"
            f2l.alpha = noteLabelAlpha 
            g2l.backgroundColor = c4Color
            g2l.text = "G4"
            g2l.alpha = noteLabelAlpha 
            a2l.backgroundColor = c4Color
            a2l.text = "A4"
            a2l.alpha = noteLabelAlpha 
            b2l.backgroundColor = c4Color
            b2l.text = "B4"
            b2l.alpha = noteLabelAlpha 
        }
        
        // at 3, we have octaves 4 and 5
        else // stepperat == 3
        {
            c1l.backgroundColor = c4Color
            c1l.text = "C4"
            c1l.alpha = noteLabelAlpha 
            d1l.backgroundColor = c4Color
            d1l.text = "D4"
            d1l.alpha = noteLabelAlpha 
            e1l.backgroundColor = c4Color
            e1l.text = "E4"
            e1l.alpha = noteLabelAlpha 
            f1l.backgroundColor = c4Color
            f1l.text = "F4"
            f1l.alpha = noteLabelAlpha 
            g1l.backgroundColor = c4Color
            g1l.text = "G4"
            g1l.alpha = noteLabelAlpha 
            a1l.backgroundColor = c4Color
            a1l.text = "A4"
            a1l.alpha = noteLabelAlpha 
            b1l.backgroundColor = c4Color
            b1l.text = "B4"
            b1l.alpha = noteLabelAlpha 
            
            c2l.backgroundColor = c5Color
            c2l.text = "C5"
            c2l.alpha = noteLabelAlpha 
            d2l.backgroundColor = c5Color
            d2l.text = "D5"
            d2l.alpha = noteLabelAlpha 
            e2l.backgroundColor = c5Color
            e2l.text = "E5"
            e2l.alpha = noteLabelAlpha 
            f2l.backgroundColor = c5Color
            f2l.text = "F5"
            f2l.alpha = noteLabelAlpha 
            g2l.backgroundColor = c5Color
            g2l.text = "G5"
            g2l.alpha = noteLabelAlpha 
            a2l.backgroundColor = c5Color
            a2l.text = "A5"
            a2l.alpha = noteLabelAlpha 
            b2l.backgroundColor = c5Color
            b2l.text = "B5"
            b2l.alpha = noteLabelAlpha 
        }
        
        
    }
    
    // hide off key notes
    func highlighter()
    {
        // common alpha for off key BUTTONS
        var offKeyButtonAlpha = CGFloat(0.02)
        if hideNotes == "Dim" { offKeyButtonAlpha = CGFloat(0.5) }
        if hideNotes == "Hide" { offKeyButtonAlpha = CGFloat(0.02) }
        // common alpha for off key LABELS
        let offKeyLabelAlpha = CGFloat(0)
        
        if (hideNotes == "Dim" || hideNotes == "Hide")
        {
            // CHANGE BACKGROUND SO BLACK KEYS ARE VISIBLE
            self.view.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
            // HIde top carpet
            //topCarpet.alpha = 0.0
            
            // handle off-alpha note alphas
            if (hlKey == "C/Am")
            {
                cs1.alpha = offKeyButtonAlpha
                ds1.alpha = offKeyButtonAlpha
                fs1.alpha = offKeyButtonAlpha
                gs1.alpha = offKeyButtonAlpha
                as1.alpha = offKeyButtonAlpha
                cs2.alpha = offKeyButtonAlpha
                ds2.alpha = offKeyButtonAlpha
                fs2.alpha = offKeyButtonAlpha
                gs2.alpha = offKeyButtonAlpha
                as2.alpha = offKeyButtonAlpha
            }
                
            else if (hlKey == "C#/Bbm/A#m")
            {
                d1.alpha = offKeyButtonAlpha
                d1l.alpha = offKeyLabelAlpha
                
                e1.alpha = offKeyButtonAlpha
                e1l.alpha = offKeyLabelAlpha
                
                g1.alpha = offKeyButtonAlpha
                g1l.alpha = offKeyLabelAlpha
                
                a1.alpha = offKeyButtonAlpha
                a1l.alpha = offKeyLabelAlpha
                
                b1.alpha = offKeyButtonAlpha
                b1l.alpha = offKeyLabelAlpha
                
                d2.alpha = offKeyButtonAlpha
                d2l.alpha = offKeyLabelAlpha
                
                e2.alpha = offKeyButtonAlpha
                e2l.alpha = offKeyLabelAlpha
                
                g2.alpha = offKeyButtonAlpha
                g2l.alpha = offKeyLabelAlpha
                
                a2.alpha = offKeyButtonAlpha
                a2l.alpha = offKeyLabelAlpha
                
                b2.alpha = offKeyButtonAlpha
                b2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "D/Bm")
            {
                ds1.alpha = offKeyButtonAlpha
                
                f1.alpha = offKeyButtonAlpha
                f1l.alpha = offKeyLabelAlpha
                
                gs1.alpha = offKeyButtonAlpha
                as1.alpha = offKeyButtonAlpha
                
                c1.alpha = offKeyButtonAlpha
                c1l.alpha = offKeyLabelAlpha
                
                ds2.alpha = offKeyButtonAlpha
                
                f2.alpha = offKeyButtonAlpha
                f2l.alpha = offKeyLabelAlpha
                
                gs2.alpha = offKeyButtonAlpha
                
                
                as2.alpha = offKeyButtonAlpha
                c2.alpha = offKeyButtonAlpha
                c2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "D#/Eb/Cm")
            {
                e1.alpha = offKeyButtonAlpha
                e1l.alpha = offKeyLabelAlpha
                
                fs1.alpha = offKeyButtonAlpha
                a1.alpha = offKeyButtonAlpha
                a1l.alpha = offKeyLabelAlpha
                
                b1.alpha = offKeyButtonAlpha
                b1l.alpha = offKeyLabelAlpha
                
                cs1.alpha = offKeyButtonAlpha
                e2.alpha = offKeyButtonAlpha
                e2l.alpha = offKeyLabelAlpha
                
                fs2.alpha = offKeyButtonAlpha
                a2.alpha = offKeyButtonAlpha
                a2l.alpha = offKeyLabelAlpha
                
                b2.alpha = offKeyButtonAlpha
                b2l.alpha = offKeyLabelAlpha
                
                cs2.alpha = offKeyButtonAlpha
            }
                
            else if (hlKey == "E/C#m/Dbm")
            {
                f1.alpha = offKeyButtonAlpha
                f1l.alpha = offKeyLabelAlpha
                
                g1.alpha = offKeyButtonAlpha
                g1l.alpha = offKeyLabelAlpha
                
                as1.alpha = offKeyButtonAlpha
                c1.alpha = offKeyButtonAlpha
                c1l.alpha = offKeyLabelAlpha
                
                d1.alpha = offKeyButtonAlpha
                d1l.alpha = offKeyLabelAlpha
                
                f2.alpha = offKeyButtonAlpha
                f2l.alpha = offKeyLabelAlpha
                
                g2.alpha = offKeyButtonAlpha
                g2l.alpha = offKeyLabelAlpha
                
                as2.alpha = offKeyButtonAlpha
                c2.alpha = offKeyButtonAlpha
                c2l.alpha = offKeyLabelAlpha
                
                d2.alpha = offKeyButtonAlpha
                d2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "F/Dm")
            {
                fs1.alpha = offKeyButtonAlpha
                gs1.alpha = offKeyButtonAlpha
                b1.alpha = offKeyButtonAlpha
                b1l.alpha = offKeyLabelAlpha
                
                cs1.alpha = offKeyButtonAlpha
                ds1.alpha = offKeyButtonAlpha
                fs2.alpha = offKeyButtonAlpha
                gs2.alpha = offKeyButtonAlpha
                b2.alpha = offKeyButtonAlpha
                b2l.alpha = offKeyLabelAlpha
                
                cs2.alpha = offKeyButtonAlpha
                ds2.alpha = offKeyButtonAlpha
            }
                
            else if (hlKey == "F#/D#m/Ebm")
            {
                g1.alpha = offKeyButtonAlpha
                g1l.alpha = offKeyLabelAlpha
                
                a1.alpha = offKeyButtonAlpha
                a1l.alpha = offKeyLabelAlpha
                
                c1.alpha = offKeyButtonAlpha
                c1l.alpha = offKeyLabelAlpha
                
                d1.alpha = offKeyButtonAlpha
                d1l.alpha = offKeyLabelAlpha
                
                e1.alpha = offKeyButtonAlpha
                e1l.alpha = offKeyLabelAlpha
                
                g2.alpha = offKeyButtonAlpha
                g2l.alpha = offKeyLabelAlpha
                
                a2.alpha = offKeyButtonAlpha
                a2l.alpha = offKeyLabelAlpha
                
                c2.alpha = offKeyButtonAlpha
                c2l.alpha = offKeyLabelAlpha
                
                d2.alpha = offKeyButtonAlpha
                d2l.alpha = offKeyLabelAlpha
                
                e2.alpha = offKeyButtonAlpha
                e2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "G/Em")
            {
                gs1.alpha = offKeyButtonAlpha
                as1.alpha = offKeyButtonAlpha
                cs1.alpha = offKeyButtonAlpha
                ds1.alpha = offKeyButtonAlpha
                f1.alpha = offKeyButtonAlpha
                f1l.alpha = offKeyLabelAlpha
                
                gs2.alpha = offKeyButtonAlpha
                as2.alpha = offKeyButtonAlpha
                cs2.alpha = offKeyButtonAlpha
                ds2.alpha = offKeyButtonAlpha
                f2.alpha = offKeyButtonAlpha
                f2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "G#/Ab/Fm")
            {
                a1.alpha = offKeyButtonAlpha
                a1l.alpha = offKeyLabelAlpha
                
                b1.alpha = offKeyButtonAlpha
                b1l.alpha = offKeyLabelAlpha
                
                d1.alpha = offKeyButtonAlpha
                d1l.alpha = offKeyLabelAlpha
                
                e1.alpha = offKeyButtonAlpha
                e1l.alpha = offKeyLabelAlpha
                
                fs1.alpha = offKeyButtonAlpha
                a2.alpha = offKeyButtonAlpha
                a2l.alpha = offKeyLabelAlpha
                
                b2.alpha = offKeyButtonAlpha
                b2l.alpha = offKeyLabelAlpha
                
                d2.alpha = offKeyButtonAlpha
                d2l.alpha = offKeyLabelAlpha
                
                e2.alpha = offKeyButtonAlpha
                e2l.alpha = offKeyLabelAlpha
                
                fs2.alpha = offKeyButtonAlpha
            }
                
            else if (hlKey == "A/F#m/Gbm")
            {
                as1.alpha = offKeyButtonAlpha
                c1.alpha = offKeyButtonAlpha
                c1l.alpha = offKeyLabelAlpha
                
                ds1.alpha = offKeyButtonAlpha
                f1.alpha = offKeyButtonAlpha
                f1l.alpha = offKeyLabelAlpha
                
                g1.alpha = offKeyButtonAlpha
                g1l.alpha = offKeyLabelAlpha
                
                as2.alpha = offKeyButtonAlpha
                c2.alpha = offKeyButtonAlpha
                c2l.alpha = offKeyLabelAlpha
                
                ds2.alpha = offKeyButtonAlpha
                f2.alpha = offKeyButtonAlpha
                f2l.alpha = offKeyLabelAlpha
                
                g2.alpha = offKeyButtonAlpha
                g2l.alpha = offKeyLabelAlpha
            }
                
            else if (hlKey == "A#/Bb/Gm")
            {
                b1.alpha = offKeyButtonAlpha
                b1l.alpha = offKeyLabelAlpha
                
                cs1.alpha = offKeyButtonAlpha
                e1.alpha = offKeyButtonAlpha
                e1l.alpha = offKeyLabelAlpha
                
                fs1.alpha = offKeyButtonAlpha
                gs1.alpha = offKeyButtonAlpha
                b2.alpha = offKeyButtonAlpha
                b2l.alpha = offKeyLabelAlpha
                
                cs2.alpha = offKeyButtonAlpha
                e2.alpha = offKeyButtonAlpha
                e2l.alpha = offKeyLabelAlpha
                
                fs2.alpha = offKeyButtonAlpha
                gs2.alpha = offKeyButtonAlpha
            }
                
            else if (hlKey == "B/G#m/Abm")
            {
                c1.alpha = offKeyButtonAlpha
                c1l.alpha = offKeyLabelAlpha
                
                d1.alpha = offKeyButtonAlpha
                d1l.alpha = offKeyLabelAlpha
                
                f1.alpha = offKeyButtonAlpha
                f1l.alpha = offKeyLabelAlpha
                
                g1.alpha = offKeyButtonAlpha
                g1l.alpha = offKeyLabelAlpha
                
                a1.alpha = offKeyButtonAlpha
                a1l.alpha = offKeyLabelAlpha
                
                c2.alpha = offKeyButtonAlpha
                c2l.alpha = offKeyLabelAlpha
                
                d2.alpha = offKeyButtonAlpha
                d2l.alpha = offKeyLabelAlpha
                
                f2.alpha = offKeyButtonAlpha
                f2l.alpha = offKeyLabelAlpha
                
                g2.alpha = offKeyButtonAlpha
                g2l.alpha = offKeyLabelAlpha
                
                a2.alpha = offKeyButtonAlpha
                a2l.alpha = offKeyLabelAlpha
            }
        }
    }
    
    // MUTER function....THINK THINK THINK THINK THINK
    func muter()
    {
        // if global variable mute is on
        if (mute == "on")
        {
            // disable appropriate keys
            if (hlKey == "C/Am")
            {
                cs1.isEnabled = false
                ds1.isEnabled = false
                fs1.isEnabled = false
                gs1.isEnabled = false
                as1.isEnabled = false
                
                cs2.isEnabled = false
                ds2.isEnabled = false
                fs2.isEnabled = false
                gs2.isEnabled = false
                as2.isEnabled = false
            }
            
            else if (hlKey == "C#/Bbm/A#m")
            {
                d1.isEnabled = false
                e1.isEnabled = false
                g1.isEnabled = false
                a1.isEnabled = false
                b1.isEnabled = false
                
                d2.isEnabled = false
                e2.isEnabled = false
                g2.isEnabled = false
                a2.isEnabled = false
                b2.isEnabled = false
            }
            
            else if (hlKey == "D/Bm")
            {
                ds1.isEnabled = false
                f1.isEnabled = false
                gs1.isEnabled = false
                as1.isEnabled = false
                c1.isEnabled = false
                
                ds2.isEnabled = false
                f2.isEnabled = false
                gs2.isEnabled = false
                as2.isEnabled = false
                c2.isEnabled = false
            }
            
            else if (hlKey == "D#/Eb/Cm")
            {
                e1.isEnabled = false
                fs1.isEnabled = false
                a1.isEnabled = false
                b1.isEnabled = false
                cs1.isEnabled = false
                
                e2.isEnabled = false
                fs2.isEnabled = false
                a2.isEnabled = false
                b2.isEnabled = false
                cs2.isEnabled = false
            }
            
            else if (hlKey == "E/C#m/Dbm")
            {
                f1.isEnabled = false
                g1.isEnabled = false
                as1.isEnabled = false
                c1.isEnabled = false
                d1.isEnabled = false
                
                f2.isEnabled = false
                g2.isEnabled = false
                as2.isEnabled = false
                c2.isEnabled = false
                d2.isEnabled = false
            }
            
            else if (hlKey == "F/Dm")
            {
                fs1.isEnabled = false
                gs1.isEnabled = false
                b1.isEnabled = false
                cs1.isEnabled = false
                ds1.isEnabled = false
                
                fs2.isEnabled = false
                gs2.isEnabled = false
                b2.isEnabled = false
                cs2.isEnabled = false
                ds2.isEnabled = false
            }
            
            else if (hlKey == "F#/D#m/Ebm")
            {
                g1.isEnabled = false
                a1.isEnabled = false
                c1.isEnabled = false
                d1.isEnabled = false
                e1.isEnabled = false
                
                g2.isEnabled = false
                a2.isEnabled = false
                c2.isEnabled = false
                d2.isEnabled = false
                e2.isEnabled = false
            }
            
            else if (hlKey == "G/Em")
            {
                gs1.isEnabled = false
                as1.isEnabled = false
                cs1.isEnabled = false
                ds1.isEnabled = false
                f1.isEnabled = false
                
                gs2.isEnabled = false
                as2.isEnabled = false
                cs2.isEnabled = false
                ds2.isEnabled = false
                f2.isEnabled = false
            }
            
            else if (hlKey == "G#/Ab/Fm")
            {
                a1.isEnabled = false
                b1.isEnabled = false
                d1.isEnabled = false
                e1.isEnabled = false
                fs1.isEnabled = false
                
                a2.isEnabled = false
                b2.isEnabled = false
                d2.isEnabled = false
                e2.isEnabled = false
                fs2.isEnabled = false
            }
            
            else if (hlKey == "A/F#m/Gbm")
            {
                as1.isEnabled = false
                c1.isEnabled = false
                ds1.isEnabled = false
                f1.isEnabled = false
                g1.isEnabled = false
                
                as2.isEnabled = false
                c2.isEnabled = false
                ds2.isEnabled = false
                f2.isEnabled = false
                g2.isEnabled = false
            }
            
            else if (hlKey == "A#/Bb/Gm")
            {
                b1.isEnabled = false
                cs1.isEnabled = false
                e1.isEnabled = false
                fs1.isEnabled = false
                gs1.isEnabled = false
                
                b2.isEnabled = false
                cs2.isEnabled = false
                e2.isEnabled = false
                fs2.isEnabled = false
                gs2.isEnabled = false
            }
            
            else if (hlKey == "B/G#m/Abm")
            {
                c1.isEnabled = false
                d1.isEnabled = false
                f1.isEnabled = false
                g1.isEnabled = false
                a1.isEnabled = false
                
                c2.isEnabled = false
                d2.isEnabled = false
                f2.isEnabled = false
                g2.isEnabled = false
                a2.isEnabled = false
            }
            
            
            
            
            
            
            
        }
    }
    
    // hide chord toggle if user doesn't want chords/arpeggios
    func hideChordToggle()
    {
        if (playChord == "off" && arpeggiate == "off")
        { typeButton.alpha = 0.0 }
    }
    
    

    
    

}

