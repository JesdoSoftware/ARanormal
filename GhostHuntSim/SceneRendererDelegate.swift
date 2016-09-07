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

    private let motionManager: CMMotionManager
    private let sceneView: SCNView
    private let cameraNode: SCNNode
    private let ghostNode: SCNNode
    private let messenger: Messenger

    private var lastHeartbeatTime: NSTimeInterval = 0

    init(motionManager: CMMotionManager, sceneView: SCNView, cameraNode: SCNNode, ghostNode: SCNNode,
         messenger: Messenger) {
        self.motionManager = motionManager
        self.sceneView = sceneView
        self.cameraNode = cameraNode
        self.ghostNode = ghostNode
        self.messenger = messenger
    }

    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        updateCamera()
        publishIsGhostInViewMessage()
        publishHeartbeatMessageForTime(time)
    }

    private func updateCamera() {
        let quaternion: SCNQuaternion

        if let deviceMotion = motionManager.deviceMotion {
            let currentAttitude = deviceMotion.attitude
            quaternion = SCNQuaternion(currentAttitude.quaternion.x,
                    currentAttitude.quaternion.y,
                    currentAttitude.quaternion.z,
                    currentAttitude.quaternion.w)
        }
        else {
            quaternion = SCNQuaternion()
        }
        cameraNode.orientation = quaternion
    }

    private func publishIsGhostInViewMessage() {
        if sceneView.isNodeInsideFrustum(ghostNode, withPointOfView: sceneView.pointOfView!) {
            messenger.publishMessage(IsGhostInViewMessage(isInView: true))
        } else {
            messenger.publishMessage(IsGhostInViewMessage(isInView: false))
        }
    }

    private func publishHeartbeatMessageForTime(time: NSTimeInterval) {
        if time > lastHeartbeatTime + 1 {
            messenger.publishMessage(HeartbeatMessage(time: time))
            lastHeartbeatTime = time
        }
    }
}