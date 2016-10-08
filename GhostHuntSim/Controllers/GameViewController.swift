//
//  GameViewController.swift
//  GhostHuntSim
//
//  Created by Jesse Douglas on 2016-08-04.
//  Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit
import CoreMotion
import AVFoundation
import SpriteKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, MessengerSubscriber {

    private var avCaptureSession: AVCaptureSession?
    private var avCaptureDeviceInput: AVCaptureDeviceInput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    private var sceneRendererDelegate: SceneRendererDelegate?
    private var sceneView: SCNView?
    private var cameraNode: SCNNode?
    private var ghostController: GhostController?
    private var voiceController: VoiceController?

    private var darkOneSoundPlayer1: AVAudioPlayer? = nil
    private var darkOneSoundPlayer2: AVAudioPlayer? = nil
    private var darkOneSoundPlayer3: AVAudioPlayer? = nil
    private var darkOneSoundPlayer4: AVAudioPlayer? = nil
    private var darkOneSoundPlayer5: AVAudioPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = startCapturingVideo()
        let motionManager = createMotionManager()
        let (sceneView, cameraNode, ghostNode, ghostPivotNode, soundNode, soundPivotNode) = setUpSceneView()
        self.sceneView = sceneView
        self.cameraNode = cameraNode

        let messenger = Messenger()
        messenger.addSubscriber(self)

        let hudController = HUDController(sceneView: sceneView, messenger: messenger)
        messenger.addSubscriber(hudController)

        let yesNoResponses = getYesNoResponses()

        let verbalResponses = getVerbalResponses()

        ghostController = GhostController(ghostNode: ghostNode, ghostPivotNode: ghostPivotNode,
                soundNode: soundNode, soundPivotNode: soundPivotNode, messenger: messenger,
                yesNoResponses: yesNoResponses, verbalResponses: verbalResponses)
        messenger.addSubscriber(ghostController!)

        let flashlightController = FlashlightController(captureDevice: captureDevice)
        messenger.addSubscriber(flashlightController)
        messenger.publishMessage(FlashlightOnOffMessage(isOn: true))

        let requiredWords = getRequiredWordsFromYesNoResponses(yesNoResponses, verbalResponses: verbalResponses)
        voiceController = VoiceController(words: requiredWords, messenger: messenger)
        voiceController!.startListening()

        sceneRendererDelegate = SceneRendererDelegate(motionManager: motionManager, sceneView: sceneView,
                cameraNode: cameraNode, ghostNode: ghostNode, messenger: messenger)
        sceneView.delegate = sceneRendererDelegate!
    }

    private func getRequiredWordsFromYesNoResponses(yesNoResponses: [YesNoResponse],
                                                    verbalResponses:[VerbalResponse]) -> [String] {
        var requiredWords = [String]()

        for response in yesNoResponses {
            for requiredWord in response.requiredWords {
                requiredWords.append(requiredWord.uppercaseString)
            }
        }
        for response in verbalResponses {
            for requiredWord in response.requiredWords {
                requiredWords.append(requiredWord.uppercaseString)
            }
        }

        return requiredWords
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    private func startCapturingVideo() -> AVCaptureDevice {
        avCaptureSession = AVCaptureSession()
        avCaptureSession!.sessionPreset = AVCaptureSessionPresetMedium

        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            avCaptureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            avCaptureSession!.addInput(avCaptureDeviceInput)
        } catch {
            // TODO: handle error
        }

        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession!)
        cameraPreviewLayer!.frame = view.bounds
        cameraPreviewLayer!.opaque = true
        cameraPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait

        view.layer.addSublayer(cameraPreviewLayer!)
        avCaptureSession!.startRunning()

        return captureDevice
    }

    private func stopCapturingVideo() {
        avCaptureSession!.stopRunning()
        cameraPreviewLayer!.removeFromSuperlayer()
    }

    private func setUpSceneView() ->
            (sceneView: SCNView, cameraNode: SCNNode, ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode,
             soundPivotNode: SCNNode) {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3Make(0, 0, 0)

        let ghostNode = SCNNode()
        ghostNode.geometry = SCNSphere(radius: 0)
        ghostNode.opacity = 0
        let ghostPivotNode = SCNNode()
        ghostPivotNode.addChildNode(ghostNode)
        ghostNode.position = SCNVector3Make(0, 50, 0)
        ghostNode.eulerAngles = SCNVector3Make(0, 0, 3.14159)       // HACK
        ghostNode.constraints = [SCNLookAtConstraint(target: cameraNode)]
        scene.rootNode.addChildNode(ghostPivotNode)

        let soundNode = SCNNode()
        let soundPivotNode = SCNNode()
        soundPivotNode.addChildNode(soundNode)
        soundNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(soundPivotNode)

        let scnView = SCNView(frame: view.bounds)
        scnView.scene = scene
        scnView.backgroundColor = UIColor.clearColor()
        scnView.playing = true
        view.addSubview(scnView)

        scnView.allowsCameraControl = false
        scnView.showsStatistics = false

        return (scnView, cameraNode, ghostNode, ghostPivotNode, soundNode, soundPivotNode)
    }

    private func createMotionManager() -> CMMotionManager {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XTrueNorthZVertical)

        return motionManager
    }

    private func getYesNoResponses() -> [YesNoResponse] {
        let yesNoResponses = [
                YesNoResponse(requiredWords: ["ARE", "SPIRITS", "HERE"], response: true),
                YesNoResponse(requiredWords: ["ARE", "GHOSTS", "HERE"], response: true),
                YesNoResponse(requiredWords: ["LIKE", "HERE"], response: false),
                YesNoResponse(requiredWords: ["BORED"], response: true),
                YesNoResponse(requiredWords: ["WIFE", "AFFAIR"], response: false),
                YesNoResponse(requiredWords: ["MARY", "AFFAIR"], response: false),
                YesNoResponse(requiredWords: ["WIFE", "SLEEP", "WITH", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["MARY", "SLEEP", "WITH", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["WIFE", "SLEEP", "WITH", "LUKE"], response: false),
                YesNoResponse(requiredWords: ["MARY", "SLEEP", "WITH", "LUKE"], response: false),
                YesNoResponse(requiredWords: ["WIFE", "SEX", "WITH", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["MARY", "SEX", "WITH", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["WIFE", "SEX", "WITH", "LUKE"], response: false),
                YesNoResponse(requiredWords: ["MARY", "SEX", "WITH", "LUKE"], response: false),
                YesNoResponse(requiredWords: ["BROTHER", "WANT", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "WANT", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "WANT", "MARY"], response: true),
                YesNoResponse(requiredWords: ["BROTHER", "LOVE", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "LOVE", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "LOVE", "MARY"], response: true),
                YesNoResponse(requiredWords: ["BROTHER", "MARRIED"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "MARRIED"], response: true),
                YesNoResponse(requiredWords: ["ARE", "IN", "HEAVEN"], response: false),
                YesNoResponse(requiredWords: ["ARE", "IN", "HELL"], response: false),
                YesNoResponse(requiredWords: ["ARE", "IN", "LIMBO"], response: true),
                YesNoResponse(requiredWords: ["ARE", "IN", "PURGATORY"], response: true),
                YesNoResponse(requiredWords: ["ARE", "ARE", "TRAPPED"], response: true),
                YesNoResponse(requiredWords: ["WANT", "LEAVE"], response: true),
                YesNoResponse(requiredWords: ["REVENGE", "BROTHER"], response: true),
                YesNoResponse(requiredWords: ["REVENGE", "LUKE"], response: true),
                YesNoResponse(requiredWords: ["BROTHER", "KILL", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "KILL", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["LUKE", "KILL", "MARY"], response: true),
                YesNoResponse(requiredWords: ["ARE", "ALONE"], response: false),
                YesNoResponse(requiredWords: ["ARE", "OTHER", "HERE"], response: true),
                YesNoResponse(requiredWords: ["ARE", "OTHERS", "HERE"], response: true),
                YesNoResponse(requiredWords: ["DID", "KILL", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["IS", "BROTHER", "ALIVE"], response: false),
                YesNoResponse(requiredWords: ["IS", "LUKE", "ALIVE"], response: false),
                YesNoResponse(requiredWords: ["ARE", "HUMAN"], response: true),
                YesNoResponse(requiredWords: ["DOES", "HEAVEN", "EXIST"], response: true),
                YesNoResponse(requiredWords: ["DOES", "HELL", "EXIST"], response: true),
                YesNoResponse(requiredWords: ["DOES", "GOD", "EXIST"], response: true),
                YesNoResponse(requiredWords: ["DOES", "JESUS", "EXIST"], response: true),
                YesNoResponse(requiredWords: ["IS", "WIFE", "HERE"], response: false),
                YesNoResponse(requiredWords: ["IS", "MARY", "HERE"], response: false),
                YesNoResponse(requiredWords: ["IS", "BROTHER", "HERE"], response: false),
                YesNoResponse(requiredWords: ["IS", "LUKE", "HERE"], response: false),
                YesNoResponse(requiredWords: ["FORGIVE", "BROTHER"], response: false),
                YesNoResponse(requiredWords: ["FORGIVE", "LUKE"], response: false),
                YesNoResponse(requiredWords: ["DO", "MISS", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["DO", "MISS", "MARY"], response: true),
                YesNoResponse(requiredWords: ["DO", "LOVE", "WIFE"], response: true),
                YesNoResponse(requiredWords: ["DO", "LOVE", "MARY"], response: true),
                YesNoResponse(requiredWords: ["DO", "HATE", "BROTHER"], response: true),
                YesNoResponse(requiredWords: ["DO", "HATE", "LUKE"], response: true),
                YesNoResponse(requiredWords: ["WATCHING", "ME"], response: true),
        ]

        return yesNoResponses
    }

    private func getVerbalResponses() -> [VerbalResponse] {
        let verbalResponses = [
                VerbalResponse(requiredWords: ["HOW", "DIE"], response: "BROTHER"),
                VerbalResponse(requiredWords: ["WHAT", "BROTHER", "DO"], response: "STABBED"),
                VerbalResponse(requiredWords: ["WHAT", "LUKE", "DO"], response: "STABBED"),
                VerbalResponse(requiredWords: ["WHY", "BROTHER"], response: "WANTED WIFE"),
                VerbalResponse(requiredWords: ["WHY", "HERE"], response: "TRAPPED"),
                VerbalResponse(requiredWords: ["WHY", "DON'T", "LEAVE"], response: "REVENGE"),
                VerbalResponse(requiredWords: ["WHAT", "FIRST", "NAME"], response: "JOHN"),
                VerbalResponse(requiredWords: ["WHAT", "WIFE", "NAME"], response: "MARY"),
                VerbalResponse(requiredWords: ["WHAT", "BROTHER", "NAME"], response: "LUKE"),
                VerbalResponse(requiredWords: ["WHAT", "YOUR", "NAME"], response: "SMITH"),
                VerbalResponse(requiredWords: ["WHEN", "LEAVE"], response: "AFTER REVENGE"),
                VerbalResponse(requiredWords: ["WHAT", "KEEP", "HERE"], response: "REVENGE"),
                VerbalResponse(requiredWords: ["WHO", "REVENGE"], response: "BROTHER"),
                VerbalResponse(requiredWords: ["MAN", "OR", "WOMAN"], response: "MAN"),
                VerbalResponse(requiredWords: ["HOW", "MANY", "HERE"], response: "MANY"),
                VerbalResponse(requiredWords: ["HOW", "LONG", "HERE"], response: "AGES"),
                VerbalResponse(requiredWords: ["HOW", "BROTHER", "DIE"], response: "FIRE"),
                VerbalResponse(requiredWords: ["HOW", "LUKE", "DIE"], response: "FIRE"),
                VerbalResponse(requiredWords: ["WHAT", "HAPPENED", "BROTHER"], response: "FIRE"),
                VerbalResponse(requiredWords: ["WHAT", "HAPPENED", "LUKE"], response: "FIRE"),
                VerbalResponse(requiredWords: ["WHAT", "DEATH", "LIKE"], response: "DARK"),
                VerbalResponse(requiredWords: ["WHERE", "WIFE"], response: "HEAVEN"),
                VerbalResponse(requiredWords: ["WHERE", "MARY"], response: "HEAVEN"),
                VerbalResponse(requiredWords: ["WHERE", "BROTHER"], response: "HELL"),
                VerbalResponse(requiredWords: ["WHERE", "LUKE"], response: "HELL"),
                VerbalResponse(requiredWords: ["WHAT", "JOB"], response: "FARMER"),
                VerbalResponse(requiredWords: ["WHAT", "OCCUPATION"], response: "FARMER"),
                VerbalResponse(requiredWords: ["WHAT", "DO", "FOR", "LIVING"], response: "FARMER"),
                VerbalResponse(requiredWords: ["WHO", "ELSE", "HERE"], response: "DARK ONES"),
                VerbalResponse(requiredWords: ["WHAT", "DARK", "ONES", "WANT"], response: "YOU"),
                VerbalResponse(requiredWords: ["WHY", "DARK", "ONES", "HERE"], response: "WANT YOU"),
        ]

        return verbalResponses
    }

    func processMessage(message: AnyObject) {
        if let gameOverMessage = message as? GameOverMessage {
            ghostController?.isActive = false

            stopCapturingVideo()

            var darkOneNodes = [SCNNode]()

            let darkOneNode1 = createDarkOneNode(SCNVector3Make(0, 35, 0))
            darkOneNode1.eulerAngles = SCNVector3Make(1.570795, 0, 3.14159)     // HACK
            darkOneNodes.append(darkOneNode1)
            darkOneNodes.append(createDarkOneNode(SCNVector3Make(35, 25, 0)))
            darkOneNodes.append(createDarkOneNode(SCNVector3Make(35, -25, 0)))
            darkOneNodes.append(createDarkOneNode(SCNVector3Make(0, -35, 0)))
            darkOneNodes.append(createDarkOneNode(SCNVector3Make(-35, -25, 0)))
            darkOneNodes.append(createDarkOneNode(SCNVector3Make(-35, 25, 0)))
            darkOneNodes.forEach { (let darkOneNode : SCNNode) -> () in
                sceneView!.scene!.rootNode.addChildNode(darkOneNode)
            }

            dispatchAfterSeconds(3) {
                self.darkOneSoundPlayer1 = self.createDarkOneSoundPlayer("Roar1")
                self.darkOneSoundPlayer1!.play()
                self.darkOneSoundPlayer2 = self.createDarkOneSoundPlayer("Roar2")
                self.darkOneSoundPlayer2!.play()
                self.darkOneSoundPlayer3 = self.createDarkOneSoundPlayer("Roar3")
                self.darkOneSoundPlayer3!.play()
                self.darkOneSoundPlayer4 = self.createDarkOneSoundPlayer("Roar4")
                self.darkOneSoundPlayer4!.play()
                self.darkOneSoundPlayer5 = self.createDarkOneSoundPlayer("Roar5")
                self.darkOneSoundPlayer5!.play()

                dispatchAfterSeconds(3) {
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.33)

                    let position = SCNVector3Make(0, 0, 0)
                    darkOneNodes.forEach { (let darkOneNode: SCNNode) -> () in
                        darkOneNode.position = position
                    }
                    SCNTransaction.commit()

                    dispatchAfterSeconds(0.33) {
                        darkOneNodes.forEach { (let darkOneNode: SCNNode) -> () in
                            darkOneNode.hidden = true
                        }
                    }
                }
            }
        }
    }

    private func createDarkOneNode(position: SCNVector3) -> SCNNode {
        let darkOneNode = SCNNode()

        let box = SCNBox(width: 12, height: 24, length: 1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = "Eyes.png"
        box.firstMaterial = material

        darkOneNode.geometry = box
        darkOneNode.opacity = 0.5
        darkOneNode.position = position
        darkOneNode.eulerAngles = SCNVector3Make(1.570795, 0, 0)
        darkOneNode.constraints = [SCNLookAtConstraint(target: cameraNode)]

        return darkOneNode
    }

    private func createDarkOneSoundPlayer(filename: String) -> AVAudioPlayer? {
        var audioPlayer: AVAudioPlayer? = nil

        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "caf")
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
            audioPlayer!.prepareToPlay()
        } catch {
            // TODO handle error
        }

        return audioPlayer
    }
}
