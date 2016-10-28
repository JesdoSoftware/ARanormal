//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit
import AVFoundation

public class GhostController: MessengerSubscriber {

    public var isActive: Bool = true

    private let ghostNode: SCNNode
    private let ghostPivotNode: SCNNode
    private let soundNode: SCNNode
    private let soundPivotNode: SCNNode
    private let messenger: Messenger
    private let yesNoResponses: [YesNoResponse]
    private let verbalResponses: [VerbalResponse]

    private var soundManifestations: ManifestationSet! = nil
    private var flashlightManifestations: ManifestationSet! = nil
    private var visibilityManifestations: ManifestationSet! = nil

    private var visibility: Double = 0.25
    private var activity: Double = 0
    private var height: CGFloat = 0

    init(ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode, soundPivotNode: SCNNode,
            messenger: Messenger, yesNoResponses: [YesNoResponse], verbalResponses: [VerbalResponse]) {
        self.ghostNode = ghostNode
        self.ghostPivotNode = ghostPivotNode
        self.soundNode = soundNode
        self.soundPivotNode = soundPivotNode
        self.messenger = messenger
        self.yesNoResponses = yesNoResponses
        self.verbalResponses = verbalResponses

        initializeManifestations()
    }

    private func initializeManifestations() {
        initializeSoundManifestations()

        let flashlightFlickerManifestation = FlashlightFlickerManifestation(minimumActivityLevel: 1,
                messenger: messenger)
        let flashlightOffManifestation = FlashlightOffManifestation(minimumActivityLevel: 5,
                messenger: messenger)
        flashlightManifestations = ManifestationSet(
                manifestations: [flashlightFlickerManifestation, flashlightOffManifestation],
                chancePerSixty: 1)

        let orbVisibilityManifestation = OrbVisibilityManifestation(minimumActivityLevel: 1, ghostNode: ghostNode,
                visibility: 0.01, messenger: messenger)
        let shadowVisibilityManifestation = FigureVisibilityManifestation(minimumActivityLevel: 1, ghostNode: ghostNode,
                visibility: 0.025, messenger: messenger, filename: "Ghost.png", width: 12, height: 24)
        let eyesVisibilityManifestation = FigureVisibilityManifestation(minimumActivityLevel: 1, ghostNode: ghostNode,
                visibility: 0.1, messenger: messenger, filename: "Eyes.png", width: 12, height: 12)
        visibilityManifestations = ManifestationSet(
                manifestations: [orbVisibilityManifestation,
                                 shadowVisibilityManifestation,
                                 eyesVisibilityManifestation],
                chancePerSixty: 1)
    }

    private func initializeSoundManifestations() {
        let crash1SoundManifestation = SoundManifestation(minimumActivityLevel: 2,
                soundFileName: "Crash1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let crash2SoundManifestation = SoundManifestation(minimumActivityLevel: 2,
                soundFileName: "Crash2",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let crash4SoundManifestation = SoundManifestation(minimumActivityLevel: 2,
                soundFileName: "Crash4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let footsteps1SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Footsteps1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let footsteps5SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Footsteps5",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let footsteps6SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Footsteps6",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let footsteps7SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Footsteps7",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let footsteps8SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Footsteps8",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let giggling1SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Giggling1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let giggling2SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Giggling2",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let growling1SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Growling1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let growling2SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Growling2",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let growling3SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Growling3",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let growling4SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Growling4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let knocking4SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Knocking4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let knocking5SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Knocking5",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let knocking1SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "knocking-angry",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let scratching3SoundManifestation = SoundManifestation(minimumActivityLevel: 2,
                soundFileName: "Scratching3",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let scratching4SoundManifestation = SoundManifestation(minimumActivityLevel: 2,
                soundFileName: "Scratching4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let scratching5SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Scratching5",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let screaming1SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Screaming1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let screaming2SoundManifestation = SoundManifestation(minimumActivityLevel: 5,
                soundFileName: "Screaming2",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let screaming3SoundManifestation = SoundManifestation(minimumActivityLevel: 4,
                soundFileName: "Screaming3",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let whispering1SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Whispering1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let whispering4SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Whispering4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let whispering6SoundManifestation = SoundManifestation(minimumActivityLevel: 3,
                soundFileName: "Whispering6",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let creaking1SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Creaking1",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let creaking2SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Creaking2",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let creaking3SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Creaking3",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let creaking4SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Creaking4",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        let creaking5SoundManifestation = SoundManifestation(minimumActivityLevel: 1,
                soundFileName: "Creaking5",
                soundNode: soundNode,
                soundPivotNode: soundPivotNode)
        soundManifestations = ManifestationSet(manifestations: [crash1SoundManifestation,
                                                                crash2SoundManifestation,
                                                                crash4SoundManifestation,
                                                                footsteps1SoundManifestation,
                                                                footsteps5SoundManifestation,
                                                                footsteps6SoundManifestation,
                                                                footsteps7SoundManifestation,
                                                                footsteps8SoundManifestation,
                                                                giggling1SoundManifestation,
                                                                giggling2SoundManifestation,
                                                                growling1SoundManifestation,
                                                                growling2SoundManifestation,
                                                                growling3SoundManifestation,
                                                                growling4SoundManifestation,
                                                                knocking4SoundManifestation,
                                                                knocking5SoundManifestation,
                                                                knocking1SoundManifestation,
                                                                scratching3SoundManifestation,
                                                                scratching4SoundManifestation,
                                                                scratching5SoundManifestation,
                                                                screaming1SoundManifestation,
                                                                screaming2SoundManifestation,
                                                                screaming3SoundManifestation,
                                                                whispering1SoundManifestation,
                                                                whispering4SoundManifestation,
                                                                whispering6SoundManifestation,
                                                                creaking1SoundManifestation,
                                                                creaking2SoundManifestation,
                                                                creaking3SoundManifestation,
                                                                creaking4SoundManifestation,
                                                                creaking5SoundManifestation],
                chancePerSixty: 1)
    }

    public func processMessage(message: AnyObject) {
        if !isActive {
            return
        }

        if message is HeartbeatMessage {
            moveGhost()
            manifestSound()
            manifestFlashlightEffect()
            manifestVisibility()
        } else if message is UtteranceMessage {
            activity += 0.05
            messenger.publishMessage(ActivityChangedMessage(activity: activity))
        } else if let phraseRecognizedMessage = message as? PhraseRecognizedMessage {
            respondToPhrase(phraseRecognizedMessage.phrase)
        }
    }

    private func moveGhost() {
        let rnd = (1...10).randomInt()
        if rnd == 1 {
            var newHeight = CGFloat((-3...3).randomInt()) / 3
            if newHeight > 1 {
                newHeight = 1
            } else if newHeight < 0 {
                newHeight = 0
            }
            let xRotation = newHeight - height
            let zRotation = CGFloat((-2...2).randomInt())

            ghostPivotNode.removeAllActions()
            ghostPivotNode.runAction(SCNAction.rotateByX(xRotation, y: 0, z: zRotation, duration: 1))

            height = newHeight
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

    private func respondToPhrase(phrase: String) {
        for verbalResponse in verbalResponses {
            if let response = verbalResponse.respondToPhrase(phrase) {
                messenger.publishMessage(VerbalResponseMessage(response: response))
                return
            }
        }
        for yesNoResponse in yesNoResponses {
            if let response = yesNoResponse.respondToPhrase(phrase) {
                messenger.publishMessage(YesNoResponseMessage(response: response))
            }
        }
    }
}
