//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit

class HUDScene: SKScene {

	var controller: HUDController?

	private var temperatureNode: SKSpriteNode! = nil
	private var emfNode: SKLabelNode! = nil
	private var flashlightButton: SKSpriteNode! = nil

	override func didMoveToView(view: SKView) {
		temperatureNode = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
		addChild(temperatureNode)

		emfNode = SKLabelNode(text: "0.0 mG")
		emfNode.position = CGPoint(x: 50, y: 600)
		addChild(emfNode)

		flashlightButton = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 100, height: 100))
		flashlightButton.position = CGPoint(x: 300, y: 0)
		addChild(flashlightButton)
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
		temperatureNode.color = UIColor.blueColor()
	}

	func increaseTemperature() {
		temperatureNode.color = UIColor.orangeColor()
	}

	func setEmfRating(emfRating: Double) {
		emfNode.text = String(emfRating) + " mG"
	}

	func setFlashlightIndicatorOn(isOn: Bool) {
		if isOn {
			flashlightButton.color = UIColor.yellowColor()
		}
		else {
			flashlightButton.color = UIColor.purpleColor()
		}
	}
}
