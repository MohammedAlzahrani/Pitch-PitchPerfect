//
//  RecordingViewController.swift
//  Pitch PitchPerfect
//
//  Created by Mohammed ALZAHRANI on 11/4/18.
//  Copyright © 2018 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import AVFoundation
class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI(isRecording: false)
    }



    @IBAction func startRecording(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        configureUI(isRecording: false)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playRecordingVC = segue.destination as! PlayRecordingViewController
            let recordedAudioURL = sender as! URL
            playRecordingVC.recordedAudioURL = recordedAudioURL
        }
    }
    // configure UI according to recording state
    func configureUI(isRecording: Bool) {
        if  isRecording{
            recordingLable.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopButton.isEnabled = isRecording
        }
        else{
            recordingLable.text = "Tap to Record"
            recordButton.isEnabled = true
            stopButton.isEnabled = isRecording
        }
    }

}

