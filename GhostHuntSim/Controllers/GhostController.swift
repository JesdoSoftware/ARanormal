//
// Created by Jesse Douglas on 2016-08-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit
import AVFoundation

public class GhostController: MessengerSubscriber {

    private let ghostNode: SCNNode
    private let ghostPivotNode: SCNNode
    private let soundNode: SCNNode
    private let soundPivotNode: SCNNode
    private let messenger: Messenger
    private let yesNoResponses: [YesNoResponse]
    private let verbalResponses: [VerbalResponse]
    private let speechSynthesizer: AVSpeechSynthesizer

    private var soundManifestations: ManifestationSet! = nil
    private var flashlightManifestations: ManifestationSet! = nil
    private var visibilityManifestations: ManifestationSet! = nil

    private var visibility: Double = 0.25
    private var activity: Double = 0

    init(ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode, soundPivotNode: SCNNode,
            messenger: Messenger, yesNoResponses: [YesNoResponse], verbalResponses: [VerbalResponse]) {
        self.ghostNode = ghostNode
        self.ghostPivotNode = ghostPivotNode
        self.soundNode = soundNode
        self.soundPivotNode = soundPivotNode
        self.messenger = messenger
        self.yesNoResponses = yesNoResponses
        self.verbalResponses = verbalResponses

        speechSynthesizer = AVSpeechSynthesizer()

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

    private func respondToPhrase(phrase: String) {
        // TODO: make chance of response based on activity level
        for verbalResponse in verbalResponses {
            if let response = verbalResponse.respondToPhrase(phrase) {
                messenger.publishMessage(VerbalResponseMessage(response: response))
                utterPhrase(response)
                print("Verbal response: \(response)")

                return
            }
        }
        for yesNoResponse in yesNoResponses {
            if let response = yesNoResponse.respondToPhrase(phrase) {
                messenger.publishMessage(YesNoResponseMessage(response: response))
                print("Yes/no response: \(response)")
            }
        }
    }

    private func utterPhrase(phrase: String) {
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        speechSynthesizer.speakUtterance(utterance)
    }
}
