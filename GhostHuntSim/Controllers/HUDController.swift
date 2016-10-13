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
    private let speechSynthesizer: AVSpeechSynthesizer

    private var isFlashlightOn: Bool = true
    private var isGhostInView: Bool = false
    private var isGhostVisible: Bool = false

    private var shutterSoundPlayer: AVAudioPlayer? = nil

    init(sceneView: SCNView, messenger: Messenger) {
        self.messenger = messenger
        speechSynthesizer = AVSpeechSynthesizer()

        hudScene = HUDScene()
        hudScene.controller = self

        sceneView.overlaySKScene = hudScene
        sceneView.overlaySKScene!.hidden = false
        sceneView.overlaySKScene!.scaleMode = .ResizeFill
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
            setEmfRatingTo(activityChangedMessage.activity)
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

    private func setEmfRatingTo(amount: Double) {
        hudScene.setEmfRating(amount)

        // TODO set game over activity limit
        if (amount >= 10) {
            messenger.publishMessage(GameOverMessage(score: hudScene.getScore()))
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
        dispatchAfterSeconds(1) {
            self.hudScene.setCameraEnabled(true)
        }

        if isGhostInView && isGhostVisible {
            messenger.publishMessage(ScoreIncreasedMessage(amount: 1000))
        }
    }

    private func handleYesNoResponse(isYes: Bool) {
        hudScene.indicateYesNoResponse(isYes)
        messenger.publishMessage(ScoreIncreasedMessage(amount: 100))

        if isYes == true {
            utterPhrase("YES")
        } else {
            utterPhrase("NO")
        }

        dispatchAfterSeconds(5) {
            self.hudScene.clearYesNoIndicator()
        }
    }

    private func handleVerbalResponse(response: String) {
        hudScene.indicateVerbalResponse(response)
        messenger.publishMessage(ScoreIncreasedMessage(amount: 500))

        utterPhrase(response)

        dispatchAfterSeconds(5) {
            self.hudScene.clearVerbalResponseIndicator()
        }
    }

    private func utterPhrase(phrase: String) {
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        speechSynthesizer.speakUtterance(utterance)
    }

    private func displayDialog(text: String, dismissAction: (() -> Void)?) {
        dismissAction!()
    }
}
