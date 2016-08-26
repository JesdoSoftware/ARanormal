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

	private var soundManifestations: ManifestationSet! = nil
	private var flashlightManifestations: ManifestationSet! = nil

	private var visibility: Double = 0.25
	private var activity: Double = 0

	init(ghostNode gn: SCNNode, ghostPivotNode gpn: SCNNode, soundNode sn: SCNNode, soundPivotNode spn: SCNNode,
	        messenger m: Messenger) {
		ghostNode = gn
		ghostPivotNode = gpn
		soundNode = sn
		soundPivotNode = spn
		messenger = m

		initializeManifestations()
	}

	private func initializeManifestations() {
		let knockingSoundManifestation = SoundManifestation(minimumActivityLevel: 1,
				soundFileName: "knocking-angry.caf",
				soundNode: soundNode,
				soundPivotNode: soundPivotNode)
		soundManifestations = ManifestationSet(manifestations: [knockingSoundManifestation],
				chancePerSixty: 1)

		let flashlightFlickerManifestation = FlashlightFlickerManifestation(minimumActivityLevel: 1,
				messenger: messenger)
		let flashlightOffManifestation = FlashlightOffManifestation(minimumActivityLevel: 1,
				messenger: messenger)
		flashlightManifestations = ManifestationSet(
				manifestations: [flashlightFlickerManifestation, flashlightOffManifestation],
				chancePerSixty: 1)
	}

	public func processMessage(message: AnyObject) {
		ghostNode.opacity = CGFloat(visibility)

		if message is HeartbeatMessage {
			moveGhost()
			manifestSound()
			manifestFlashlightEffect()
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

	private func manifestSound() {
		if let manifestation = soundManifestations.getManifestation(activity) {
			manifestation.manifest()
		}
	}

	private func manifestFlashlightEffect() {
		if let manifestation = flashlightManifestations.getManifestation(activity) {
			manifestation.manifest()
		}
	}
}
