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

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    private var avCaptureSession: AVCaptureSession?
    private var avCaptureDeviceInput: AVCaptureDeviceInput?
    private var sceneRendererDelegate: SceneRendererDelegate?

    private var voiceController: VoiceController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = startCapturingVideo()
        let motionManager = createMotionManager()
        let (sceneView, cameraNode, ghostNode, ghostPivotNode, soundNode, soundPivotNode) = setUpSceneView()

        let messenger = Messenger()

        let hudController = HUDController(sceneView: sceneView, messenger: messenger)
        messenger.addSubscriber(hudController)

        let yesNoResponses = [
                YesNoResponse(requiredWords: ["LEAVE"], response: true),
                YesNoResponse(requiredWords: ["LIKE", "HERE"], response: false)
        ]

        let verbalResponses = [
                VerbalResponse(requiredWords: ["HOW", "YOU", "DIE"], response: "FIRE")
        ]

        let ghostController = GhostController(ghostNode: ghostNode, ghostPivotNode: ghostPivotNode,
                soundNode: soundNode, soundPivotNode: soundPivotNode, messenger: messenger,
                yesNoResponses: yesNoResponses, verbalResponses: verbalResponses)
        messenger.addSubscriber(ghostController)

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

        let previewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession!)
        previewLayer.frame = view.bounds
        previewLayer.opaque = true
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait

        view.layer.addSublayer(previewLayer)
        avCaptureSession!.startRunning()

        return captureDevice
    }

    private func setUpSceneView() ->
            (sceneView: SCNView, cameraNode: SCNNode, ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode,
             soundPivotNode: SCNNode) {
        let scene = SCNScene()

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)

        let ghostNode = SCNNode()
        ghostNode.geometry = SCNSphere(radius: 0)
        ghostNode.opacity = 0
        let ghostPivotNode = SCNNode()
        ghostPivotNode.addChildNode(ghostNode)
        ghostNode.position = SCNVector3Make(0, 50, 50)
        ghostNode.eulerAngles = SCNVector3Make(0, 0, 3.14159)
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
}
