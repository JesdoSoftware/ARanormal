//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class HUDController: MessengerSubscriber {

	private let hudScene: HUDScene

	init(sceneView: SCNView) {
		hudScene = HUDScene(size: sceneView.bounds.size)

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
		} else if let activityChangedMessage = message as? ActivityChangedMessage {
			hudScene.setEmfRating(activityChangedMessage.activity)
		}
	}
}
