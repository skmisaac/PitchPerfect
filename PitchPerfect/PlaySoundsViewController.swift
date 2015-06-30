//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  This is recording playback view for user to choose different playback styles e.g.: slow, fast, chipmunk and Darth Vader style
//
//  Created by SUN Ka Meng Isaac on 30/6/15.
//  Copyright (c) 2015 SUN Ka Meng Isaac. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!

    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    func playAudio() {
        allAudioStopAndReset()
        stopButton.hidden = false
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.rate = 0.5
        playAudio()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.rate = 2.0
        playAudio()
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func stop(sender: UIButton) {
        allAudioStopAndReset()
    }
    
    // to stop all AV Audio Playback before play any sound
    func allAudioStopAndReset() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        allAudioStopAndReset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // using trailing closure to hide the button (has delay to hide the button but works)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) {
            self.stopButton.hidden = true
        }
        
        audioEngine.startAndReturnError(nil)
        
        stopButton.hidden = false
        audioPlayerNode.play()
    }
    

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if (flag) {
            stopButton.hidden = true
        }
    }
}
