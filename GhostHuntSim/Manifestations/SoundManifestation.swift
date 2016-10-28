//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit
import AVFoundation

public class SoundManifestation: Manifestation {

    private let soundFileName: String
    private let soundNode: SCNNode
    private let soundPivotNode: SCNNode
    
    private var audioPlayer: AVAudioPlayer? = nil

    init(minimumActivityLevel: Double, soundFileName: String, soundNode: SCNNode, soundPivotNode: SCNNode) {
        self.minimumActivityLevel = minimumActivityLevel
        self.soundFileName = soundFileName
        self.soundNode = soundNode
        self.soundPivotNode = soundPivotNode
        
        let url = NSBundle.mainBundle().URLForResource(soundFileName, withExtension: "caf")
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
            audioPlayer!.prepareToPlay()
        } catch {
            // TODO handle error
        }
    }

    public var minimumActivityLevel: Double

    public func manifest() {
        let rotation = (-2...2).randomInt()
        soundPivotNode.removeAllActions()
        soundPivotNode.runAction(SCNAction.rotateByX(0, y: 0, z: CGFloat(rotation), duration: 0))

//        let audioSource = SCNAudioSource(fileNamed: soundFileName)
//        audioSource!.positional = true
//        soundNode.runAction(SCNAction.playAudioSource(audioSource!, waitForCompletion: false))
        
        audioPlayer?.play()
    }
}
