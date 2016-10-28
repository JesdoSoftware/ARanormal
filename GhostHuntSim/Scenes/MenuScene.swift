//
// Created by Jesse Douglas on 2016-10-15.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {

    var gameViewController: GameViewController? = nil

    private var screenWidth: CGFloat = 375
    private var screenHeight: CGFloat = 667

    private var currentPage: MenuPage = .MainMenu
    private var isEnabled: Bool = true

    private var logo: SKLabelNode! = nil
    private var copyright: MultilineLabel! = nil
    private var aboutText: MultilineLabel! = nil
    private var soundAttributionsText: MultilineLabel! = nil
    private var permissionsText: MultilineLabel! = nil
    private var warningText: MultilineLabel! = nil
    private var playRecommendationsText: MultilineLabel! = nil

    private var playButton: SKSpriteNode! = nil
    private var aboutButton: SKSpriteNode! = nil
    private var backButton: SKSpriteNode! = nil
    private var soundAttributionsButton: SKSpriteNode! = nil
    private var okButton: SKSpriteNode! = nil
    private var letsPlayButton: SKSpriteNode! = nil

    override func didMoveToView(view: SKView) {
        screenWidth = view.frame.width
        screenHeight = view.frame.height

        createPageControls()
        showMainMenuPage()
    }

    private func createPageControls()
    {
        logo = createLabelWithText("ARanormal")
        logo.fontSize = 52
        logo.position = CGPoint(x: screenWidth / 2, y: screenHeight * 0.67)
        addChild(logo)

        playButton = createButtonWithText("Play", position: CGPoint(x: screenWidth / 2, y: (screenHeight * 0.33) + 75))
        addChild(playButton)

        aboutButton = createButtonWithText("About", position: CGPoint(x: screenWidth / 2, y: screenHeight * 0.33))
        addChild(aboutButton)

        copyright = MultilineLabel(text: "Copyright © 2016 Jesdo Software LLC.\nAll rights reserved.",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: 100), fontName: "SCM Zephyr Deluxe",
                fontSize: 16, fontColor: UIColor.whiteColor(), leading: 16)
        addChild(copyright)

        let textY: CGFloat = screenHeight * 0.67

        aboutText = MultilineLabel(text: "Copyright © 2016 Jesdo Software LLC. All rights reserved.\n\n" +
                "ARanormal uses the CMU Pocketsphinx library, the CMU Flite library, the CMU CMUCMLTK library " +
                "(http://cmusphinx.sourceforge.net) and Politepix’s OpenEars (http://www.politepix.com/openears).",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: textY), fontName: "SCM Zephyr Deluxe",
                fontSize: 14, fontColor: UIColor.whiteColor(), leading: 14)
        addChild(aboutText)

        soundAttributionsText = MultilineLabel(
                text: "ARanormal uses the following sound effects from Freesound.org.\n\n" +
                "Creative Commons Attribution License (https://creativecommons.org/licenses/by/3.0/):\n" +
                "mug crash ceramic.wav (JavierZumer)\n" +
                "Glass Smash, Bottle, A.wav (InspectorJ)\n" +
                "Bite Growl effect.wav (AndreAngelo)\n" +
                "Small Growl 2.wav (craziwolf)\n" +
                "wolf-growl.wav (newagesoup)\n" +
                "Roar.wav (CGEffex)\n" +
                "Deep Monster Roar.wav (MisterSegev)\n" +
                "Ecoed Roar (FlechaBr)\n" +
                "Scream 06.wav (AlSarcoli007)\n" +
                "Creepy Whisper - Go Outside.mp3 (acekasbo)\n" +
                "Whispers.wav (Breathe2015)\n" +
                "Ignis Aurum Dry Rev.wav (arytopia)\n" +
                "Door Squeak, Normal, C.wav (InspectorJ)\n" +
                "Creak Wood Floor 03 (f4kf4ce)\n" +
                "Creaking-chair-uni.wav (HeraclitoPD)\n\n" +
                "Creative Commons Sampling+ License (https://creativecommons.org/licenses/sampling+/1.0/):\n" +
                "growl5.wav (lendrick)\n" +
                "roar1.wav (Vegemyte)",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: textY + 100),
                fontName: "SCM Zephyr Deluxe", fontSize: 10, fontColor: UIColor.whiteColor(), leading: 10)
        addChild(soundAttributionsText)

        permissionsText = MultilineLabel(text: "ARanormal requires access to your camera and microphone to provide " +
                "an augmented reality interactive experience.",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: textY),
                fontName: "SCM Zephyr Deluxe", fontSize: 24, fontColor: UIColor.whiteColor(), leading: 24)
        addChild(permissionsText)

        warningText = MultilineLabel(text: "WARNING:\n\n" +
                "ARanormal makes use of flashing lights, moments of complete darkness, and sudden visual " +
                "and audible scares. Please use caution while playing.",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: textY + 50),
                fontName: "Helvetica-Bold", fontSize: 24, fontColor: UIColor.whiteColor(), leading: 24)
        addChild(warningText)

        playRecommendationsText = MultilineLabel(text: "ARanormal is best played in the DARK, " +
                "with headphones and a sturdy device case.",
                labelWidth: Int(screenWidth), pos: CGPoint(x: screenWidth / 2, y: textY),
                fontName: "SCM Zephyr Deluxe", fontSize: 24, fontColor: UIColor.whiteColor(), leading: 24)
        addChild(playRecommendationsText)

        let buttonY: CGFloat = screenHeight * 0.25

        backButton = createButtonWithText("Back", position: CGPoint(x: screenWidth / 4, y: buttonY), fontSize: 20)
        addChild(backButton)

        soundAttributionsButton = createButtonWithText("Attributions",
                position: CGPoint(x: (screenWidth / 4) * 3, y: buttonY), fontSize: 20)
        addChild(soundAttributionsButton)

        okButton = createButtonWithText("OK", position: CGPoint(x: screenWidth / 2, y: buttonY), fontSize: 24)
        addChild(okButton)

        letsPlayButton = createButtonWithText("Let's Play", position: CGPoint(x: screenWidth / 2, y: buttonY),
                fontSize: 24)
        addChild(letsPlayButton)

        hidePageControls()
    }

    private func createLabelWithText(text: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "SCM Zephyr Deluxe"
        label.fontSize = 24
        label.fontColor = UIColor.whiteColor()
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center

        return label
    }

    private func createButtonWithText(text: String, position: CGPoint, fontSize: CGFloat = 36) -> SKSpriteNode {
        let label = createLabelWithText(text)
        label.fontSize = fontSize

        let width = label.frame.width
        let button = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: width, height: 75))
        button.position = position

        button.addChild(label)

        return button
    }

    private func showMainMenuPage() {
        hidePageControls()
        currentPage = .MainMenu

        logo.hidden = false
        copyright.hidden = false
        playButton.hidden = false
        aboutButton.hidden = false
    }

    private func showAboutPage() {
        hidePageControls()
        currentPage = .About

        aboutText.hidden = false
        backButton.hidden = false
        soundAttributionsButton.hidden = false
    }

    private func showSoundAttributionsPage() {
        hidePageControls()
        currentPage = .SoundAttributions

        soundAttributionsText.hidden = false
        backButton.hidden = false
    }

    private func showPermissionsPage() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        let microphoneAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)

        if cameraAuthorizationStatus == .Authorized && microphoneAuthorizationStatus == .Authorized {
            showWarningPage()
            return
        } else if cameraAuthorizationStatus != .NotDetermined && microphoneAuthorizationStatus != .NotDetermined {
            showMainMenuPage()
            showPermissionRequirementAlert()
        }

        hidePageControls()
        currentPage = .Permissions

        permissionsText.hidden = false
        okButton.hidden = false
    }

    private func showWarningPage() {
        hidePageControls()
        currentPage = .Warning

        warningText.hidden = false
        okButton.hidden = false
    }

    private func showPlayRecommendationsPage() {
        hidePageControls()
        currentPage = .PlayRecommendations

        playRecommendationsText.hidden = false
        letsPlayButton.hidden = false
    }

    private func hidePageControls() {
        logo.hidden = true
        copyright.hidden = true

        aboutText.hidden = true
        soundAttributionsText.hidden = true
        permissionsText.hidden = true
        warningText.hidden = true
        playRecommendationsText.hidden = true

        playButton.hidden = true
        aboutButton.hidden = true
        backButton.hidden = true
        soundAttributionsButton.hidden = true
        okButton.hidden = true
        letsPlayButton.hidden = true
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            if isEnabled {
                let location = touch.locationInNode(self)

                if currentPage == .MainMenu {
                    if playButton.containsPoint(location) {
                        showPermissionsPage()
                    } else if aboutButton.containsPoint(location) {
                        showAboutPage()
                    }
                } else if currentPage == .About {
                    if backButton.containsPoint(location) {
                        showMainMenuPage()
                    } else if soundAttributionsButton.containsPoint(location) {
                        showSoundAttributionsPage()
                    }
                } else if currentPage == .SoundAttributions {
                    if backButton.containsPoint(location) {
                        showMainMenuPage()
                    }
                } else if currentPage == .Permissions {
                    if okButton.containsPoint(location) {
                        checkPermissions()
                    }
                } else if currentPage == .Warning {
                    if okButton.containsPoint(location) {
                        showPlayRecommendationsPage()
                    }
                } else if currentPage == .PlayRecommendations {
                    if okButton.containsPoint(location) {
                        isEnabled = false
                        hidePageControls()
                        dispatchAfterSeconds(0.5) {
                            self.gameViewController?.startGameScene()
                        }
                    }
                }
            }
        }
        super.touchesEnded(touches, withEvent: event)
    }

    private func checkPermissions() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        let microphoneAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeAudio)
        let recordPermission = AVAudioSession.sharedInstance().recordPermission()

        if cameraAuthorizationStatus == .NotDetermined {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                    completionHandler: { (videoGranted: Bool) -> Void in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.checkPermissions()
                        }
                    })
        } else if microphoneAuthorizationStatus == .NotDetermined && recordPermission != .Granted {
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio,
                    completionHandler: { (audioGranted: Bool) -> Void in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.checkPermissions()
                        }
                    })
        } else if cameraAuthorizationStatus == .Denied || cameraAuthorizationStatus == .Restricted ||
                microphoneAuthorizationStatus == .Denied || microphoneAuthorizationStatus == .Restricted {
            dispatch_async(dispatch_get_main_queue()) {
                self.showMainMenuPage()
                self.showPermissionRequirementAlert()
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.showWarningPage()
            }
        }
    }

    private func showPermissionRequirementAlert() {
        let alert = UIAlertController(title: "Permissions Required",
                message: "ARanormal requires camera and microphone permissions to provide its gameplay experience. " +
                        "Please enable these permissions in the Settings.",
                preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .Default, handler: { (alert) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }

    private enum MenuPage {
        case MainMenu
        case Permissions
        case About
        case SoundAttributions
        case Warning
        case PlayRecommendations
    }
}
