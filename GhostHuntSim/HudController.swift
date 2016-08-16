//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class HudController {

	private let _temperatureNode: SKSpriteNode

	init(sceneView: SCNView) {
		let hudScene = SKScene(size: sceneView.bounds.size)
		_temperatureNode = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width:100, height:100))
		hudScene.addChild(_temperatureNode)

		sceneView.overlaySKScene = hudScene
		sceneView.overlaySKScene!.hidden = false
		sceneView.overlaySKScene!.scaleMode = SKSceneScaleMode.ResizeFill
		sceneView.overlaySKScene!.userInteractionEnabled = true
	}

	public func decreaseTemperature() {
		_temperatureNode.color = UIColor.blueColor()
	}

	public func increaseTemperature() {
		_temperatureNode.color = UIColor.orangeColor()
	}
}
