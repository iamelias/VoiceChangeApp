//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Elias Hall on 5/21/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder! //gives view controller ability to use audio recorder from AVFound...

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureRecUI(false) //setting stopRecording button to being intially disabled

    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        configureRecUI(true) //setting to: record button disabled, stop button enabled, label text

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String //getting directory path
        let recordingName = "recordedVoice.wav" // naming recording
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/")) //combinging path and name
        
    
        //creating the audio session. audio session is needed to record/playback audio
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print("creating the audio session failed")
        }
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:]) //creating audio recorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record() //start recording
        
    }
 
    
    @IBAction func stopRecording(_ sender: AnyObject) {
       
        configureRecUI(false) // stop button enabled, record button disabled, label text
        audioRecorder.stop() //stopping audio recorder
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: Audio Recorder Delegate
    //Segueing audio
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag { //if recorded successfully
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) //segueing
        }
        else {
            print("recording was not successful")
        }
        
    }
    //Segueing audio
        override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    
    }
    //Enabling/disabling buttons, and choosing label in RecordingSoundsViewController
         func configureRecUI(_ isRecording: Bool) { //recording/not recording
            recordButton.isEnabled = !isRecording // record Button is disabled/Record Button enabled
         stopRecordingButton.isEnabled = isRecording // stop button enabled/stop button disabled
            let output = isRecording ? "Recording in Progress" : "Tap to Record" // record output/stop output
            recordingLabel.text = output // displaying record button output/stop button output
            
         }
    
    }
  
    




