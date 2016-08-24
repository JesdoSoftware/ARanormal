//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit

class HUDScene: SKScene {

	private var temperatureNode: SKSpriteNode! = nil
	private var emfNode: SKLabelNode! = nil
	private var flashlightButton: SKNode?

	override func didMoveToView(view: SKView) {
		temperatureNode = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
		addChild(temperatureNode)

		emfNode = SKLabelNode(text: "0.0 mG")
		emfNode.position = CGPoint(x: 50, y: 600)
		addChild(emfNode)
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
}
