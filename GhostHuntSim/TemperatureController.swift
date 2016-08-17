//
// Created by Jesse Douglas on 2016-08-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class TemperatureController {

	private let _sceneView: SCNView
	private let _ghostNode: SCNNode
	private let _messenger: Messenger

	init(sceneView: SCNView, ghostNode: SCNNode, messenger: Messenger) {
		_sceneView = sceneView
		_ghostNode = ghostNode
		_messenger = messenger
	}

	public func updateAtTime(time: NSTimeInterval) {
		if _sceneView.isNodeInsideFrustum(_ghostNode, withPointOfView: _sceneView.pointOfView!) {
			_messenger.publishMessage(TemperatureMessage(direction: .Down))
		} else {
			_messenger.publishMessage(TemperatureMessage(direction: .Up))
		}
	}
}
