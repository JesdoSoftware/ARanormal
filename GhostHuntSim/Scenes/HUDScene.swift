//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit

class HUDScene: SKScene {

    var controller: HUDController?

    private var temperatureIndicator: SKSpriteNode! = nil
    private var emfIndicator: SKLabelNode! = nil
    private var flashlightButton: SKSpriteNode! = nil
    private var yesNoIndicator: SKLabelNode! = nil
    private var verbalResponseIndicator: SKLabelNode! = nil
    private var cameraButton: SKSpriteNode! = nil

    override func didMoveToView(view: SKView) {
        emfIndicator = SKLabelNode(text: "0.0 mG")
        emfIndicator.position = CGPoint(x: 100, y: 600)
        addChild(emfIndicator)

        temperatureIndicator = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
        temperatureIndicator.position = CGPoint(x: 300, y: 600)
        addChild(temperatureIndicator)

        flashlightButton = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 100, height: 100))
        flashlightButton.position = CGPoint(x: 100, y: 100)
        addChild(flashlightButton)

        yesNoIndicator = SKLabelNode(text: "")
        yesNoIndicator.position = CGPoint(x: 300, y: 300)
        addChild(yesNoIndicator)

        verbalResponseIndicator = SKLabelNode(text: "")
        verbalResponseIndicator.position = CGPoint(x: 300, y: 300)
        addChild(verbalResponseIndicator)

        cameraButton = SKSpriteNode(color: UIColor.cyanColor(), size: CGSize(width: 100, height: 100))
        cameraButton.position = CGPoint(x: 300, y: 100)
        addChild(cameraButton)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if flashlightButton.containsPoint(location) {
                controller?.toggleFlashlight()
            } else if cameraButton.containsPoint(location) {
                controller?.takePicture()
            }
        }
        super.touchesEnded(touches, withEvent: event)
    }

    func decreaseTemperature() {
        temperatureIndicator.color = UIColor.blueColor()
    }

    func increaseTemperature() {
        temperatureIndicator.color = UIColor.orangeColor()
    }

    func setEmfRating(emfRating: Double) {
        emfIndicator.text = String(format: "%.1f", emfRating) + " mG"
    }

    func setFlashlightIndicatorOn(isOn: Bool) {
        if isOn {
            flashlightButton.color = UIColor.yellowColor()
        }
        else {
            flashlightButton.color = UIColor.purpleColor()
        }
    }

    func indicateYesNoResponse(isYes: Bool) {
        if isYes {
            yesNoIndicator.text = "YES"
        } else {
            yesNoIndicator.text = "NO"
        }
    }

    func clearYesNoIndicator() {
        yesNoIndicator.text = ""
    }

    func indicateVerbalResponse(response: String) {
        verbalResponseIndicator.text = response
    }

    func clearVerbalResponseIndicator() {
        verbalResponseIndicator.text = ""
    }
}
