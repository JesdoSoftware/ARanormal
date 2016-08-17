//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class HUDController: MessengerSubscriber {

	private let _temperatureNode: SKSpriteNode
	private let _emfNode: SKLabelNode

	init(sceneView: SCNView) {
		let hudScene = SKScene(size: sceneView.bounds.size)
		_temperatureNode = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
		hudScene.addChild(_temperatureNode)

		_emfNode = SKLabelNode(text: "0.0")
		_emfNode.position = CGPoint(x: 50, y: 600)
		hudScene.addChild(_emfNode)

		sceneView.overlaySKScene = hudScene
		sceneView.overlaySKScene!.hidden = false
		sceneView.overlaySKScene!.scaleMode = SKSceneScaleMode.ResizeFill
		sceneView.overlaySKScene!.userInteractionEnabled = true
	}

	public func processMessage(message: AnyObject) {
		if let temperatureMessage = message as? TemperatureMessage {
			if temperatureMessage.Direction == .Down {
				decreaseTemperature()
			} else if temperatureMessage.Direction == .Up {
				increaseTemperature()
			}
		}
	}

	private func decreaseTemperature() {
		_temperatureNode.color = UIColor.blueColor()
	}

	private func increaseTemperature() {
		_temperatureNode.color = UIColor.orangeColor()
	}

	public func setEmfRating(emfRating: Double) {
		_emfNode.text = String(emfRating)
	}
}
