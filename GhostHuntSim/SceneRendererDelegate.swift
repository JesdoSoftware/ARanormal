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
	private let _cameraNode: SCNNode
	private let _messenger: Messenger
	private let _temperatureController: TemperatureController

	private var _lastHeartbeatTime: NSTimeInterval = 0

	init(motionManager: CMMotionManager, cameraNode: SCNNode, messenger: Messenger,
	        temperatureController: TemperatureController) {
		_motionManager = motionManager
		_cameraNode = cameraNode
		_messenger = messenger

		_temperatureController = temperatureController
	}

	func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
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

		_temperatureController.updateAtTime(time)

		if time > _lastHeartbeatTime + 1 {
			_messenger.publishMessage(HeartbeatMessage(time: time))
			_lastHeartbeatTime = time
		}
	}
}