//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class TemperatureController {

	private let _sceneView: SCNView
	private let _ghostNode: SCNNode
	private let _hudController: HudController

	init(sceneView: SCNView, ghostNode: SCNNode, hudController: HudController) {
		_sceneView = sceneView
		_ghostNode = ghostNode
		_hudController = hudController
	}

	public func updateAtTime(time: NSTimeInterval) {
		if _sceneView.isNodeInsideFrustum(_ghostNode, withPointOfView: _sceneView.pointOfView!) {
			_hudController.decreaseTemperature()
		} else {
			_hudController.increaseTemperature()
		}
	}
}
