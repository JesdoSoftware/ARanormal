//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class GhostController: MessengerSubscriber {

	private let ghostNode: SCNNode
	private let ghostPivotNode: SCNNode
	private let soundNode: SCNNode
	private let soundPivotNode: SCNNode
	private let messenger: Messenger

	private var visibility: Double = 0.25
	private var activity: Double = 0

	init(ghostNode gn: SCNNode, ghostPivotNode gpn: SCNNode, soundNode sn: SCNNode, soundPivotNode spn: SCNNode,
	        messenger m: Messenger) {
		ghostNode = gn
		ghostPivotNode = gpn
		soundNode = sn
		soundPivotNode = spn
		messenger = m
	}

	public func processMessage(message: AnyObject) {
		ghostNode.opacity = CGFloat(visibility)

		if message is HeartbeatMessage {
			moveGhost()
			playSound()
			flickerFlashlight()
		} else if let wordRecognizedMessage = message as? WordRecognizedMessage {
			activity += 1
			messenger.publishMessage(ActivityChangedMessage(activity: activity))
		}
	}

	private func moveGhost() {
		let rnd = (1...10).randomInt()
		if rnd == 1 {
			let rotation = (-2...2).randomInt()
			ghostPivotNode.removeAllActions()
			ghostPivotNode.runAction(SCNAction.rotateByX(0, y: 0, z: CGFloat(rotation), duration: 1))
		}
	}

	private func playSound() {
		let rnd = (1...10).randomInt()
		if rnd == 1 {
			let rotation = (-2...2).randomInt()
			soundPivotNode.removeAllActions()
			soundPivotNode.runAction(SCNAction.rotateByX(0, y: 0, z: CGFloat(rotation), duration: 0))

			let knockingSound = SCNAudioSource(fileNamed: "knocking-angry.caf")
			knockingSound!.positional = true
			soundNode.runAction(SCNAction.playAudioSource(knockingSound!, waitForCompletion: false))
		}
	}

	private func flickerFlashlight() {
		let rnd = (1...10).randomInt()
		if rnd == 1 {
			messenger.publishMessage(FlashlightMessage(isOn: false))

			let delayRnd = (1...8).randomInt()
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 / Double(delayRnd) * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				self.messenger.publishMessage(FlashlightMessage(isOn: true))
			}
		}
	}
}
