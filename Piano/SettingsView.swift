//
//  SettingsView.swift
//  Piano
//
//  Created by Vardaan Aashish on 2/19/17.
//  Copyright © 2017 Vardaan. All rights reserved.
//

import UIKit

// determines if chord switch is on
var playChord = "off"
// determines which chord type the user has chosen
var chordType = "Major"
// determines if arpeggio switch is on
var arpeggiate = "off"
// determines if hide notes off key is on
var hideNotes = "Show"
// determines which key the user has chosen
var hlKey = "C/Am"
// mute notes off key
var mute = "off"
// arpeggio interval set by user
var arpInterval = 0.5


class SettingsView: UIViewController
{
    
    // chord toggle
    @IBOutlet weak var chordSwitch: UISwitch!
    
    // arpeggio switch
    @IBOutlet weak var arpeggioSwitch: UISwitch!
    
    // interval label
    @IBOutlet weak var intervalLabel: UILabel!
    
    // interval slider
    @IBOutlet weak var intervalSlider: UISlider!
    
    // interval slider value
    @IBOutlet weak var intervalValue: UILabel!
    
    // show/dim/hide off key notes
    @IBOutlet weak var offKeyLabel: UILabel!
    
    // mute switch
    @IBOutlet weak var muteSwitch: UISwitch!
    
    
    // key Label
    @IBOutlet weak var keyLabel: UILabel!
    
    // scale label
    @IBOutlet weak var scaleLabel: UILabel!
    
    // choices of scale
    let scaleOptions = ["Major", "Minor"]
    // scale count to mod
    var scaleCount = 0
    
    // show/dim/hide options
    let offKeyOptions = ["Show", "Dim", "Hide"]
    // offKeyCount to mod
    var offKeyCount = 0
    
    // choices of key
    let keyOptions = ["C/Am", "C#/Bbm/A#m", "D/Bm", "D#/Eb/Cm", "E/C#m/Dbm", "F/Dm", "F#/D#m/Ebm", "G/Em", "G#/Ab/Fm", "A/F#m/Gbm", "A#/Bb/Gm", "B/G#m/Abm"]
    // key count to mod
    var keyCount = 0
    
    
    @IBOutlet weak var blackView: UIView!
    
    


    override func viewDidLoad()
    {
        // curve black view radius
        blackView.layer.masksToBounds = true
        blackView.layer.cornerRadius = CGFloat(15)
        
        // make-shift memory function to remember settings
        memory()

        
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // when chord switch is tapped
    @IBAction func chordSwitch(_ sender: UISwitch)
    {
        if (sender.isOn)
        {
            playChord = "on"
            // if chord is on, arpeggio must be off
            arpeggioSwitch.setOn(false, animated: false)
            arpeggiate = "off"
        }
        else // chord is off
        { playChord = "off" }
    }
    
    
    // when arpeggio switch is tapped
    @IBAction func arpeggioSwitch(_ sender: UISwitch)
    {
        if (sender.isOn)
        {
            arpeggiate = "on"
            // if arpeggio is on, chord must be off
            chordSwitch.setOn(false, animated: false)
            playChord = "off"
        }
        else
        { arpeggiate = "off" }
    }
    
    // when user interacts with arpeggio interval slider
    @IBAction func intervalSlider(_ sender: UISlider)
    {
        arpInterval = Double((sender.value * 10).rounded()) / 10
        intervalValue.text = String(arpInterval) + " sec"
    }
    
    
    // move through show/dim/hide options
    @IBAction func offKeyRight(_ sender: UIButton)
    {
        // on button press, change text to next in the array using modulus, and increment counter
        offKeyCount = (offKeyCount + 1) % 3
        offKeyLabel.text = offKeyOptions[offKeyCount]
        hideNotes = offKeyLabel.text!
    }
    
    // move through show/dim/hide options
    @IBAction func offKeyLeft(_ sender: UIButton)
    {
        // on button press, change text to previous in the array using modulus, and increment counter
        offKeyCount = (offKeyCount + 2) % 3
        offKeyLabel.text = offKeyOptions[offKeyCount]
        hideNotes = offKeyLabel.text!
    }
    
    // toggle between muting notes off key
    @IBAction func muteSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        { mute = "on" }
        else
        { mute = "off" }
    }
    
    
    
    // press right key button for keys
    @IBAction func keyRight(_ sender: UIButton)
    {
        // on button press, change text to next in the array using modulus, and increment counter
        keyCount = (keyCount + 1) % 12
        keyLabel.text = keyOptions[keyCount]
        hlKey = keyLabel.text!
    }
    
    // press left key button for keys
    @IBAction func keyLeft(_ sender: UIButton)
    {
        // on button press, change text to previous in the array using modulus, and increment counter
        keyCount = (keyCount + 11) % 12
        keyLabel.text = keyOptions[keyCount]
        hlKey = keyLabel.text!
    }
    
    
    
    
    // right key button for chord type
    @IBAction func typeRight(_ sender: UIButton)
    {
        // on button press, change text to next in the array using modulus, and increment counter
        scaleCount = (scaleCount + 1) % 2
        scaleLabel.text = scaleOptions[scaleCount]
        chordType = scaleLabel.text!
    }
    
    // left key button for chord type
    @IBAction func typeLeft(_ sender: UIButton)
    {
        // on button press, change text to previous in the array using modulus, and increment counter
        scaleCount = (scaleCount + 1) % 2
        scaleLabel.text = scaleOptions[scaleCount]
        chordType = scaleLabel.text!
    }
    
    
    // BEHIND THE SCENES SETTINGS MEMORY used in viewDidLoad of Settings window
    func memory()
    {
        // if CHORD global variable is on, turn switch on
        if (playChord == "on")
        { chordSwitch.setOn(true, animated: true) }
        else // playChord is off
        { chordSwitch.setOn(false, animated: false) }
        
        // if ARPEGGIO global variable is on, turn switch on
        if (arpeggiate == "on")
        { arpeggioSwitch.setOn(true, animated: true) }
        else // arpeggiate is off
        { arpeggioSwitch.setOn(false, animated: false) }
        
        // if MUTE global variable is on, turn switch on
        if (mute == "on")
        { muteSwitch.setOn(true, animated: true) }
        else // MUTE is off
        { muteSwitch.setOn(false, animated: false) }
        
        // remember arpeggio interval set by user
        intervalValue.text = String(arpInterval) + " sec"
        intervalSlider.value = Float(arpInterval)
        
        // set text of hideNotes to global variable
        offKeyLabel.text = hideNotes
        
        // set text of chord type label to global chord type
        scaleLabel.text = chordType
        
        // set text of highlight key label to global hlKey
        keyLabel.text = hlKey
        
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
