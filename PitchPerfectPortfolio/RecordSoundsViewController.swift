//
//  RecordSoundsViewController.swift
//  PitchPerfectPortfolio
//
//  Created by Sahil Patel on 22/05/18.
//  Copyright © 2018 Sahil Patel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially, the stopRecord button should be disabled.
        toggleUIState(stoppedRecording: true)
    }
    
    
    @IBAction func stopRecordingButtonAction(_ sender:Any) {
        toggleUIState(stoppedRecording: true)
        stopRecordingAudio()
        
    }
    
    @IBAction func startRecordingButtonAction(_ sender: Any) {
        toggleUIState(stoppedRecording: false)
        startRecordingAudio()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        }
        else {
            print("recording is not successful")
        }
    }
    
    /**
        Creates a file for saving audio recording (if it does not exist) and
        then calls the AVAudioRecorder api for recording audio.
     */
    private func startRecordingAudio() {
        
        //  creating a file path where the recording will be saved.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingFileName = "recordedVoice.wav"
        let recordingFilePath = URL(string: [dirPath, recordingFileName].joined(separator: "/"))!

        //  Everything about recording audio and setting some required flags and settings.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: recordingFilePath, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecordingAudio(){
        audioRecorder.stop()
    }
 
    /**
     Switches the state of UI based on the which button was clicked.
     Only one should be enabled at a time and the label should switch text
     based on the choice.
    */
    private func toggleUIState(stoppedRecording : Bool) {
        
        startRecordingButton.isEnabled = stoppedRecording
        stopRecordingButton.isEnabled = !stoppedRecording
        
        if stoppedRecording {
            recordingStatusLabel.text = "Tap to record Audio"
        } else {
            recordingStatusLabel.text = "Recording in progress..."
        }
    }
    
    
}
