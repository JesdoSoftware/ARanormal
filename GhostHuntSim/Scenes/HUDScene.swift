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

    override func didMoveToView(view: SKView) {
        temperatureIndicator = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
        addChild(temperatureIndicator)

        emfIndicator = SKLabelNode(text: "0.0 mG")
        emfIndicator.position = CGPoint(x: 50, y: 600)
        addChild(emfIndicator)

        flashlightButton = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 100, height: 100))
        flashlightButton.position = CGPoint(x: 300, y: 0)
        addChild(flashlightButton)

        yesNoIndicator = SKLabelNode(text: "")
        yesNoIndicator.position = CGPoint(x: 300, y: 300)
        addChild(yesNoIndicator)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if flashlightButton.containsPoint(location) {
                controller?.toggleFlashlight()
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

    func setYesNoIndicator(isYes: Bool) {
        if isYes {
            yesNoIndicator.text = "YES"
        } else {
            yesNoIndicator.text = "NO"
        }
    }

    func clearYesNoIndicator() {
        yesNoIndicator.text = ""
    }
}
