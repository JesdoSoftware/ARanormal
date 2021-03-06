//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SpriteKit

class HUDScene: SKScene {

    var controller: HUDController?

    private var screenWidth: CGFloat = 375
    private var screenHeight: CGFloat = 667

    private let temperatureHighTexture = SKTexture(imageNamed: "basic1-164_temperature_high.png")
    private let temperatureLowTexture = SKTexture(imageNamed: "basic1-165_temperature_low.png")
    private let flashlightOnTexture = SKTexture(imageNamed: "basic2-175_light_bulb_on.png")
    private let flashlightOffTexture = SKTexture(imageNamed: "basic2-174_light_bulb.png")
    private let cameraTexture = SKTexture(imageNamed: "basic1-097_camera_photography.png")
    private let cameraDisabledTexture = SKTexture(imageNamed: "basic1-097_camera_photography_disabled.png")
    private let emfGaugeTexture = SKTexture(imageNamed: "basic2-293_dashboard_gauge.png")
//    private let yesNoTexture = SKTexture(imageNamed: "basic2-072_thumbs_up_like.png")
    private let itcTexture = SKTexture(imageNamed: "basic2-001_comment_bubble_chat.png")

    private var temperatureIndicator: SKSpriteNode! = nil
    private var emfIndicator: SKLabelNode! = nil
    private var flashlightButton: SKSpriteNode? = nil
    private var yesNoIndicator: SKLabelNode! = nil
    private var verbalResponseIndicator: SKLabelNode! = nil
    private var cameraButton: SKSpriteNode! = nil
    private var scoreIndicator: SKLabelNode! = nil
    private var dialogBox: SKSpriteNode! = nil
    private var score: Int = 0
    private var isCameraEnabled = true

    private var dialogView: SKView! = nil
    private var dialogText: MultilineLabel! = nil
    private var dialogButton: SKSpriteNode! = nil
    private var dialogButtonText: SKLabelNode! = nil
    private var isDialogDisplayed: Bool = false

    override func didMoveToView(view: SKView) {
        screenWidth = view.frame.width
        screenHeight = view.frame.height

        let emfIcon = SKSpriteNode(texture: emfGaugeTexture)
        emfIcon.position = CGPoint(x: 50, y: screenHeight - 50)
        addChild(emfIcon)
        emfIndicator = SKLabelNode(text: "0.0 mG")
        emfIndicator.position = CGPoint(x: 125, y: screenHeight - 50)
        emfIndicator.fontName = "Helvetica-Bold"
        emfIndicator.fontSize = 24
        emfIndicator.verticalAlignmentMode = .Center
        addChild(emfIndicator)

        temperatureIndicator = SKSpriteNode(texture: temperatureHighTexture)
        temperatureIndicator.position = CGPoint(x: screenWidth - 50, y: screenHeight - 50)
        addChild(temperatureIndicator)

        if isTorchAvailable() {
            flashlightButton = SKSpriteNode(texture: flashlightOnTexture)
            flashlightButton!.position = CGPoint(x: 75, y: 200)
            addChild(flashlightButton!)
        }

//        let yesNoIcon = SKSpriteNode(texture: yesNoTexture)
//        yesNoIcon.position = CGPoint(x: screenWidth - 50, y: screenHeight - 125)
//        addChild(yesNoIcon)

        let itcIcon = SKSpriteNode(texture: itcTexture)
        itcIcon.position = CGPoint(x: screenWidth - 50, y: screenHeight - 125)
        addChild(itcIcon)

        yesNoIndicator = SKLabelNode(text: "")
        yesNoIndicator.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        yesNoIndicator.fontName = "SCM Zephyr Deluxe"
        yesNoIndicator.fontSize = 48
        yesNoIndicator.verticalAlignmentMode = .Center
        addChild(yesNoIndicator)

        verbalResponseIndicator = SKLabelNode(text: "")
        verbalResponseIndicator.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        verbalResponseIndicator.fontName = "SCM Zephyr Deluxe"
        verbalResponseIndicator.fontSize = 48
        verbalResponseIndicator.verticalAlignmentMode = .Center
        addChild(verbalResponseIndicator)

        cameraButton = SKSpriteNode(texture: cameraTexture)
        cameraButton.position = CGPoint(x: 75, y: 75)
        addChild(cameraButton)

        scoreIndicator = SKLabelNode(text: "$\(score)")
        scoreIndicator.position = CGPoint(x: screenWidth - 75, y: 75)
        scoreIndicator.fontName = "Helvetica-Bold"
        scoreIndicator.fontSize = 24
        scoreIndicator.horizontalAlignmentMode = .Center
        scoreIndicator.verticalAlignmentMode = .Center
        addChild(scoreIndicator)

        setUpDialogView()
    }

