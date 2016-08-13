//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class GhostController {

	public let ghost: Ghost

	private let _ghostNode: SCNNode
	private let _ghostPivotNode: SCNNode

	init(ghostNode: SCNNode, ghostPivotNode: SCNNode) {
		_ghostNode = ghostNode
		_ghostPivotNode = ghostPivotNode

		ghost = Ghost()
	}

	public func updateAtTime(time: NSTimeInterval) {

	}
}
