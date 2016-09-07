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
    private var visibilityManifestations: ManifestationSet! = nil

    private var visibility: Double = 0.25
    private var activity: Double = 0

    init(ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode, soundPivotNode: SCNNode,
            messenger: Messenger) {
        self.ghostNode = ghostNode
        self.ghostPivotNode = ghostPivotNode
        self.soundNode = soundNode
        self.soundPivotNode = soundPivotNode
        self.messenger = messenger

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

        let orbVisibilityManifestation = OrbVisibilityManifestation(minimumActivityLevel: 1, ghostNode: ghostNode,
                visibility: 0.25)
        visibilityManifestations = ManifestationSet(manifestations: [orbVisibilityManifestation], chancePerSixty: 1)
    }

    public func processMessage(message: AnyObject) {
        if message is HeartbeatMessage {
            moveGhost()
            manifestSound()
            manifestFlashlightEffect()
            manifestVisibility()
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

    private func manifestVisibility() {
        if let manifestation = visibilityManifestations.getManifestation(activity) {
            manifestation.manifest()
        }
    }
}
