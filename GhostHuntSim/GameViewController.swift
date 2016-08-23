//
//  GameViewController.swift
//  GhostHuntSim
//
//  Created by Jesse Douglas on 2016-08-04.
//  Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

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

		startCapturingVideo()
		let motionManager = createMotionManager()
		let (sceneView, cameraNode, ghostNode, ghostPivotNode, soundNode, soundPivotNode) = setUpSceneView()

		let messenger = Messenger()

		let hudController = HUDController(sceneView: sceneView)
		messenger.addSubscriber(hudController)

		let ghostController = GhostController(ghostNode: ghostNode, ghostPivotNode: ghostPivotNode,
				soundNode: soundNode, soundPivotNode: soundPivotNode, messenger: messenger)
		messenger.addSubscriber(ghostController)

		voiceController = VoiceController(words: ["HELLO", "COOL", "HOW DID YOU DIE"], messenger: messenger)
		voiceController!.startListening()

		sceneRendererDelegate = SceneRendererDelegate(motionManager: motionManager, sceneView: sceneView,
				cameraNode: cameraNode, ghostNode: ghostNode, messenger: messenger)
		sceneView.delegate = sceneRendererDelegate!
	}

	override func shouldAutorotate() -> Bool {
		return false
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			return .AllButUpsideDown
		} else {
			return .All
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}

	private func startCapturingVideo() {
		avCaptureSession = AVCaptureSession()
		avCaptureSession!.sessionPreset = AVCaptureSessionPresetMedium

		let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		do {
			try captureDevice.lockForConfiguration()
//			captureDevice.setExposureModeCustomWithDuration(captureDevice.activeFormat.maxExposureDuration,
//					ISO: captureDevice.activeFormat.maxISO,
//					completionHandler: nil)
			try captureDevice.setTorchModeOnWithLevel(0.1)
			captureDevice.unlockForConfiguration()
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
	}

	private func setUpSceneView() ->
			(sceneView: SCNView, cameraNode: SCNNode, ghostNode: SCNNode, ghostPivotNode: SCNNode, soundNode: SCNNode,
			 soundPivotNode: SCNNode) {
		// create a new scene
		let scene = SCNScene()

		// create and add a camera to the scene
		let cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		scene.rootNode.addChildNode(cameraNode)

		// place the camera
		cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

		// create and add a light to the scene
		let lightNode = SCNNode()
		lightNode.light = SCNLight()
		lightNode.light!.type = SCNLightTypeOmni
		lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
		scene.rootNode.addChildNode(lightNode)

		// create and add an ambient light to the scene
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light!.type = SCNLightTypeAmbient
		ambientLightNode.light!.color = UIColor.darkGrayColor()
		scene.rootNode.addChildNode(ambientLightNode)

		let orb = SCNSphere(radius: 2)
		let ghostNode = SCNNode(geometry: orb)
		let ghostPivotNode = SCNNode()
		ghostPivotNode.addChildNode(ghostNode)
		ghostNode.position = SCNVector3Make(0, 50, 50)
		scene.rootNode.addChildNode(ghostPivotNode)

		let soundNode = SCNNode()
		let soundPivotNode = SCNNode()
		soundPivotNode.addChildNode(soundNode)
		soundNode.position = SCNVector3Make(0, 50, 50)
		scene.rootNode.addChildNode(soundPivotNode)

		// retrieve the SCNView
		let scnView = SCNView(frame: view.bounds)
		view.addSubview(scnView)

		// set the scene to the view
		scnView.scene = scene

		// allows the user to manipulate the camera
		scnView.allowsCameraControl = false

		// show statistics such as fps and timing information
		scnView.showsStatistics = true

		scnView.backgroundColor = UIColor.clearColor()
		scnView.playing = true

		return (scnView, cameraNode, ghostNode, ghostPivotNode, soundNode, soundPivotNode)
	}

	private func createMotionManager() -> CMMotionManager {
		let motionManager = CMMotionManager()
		motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
		motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XTrueNorthZVertical)

		return motionManager
	}
}
