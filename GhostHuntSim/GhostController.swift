//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class GhostController: MessengerSubscriber {

	private let _ghostNode: SCNNode
	private let _ghostPivotNode: SCNNode
	private let _messenger: Messenger

	private var _visibility: Double = 0.25
	private var _activity: Double = 0

	init(ghostNode: SCNNode, ghostPivotNode: SCNNode, messenger: Messenger) {
		_ghostNode = ghostNode
		_ghostPivotNode = ghostPivotNode
		_messenger = messenger
	}

	public func processMessage(message: AnyObject) {
		_ghostNode.opacity = CGFloat(_visibility)

		if message is HeartbeatMessage {
			let rnd = arc4random_uniform(10) + 1
			if rnd == 1 {
				let rotation = Int(arc4random_uniform(5)) - 2    // random number between -2 and 2

				_ghostPivotNode.removeAllActions()
				_ghostPivotNode.runAction(SCNAction.rotateByX(0, y: 0, z: CGFloat(rotation), duration: 1))
			}
		} else if let wordRecognizedMessage = message as? WordRecognizedMessage {
			_activity += 1
			_messenger.publishMessage(ActivityChangedMessage(activity: _activity))
		}
	}
}
