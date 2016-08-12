//
// Created by Jesse Douglas on 2016-08-11.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class VoiceController: NSObject, OEEventsObserverDelegate {

	private let _acousticModel = "AcousticModelEnglish"

	private let _openEarsEventsObserver: OEEventsObserver
	private let _languageModelPath: String
	private let _dictionaryPath: String

	init(words: [String]) {
		// TODO: check for/request permissions

		_openEarsEventsObserver = OEEventsObserver()

		let languageModelFileName = "GhostHuntSimLanguageModelFile"
		let languageModelGenerator = OELanguageModelGenerator()
		languageModelGenerator.generateLanguageModelFromArray(words,
				withFilesNamed: languageModelFileName,
				forAcousticModelAtPath: OEAcousticModel.pathToModel(_acousticModel))
		_languageModelPath = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(languageModelFileName)
		_dictionaryPath = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(languageModelFileName)

		super.init()

		_openEarsEventsObserver.delegate = self
	}

	deinit {
		stopListening()
	}

	public func pocketsphinxDidReceiveHypothesis(hypothesis: String, recognitionScore: String, utteranceID: String) {
//        if hypothesis == currentWord {
//            //do what you want here when the correct word is recognized
//        }
		print("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
	}

	public func pocketsphinxDidStartListening() {
		print("Pocketsphinx is now listening.")
	}

	public func pocketsphinxDidDetectSpeech() {
		print("Pocketsphinx has detected speech.")
	}

	public func pocketsphinxDidDetectFinishedSpeech() {
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
			OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(_languageModelPath,
					dictionaryAtPath: _dictionaryPath,
					acousticModelAtPath: OEAcousticModel.pathToModel(_acousticModel),
					languageModelIsJSGF: false)
		} catch { }
	}

	public func stopListening() {
		OEPocketsphinxController.sharedInstance().stopListening()
	}
}
