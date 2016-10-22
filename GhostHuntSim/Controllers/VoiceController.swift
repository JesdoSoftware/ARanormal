//
// Created by Jesse Douglas on 2016-08-11.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class VoiceController: NSObject, OEEventsObserverDelegate {

    private let messenger: Messenger

    private let openEarsEventsObserver: OEEventsObserver
    private let acousticModel = "AcousticModelEnglish"
    private let languageModelPath: String
    private let dictionaryPath: String

    init(words: [String], messenger: Messenger) {
        self.messenger = messenger

        openEarsEventsObserver = OEEventsObserver()

        let languageModelFileName = "GhostHuntSimLanguageModelFile"
        let languageModelGenerator = OELanguageModelGenerator()
        languageModelGenerator.generateRejectingLanguageModelFromArray(words,
                withFilesNamed: languageModelFileName,
                withOptionalExclusions: nil,
                usingVowelsOnly: false,
                withWeight: nil,
                forAcousticModelAtPath: OEAcousticModel.pathToModel(acousticModel))
        languageModelPath =
                languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(languageModelFileName)
        dictionaryPath =
                languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(languageModelFileName)

        super.init()

        openEarsEventsObserver.delegate = self
    }

    deinit {
        stopListening()
    }

    public func pocketsphinxDidReceiveHypothesis(hypothesis: String, recognitionScore: String, utteranceID: String) {
        messenger.publishMessage(PhraseRecognizedMessage(phrase: hypothesis))
        print("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
    }

    public func pocketsphinxDidStartListening() {
        print("Pocketsphinx is now listening.")
    }

    public func pocketsphinxDidDetectSpeech() {
        print("Pocketsphinx has detected speech.")
    }

    public func pocketsphinxDidDetectFinishedSpeech() {
        messenger.publishMessage(UtteranceMessage())
        print("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }

    public func pocketsphinxDidStopListening() {
        print("Pocketsphinx has stopped listening.")
    }

    public func pocketsphinxDidSuspendRecognition() {
        print("Pocketsphinx has suspended recognition.")
    }

    public func pocketsphinxDidResumeRecognition() {
        print("Pocketsphinx has resumed recognition.")
    }

    public func startListening() {
        do {
            try OEPocketsphinxController.sharedInstance().setActive(true)
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(languageModelPath,
                    dictionaryAtPath: dictionaryPath,
                    acousticModelAtPath: OEAcousticModel.pathToModel(acousticModel),
                    languageModelIsJSGF: false)
        } catch { }
    }

    public func stopListening() {
        OEPocketsphinxController.sharedInstance().stopListening()
    }
}
