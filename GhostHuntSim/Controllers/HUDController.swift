//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class HUDController: MessengerSubscriber {

    private let hudScene: HUDScene
    private let messenger: Messenger

    private var isFlashlightOn: Bool = true
    private var isGhostInView: Bool = false
    private var isGhostVisible: Bool = false

    init(sceneView: SCNView, messenger: Messenger) {
        self.messenger = messenger

        hudScene = HUDScene(size: sceneView.bounds.size)
        hudScene.controller = self

        sceneView.overlaySKScene = hudScene
        sceneView.overlaySKScene!.hidden = false
        sceneView.overlaySKScene!.scaleMode = SKSceneScaleMode.ResizeFill
        sceneView.overlaySKScene!.userInteractionEnabled = true
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
            displayYesNoResponse(yesNoResponseMessage.response)
        } else if let verbalResponseMessage = message as? VerbalResponseMessage {
            displayVerbalResponse(verbalResponseMessage.response)
        } else if let isGhostVisibleMessage = message as? IsGhostVisibleMessage {
            isGhostVisible = isGhostVisibleMessage.isVisible
        }
    }

    func toggleFlashlight() {
        isFlashlightOn = !isFlashlightOn
        messenger.publishMessage(FlashlightOnOffMessage(isOn: isFlashlightOn))
        hudScene.setFlashlightIndicatorOn(isFlashlightOn)
    }

    func takePicture() {

    }

    private func displayYesNoResponse(isYes: Bool) {
        hudScene.indicateYesNoResponse(isYes)

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.hudScene.clearYesNoIndicator()
        }
    }

    private func displayVerbalResponse(response: String) {
        hudScene.indicateVerbalResponse(response)

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.hudScene.clearVerbalResponseIndicator()
        }
    }
}
