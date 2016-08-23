//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class HUDController: MessengerSubscriber {

	private let temperatureNode: SKSpriteNode
	private let emfNode: SKLabelNode

	init(sceneView: SCNView) {
		let hudScene = SKScene(size: sceneView.bounds.size)
		temperatureNode = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
		hudScene.addChild(temperatureNode)

		emfNode = SKLabelNode(text: "0.0")
		emfNode.position = CGPoint(x: 50, y: 600)
		hudScene.addChild(emfNode)

		sceneView.overlaySKScene = hudScene
		sceneView.overlaySKScene!.hidden = false
		sceneView.overlaySKScene!.scaleMode = SKSceneScaleMode.ResizeFill
		sceneView.overlaySKScene!.userInteractionEnabled = true
	}

	public func processMessage(message: AnyObject) {
		if let isGhostInViewMessage = message as? IsGhostInViewMessage {
			if isGhostInViewMessage.isInView {
				decreaseTemperature()
			} else {
				increaseTemperature()
			}
		} else if let activityChangedMessage = message as? ActivityChangedMessage {
			setEmfRating(activityChangedMessage.activity)
		}
	}

	private func decreaseTemperature() {
		temperatureNode.color = UIColor.blueColor()
	}

	private func increaseTemperature() {
		temperatureNode.color = UIColor.orangeColor()
	}

	private func setEmfRating(emfRating: Double) {
		emfNode.text = String(emfRating)
	}
}
