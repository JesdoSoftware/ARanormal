//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit
import AVFoundation

public class HUDController: MessengerSubscriber {

    private let hudScene: HUDScene
    private let messenger: Messenger

    private var isFlashlightOn: Bool = true
    private var isGhostInView: Bool = false
    private var isGhostVisible: Bool = false
    private var shutterSoundPlayer: AVAudioPlayer? = nil

    init(sceneView: SCNView, messenger: Messenger) {
        self.messenger = messenger

        hudScene = HUDScene()
        hudScene.controller = self

        sceneView.overlaySKScene = hudScene
        sceneView.overlaySKScene!.hidden = false
        sceneView.overlaySKScene!.scaleMode = SKSceneScaleMode.ResizeFill
        sceneView.overlaySKScene!.userInteractionEnabled = true

        let url = NSBundle.mainBundle().URLForResource("Shutter", withExtension: "caf")
        do {
            shutterSoundPlayer = try AVAudioPlayer(contentsOfURL: url!)
            shutterSoundPlayer!.prepareToPlay()
        } catch {
            // TODO handle error
        }
    }

    public func processMessage(message: AnyObject) {
        if let isGhostInViewMessage = message as? IsGhostInViewMessage {
            if isGhostInViewMessage.isInView {
                hudScene.decreaseTemperature()
            } else {
                hudScene.increaseTemperature()
            }
            isGhostInView = isGhostInViewMessage.isInView
        } else if let activityChangedMessage = message as? ActivityChangedMessage {
            hudScene.setEmfRating(activityChangedMessage.activity)
        } else if let flashlightMessage = message as? FlashlightOnOffMessage {
            isFlashlightOn = flashlightMessage.isOn
            hudScene.setFlashlightIndicatorOn(isFlashlightOn)
        } else if let yesNoResponseMessage = message as? YesNoResponseMessage {
            handleYesNoResponse(yesNoResponseMessage.response)
        } else if let verbalResponseMessage = message as? VerbalResponseMessage {
            handleVerbalResponse(verbalResponseMessage.response)
        } else if let isGhostVisibleMessage = message as? IsGhostVisibleMessage {
            isGhostVisible = isGhostVisibleMessage.isVisible
        } else if let scoreIncreasedMessage = message as? ScoreIncreasedMessage {
            hudScene.increaseScoreBy(scoreIncreasedMessage.amount)
        }
    }

    func toggleFlashlight() {
        isFlashlightOn = !isFlashlightOn
        messenger.publishMessage(FlashlightOnOffMessage(isOn: isFlashlightOn))
        hudScene.setFlashlightIndicatorOn(isFlashlightOn)
    }

    func takePicture() {
        shutterSoundPlayer?.play()
        hudScene.setCameraEnabled(false)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.hudScene.setCameraEnabled(true)
        }

        if isGhostInView && isGhostVisible {
            messenger.publishMessage(ScoreIncreasedMessage(amount: 50))
        }
    }

    private func handleYesNoResponse(isYes: Bool) {
        hudScene.indicateYesNoResponse(isYes)
        messenger.publishMessage(ScoreIncreasedMessage(amount: 5))

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.hudScene.clearYesNoIndicator()
        }
    }

    private func handleVerbalResponse(response: String) {
        hudScene.indicateVerbalResponse(response)
        messenger.publishMessage(ScoreIncreasedMessage(amount: 10))

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.hudScene.clearVerbalResponseIndicator()
        }
    }
}