    private func setUpDialogView() {
        let dialogWidth = CGFloat(300)
        let dialogHeight = CGFloat(320)
        let dialogX: CGFloat = (screenWidth / 2) - (dialogWidth / 2)
        let dialogY: CGFloat = (screenHeight / 2) - (dialogHeight / 2)
        let fontName = "SCM Zephyr Deluxe"
        let fontSize: CGFloat = 24
        let labelMargin: CGFloat = 10
        let buttonHeight: CGFloat = 50
        let borderWidth: CGFloat = 1

        dialogView = SKView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        dialogView.allowsTransparency = true

        let dialogScene = SKScene(size: CGSize(width: screenWidth, height: screenHeight))
        dialogScene.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        let dialogBackground = SKShapeNode(rect: CGRect(x: dialogX, y: dialogY, width: dialogWidth,
                height: dialogHeight))
        dialogBackground.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
        dialogBackground.lineWidth = borderWidth
        dialogBackground.strokeColor = UIColor.whiteColor()
        dialogScene.addChild(dialogBackground)

        dialogText = MultilineLabel(text: "", labelWidth: Int(dialogWidth - (labelMargin * 2)),
                pos: CGPoint(x: screenWidth / 2, y: dialogY + (dialogHeight - labelMargin)), fontName: fontName,
                fontSize: fontSize, fontColor: SKColor.whiteColor(), leading: Int(fontSize))
        dialogBackground.addChild(dialogText)

        dialogButtonText = SKLabelNode(text: "")
        dialogButtonText.fontName = fontName
        dialogButtonText.fontSize = 24
        dialogButtonText.fontColor = UIColor.whiteColor()
        dialogButtonText.horizontalAlignmentMode = .Center
        dialogButtonText.verticalAlignmentMode = .Center

        dialogButton = SKSpriteNode(color: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8),
                size: CGSize(width: dialogWidth - (borderWidth * 2), height: buttonHeight))
        dialogButton.position = CGPoint(x: screenWidth / 2.0,
                y: (dialogY + (buttonHeight / 2) + borderWidth))
        dialogButton.addChild(dialogButtonText)
        dialogScene.addChild(dialogButton)

        dialogView.presentScene(dialogScene)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

            if isDialogDisplayed {
                if dialogButton.containsPoint(location) {
                    hideDialog()
                    controller?.onDialogDismissed()
                }
            } else {
                if flashlightButton != nil && flashlightButton!.containsPoint(location) {
                    controller?.toggleFlashlight()
                } else if isCameraEnabled && cameraButton.containsPoint(location) {
                    controller?.takePicture()
                }
            }
        }
        super.touchesEnded(touches, withEvent: event)
    }

    func decreaseTemperature() {
        temperatureIndicator.texture = temperatureLowTexture
    }

    func increaseTemperature() {
        temperatureIndicator.texture = temperatureHighTexture
    }

    func setEmfRating(emfRating: Double) {
        emfIndicator.text = String(format: "%.1f", emfRating) + " mG"
    }

    func setFlashlightIndicatorOn(isOn: Bool) {
        if isOn {
            flashlightButton?.texture = flashlightOnTexture
        }
        else {
            flashlightButton?.texture = flashlightOffTexture
        }
    }

    func indicateYesNoResponse(isYes: Bool) {
        if isYes {
            yesNoIndicator.text = "YES"
        } else {
            yesNoIndicator.text = "NO"
        }
    }

    func clearYesNoIndicator() {
        yesNoIndicator.text = ""
    }

    func indicateVerbalResponse(response: String) {
        verbalResponseIndicator.text = response
    }

    func clearVerbalResponseIndicator() {
        verbalResponseIndicator.text = ""
    }

    func getScore() -> Int {
        return score
    }

    func increaseScoreBy(amount: Int) {
        score += amount
        scoreIndicator.text = "$\(score)"
    }

    func setCameraEnabled(isEnabled: Bool) {
        isCameraEnabled = isEnabled

        if isEnabled == false {
            cameraButton.texture = cameraDisabledTexture
        } else {
            cameraButton.texture = cameraTexture
        }
    }

    func showDialogWithText(text: String, buttonText: String) {
        dialogText.text = text
        dialogButtonText.text = buttonText

        view!.addSubview(dialogView)
        isDialogDisplayed = true
    }

    private func hideDialog() {
        dialogText.text = ""
        dialogView.removeFromSuperview()
        isDialogDisplayed = false
    }
}
