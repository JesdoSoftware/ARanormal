//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class GhostController: MessengerSubscriber {

	private let ghostNode: SCNNode
	private let ghostPivotNode: SCNNode
	private let messenger: Messenger

	private var _visibility: Double = 0.25
	private var _activity: Double = 0

	init(ghostNode gn: SCNNode, ghostPivotNode gpn: SCNNode, messenger m: Messenger) {
		ghostNode = gn
		ghostPivotNode = gpn
		messenger = m
	}

	public func processMessage(message: AnyObject) {
		ghostNode.opacity = CGFloat(_visibility)

		if message is HeartbeatMessage {
			let rnd = arc4random_uniform(10) + 1
			if rnd == 1 {
				let rotation = Int(arc4random_uniform(5)) - 2    // random number between -2 and 2

				ghostPivotNode.removeAllActions()
				ghostPivotNode.runAction(SCNAction.rotateByX(0, y: 0, z: CGFloat(rotation), duration: 1))
			}
		} else if let wordRecognizedMessage = message as? WordRecognizedMessage {
			_activity += 1
			messenger.publishMessage(ActivityChangedMessage(activity: _activity))
		}
	}
}
