//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Elias Hall on 5/21/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit //gives xcode access to UIKit classes
import AVFoundation //gives xcode access to AVfoundation classes

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder! //gives view controller ability to use audio recorder from AVFound...

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRecUI(false) //stopRecording button is intially disabled

    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
         configureRecUI(true) //record button disabled, stop button enabled, label text
        
        /*  Getting directory path by getting directory path name/.documentDirectory and storing it there as a string in dirPath constant. Then creating recording file name "recordedVoice.wav". Then combinging directory path and recording file name to get complete path to file.
        */
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
       // var fileName: String = "audioFile.m4a"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
    
        //creating the audio session. audio session is needed to record/playback audio
        let session = AVAudioSession.sharedInstance()
       // try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        //Creating AVAudioRecorder and start recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])//creating AVAudioRecorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
 
    
    @IBAction func stopRecording(_ sender: AnyObject) {
       
        configureRecUI(false) // stop button enabled, record button disabled, label text
        
        //Stopping the audio recorder, Setting shared audio session to inactive
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: Audio Recorder Delegate
    //Calling stop recording segue
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording was not successful")
        }
        
    }
    
        override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            print(recordedAudioURL)
        }
    
    }
    
    func configureRecUI(_ isRecording: Bool) { //when recording/stop button is pressed
        
        if isRecording { // if recording button is pressed
        recordButton.isEnabled = false // record button becomes disabled
        stopRecordingButton.isEnabled = true // stop button becomes enabled
        recordingLabel.text = "Recording in Progress" // compiler message confirms recording is happening
        }
        else { // if stop button is pressed
            recordButton.isEnabled = true // record button becomes enabled
            stopRecordingButton.isEnabled  = false // stop button becomes disabled
            recordingLabel.text = "Tap to Record" // UI Label text
            
        }
        
    }
  
    
}



