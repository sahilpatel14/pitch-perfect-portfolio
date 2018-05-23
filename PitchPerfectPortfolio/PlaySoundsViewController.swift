//
//  PlaySoundsViewController.swift
//  PitchPerfectPortfolio
//
//  Created by Sahil Patel on 22/05/18.
//  Copyright © 2018 Sahil Patel. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL : URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  setting content mode to aspect fit for all buttons.
        //  Suggestion from review
        updateContentMode(for: slowButton)
        updateContentMode(for: fastButton)
        updateContentMode(for: highPitchButton)
        updateContentMode(for: lowPitchButton)
        updateContentMode(for: echoButton)
        updateContentMode(for: reverbButton)
        updateContentMode(for: stopButton)
        
        //  As soon as the view is ready, we do all the preprocessing for playing audio.
        //  actual audio will be played when user clicks the button
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  Disabling the pause button by default
        //  There is a toggleUI() defined in extension class. We can use the same one.
        configureUI(.notPlaying)
    }
    
    @IBAction func playSoundAction(_ sender : UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    //  Called when user presses on pause sound button.
    @IBAction func pauseSoundButtonAction(_ sender : AnyObject) {
        stopAudio()
    }
    
    private func updateContentMode(for button: UIButton,
                                   to contentMode: UIViewContentMode = .scaleAspectFit) {
        button.imageView?.contentMode = contentMode
    }
}
