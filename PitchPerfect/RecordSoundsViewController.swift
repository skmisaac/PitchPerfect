//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  This is a recording view to let user record their voice by tapping the microphone image
//
//  Created by SUN Ka Meng Isaac on 30/6/15.
//  Copyright (c) 2015 SUN Ka Meng Isaac. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var audioSession:  AVAudioSession!
    var isPaused: Bool = false
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pauseButton.hidden = true
        stopButton.hidden = true
        recordingLabel.text = "Tap to Record"
    }
    
    func showButtons() {
        pauseButton.hidden = false
        stopButton.hidden = false
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        recordingLabel.text = "Recording in Progress..."
        showButtons()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        if (isPaused) {
            isPaused = !isPaused
            recordingLabel.text = "Recording in Progress..."
            audioRecorder.record()
            let pausedImage = UIImage(named: "Pause", inBundle: nil, compatibleWithTraitCollection: nil)
            pauseButton.setImage(pausedImage, forState: UIControlState.Normal)
            showButtons()
        }
        else {
            isPaused = !isPaused
            recordingLabel.text = "Recording Paused"
            audioRecorder.pause()
            let resumedImage = UIImage(named: "Resume", inBundle: nil, compatibleWithTraitCollection: nil)
            pauseButton.setImage(resumedImage, forState: UIControlState.Normal)
            showButtons()
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        audioSession.setActive(false, error: nil)
        recordingLabel.text = "Finished Recording"
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathUrl: recorder.url)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            // Show user an alert of failed recording
            let alertController = UIAlertController(title: "Error", message:
                "Recording was unsuccessful", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
            // reset button and label states
            recordButton.enabled = true
            stopButton.hidden = true
            recordingLabel.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "stopRecording" ) {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

