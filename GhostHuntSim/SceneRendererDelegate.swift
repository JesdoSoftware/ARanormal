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
	private let _ghostController: GhostController
	private let _temperatureController: TemperatureController
	private let _hudController: HUDController

	init(motionManager: CMMotionManager, cameraNode: SCNNode, ghostController: GhostController,
	        temperatureController: TemperatureController, hudController: HUDController) {
		_motionManager = motionManager
		_cameraNode = cameraNode
		_ghostController = ghostController
		_temperatureController = temperatureController
		_hudController = hudController
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

		_ghostController.updateAtTime(time)
		_temperatureController.updateAtTime(time)

		_hudController.setEmfRating(_ghostController.ghost.activity)
	}
}