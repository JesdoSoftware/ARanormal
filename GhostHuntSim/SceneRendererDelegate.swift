//
//  SceneRendererDelegate.swift
//  GhostHuntSim
//
//  Created by Jesse Douglas on 2016-08-08.
//  Copyright © 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit
import CoreMotion

class SceneRendererDelegate: NSObject, SCNSceneRendererDelegate {

	private let _motionManager: CMMotionManager
	private let _sceneView: SCNView
	private let _cameraNode: SCNNode
	private let _ghostNode: SCNNode
	private let _messenger: Messenger

	private var _lastHeartbeatTime: NSTimeInterval = 0

	init(motionManager: CMMotionManager, sceneView: SCNView, cameraNode: SCNNode,
	        ghostNode: SCNNode, messenger: Messenger) {
		_motionManager = motionManager
		_sceneView = sceneView
		_cameraNode = cameraNode
		_ghostNode = ghostNode
		_messenger = messenger
	}

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		updateCamera()
		publishIsGhostInViewMessage()
		publishHeartbeatMessageForTime(time)
	}

	private func updateCamera() {
		let quaternion: SCNQuaternion

		if let deviceMotion = _motionManager.deviceMotion {
			let currentAttitude = deviceMotion.attitude
			quaternion = SCNQuaternion(currentAttitude.quaternion.x,
					currentAttitude.quaternion.y,
					currentAttitude.quaternion.z,
					currentAttitude.quaternion.w)
		}
		else {
			quaternion = SCNQuaternion()
		}
		_cameraNode.orientation = quaternion
	}

	private func publishIsGhostInViewMessage() {
		if _sceneView.isNodeInsideFrustum(_ghostNode, withPointOfView: _sceneView.pointOfView!) {
			_messenger.publishMessage(IsGhostInViewMessage(isInView: true))
		} else {
			_messenger.publishMessage(IsGhostInViewMessage(isInView: false))
		}
	}

	private func publishHeartbeatMessageForTime(time: NSTimeInterval) {
		if time > _lastHeartbeatTime + 1 {
			_messenger.publishMessage(HeartbeatMessage(time: time))
			_lastHeartbeatTime = time
		}
	}
}