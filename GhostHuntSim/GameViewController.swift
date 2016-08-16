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

	private var _avCaptureSession: AVCaptureSession?
	private var _avCaptureDeviceInput: AVCaptureDeviceInput?
	private var _sceneRendererDelegate: SceneRendererDelegate?

	private var _voiceController: VoiceController?

	override func viewDidLoad() {
		super.viewDidLoad()

		_voiceController = VoiceController(words: ["HELLO", "COOL", "HOW DID YOU DIE"])
		_voiceController!.startListening()

		startCapturingVideo()
		let motionManager = createMotionManager()

		let (sceneView, cameraNode, ghostNode, ghostPivotNode) = setUpSceneView()
		let hudController = HudController(sceneView: sceneView)

		let ghostController = GhostController(ghostNode: ghostNode, ghostPivotNode: ghostPivotNode)
		let temperatureController = TemperatureController(sceneView: sceneView, ghostNode: ghostNode,
				hudController: hudController)

		_sceneRendererDelegate = SceneRendererDelegate(motionManager: motionManager, cameraNode: cameraNode,
				ghostController: ghostController, temperatureController: temperatureController)
		sceneView.delegate = _sceneRendererDelegate!

		// add a tap gesture recognizer
		//let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		//scnView.addGestureRecognizer(tapGesture)
	}

//	func handleTap(gestureRecognize: UIGestureRecognizer) {
//		// retrieve the SCNView
//		let scnView = self.view as! SCNView
//
//		// check what nodes are tapped
//		let p = gestureRecognize.locationInView(scnView)
//		let hitResults = scnView.hitTest(p, options: nil)
//		// check that we clicked on at least one object
//		if hitResults.count > 0 {
//			// retrieved the first clicked object
//			let result: AnyObject! = hitResults[0]
//
//			// get its material
//			let material = result.node!.geometry!.firstMaterial!
//
//			// highlight it
//			SCNTransaction.begin()
//			SCNTransaction.setAnimationDuration(0.5)
//
//			// on completion - unhighlight
//			SCNTransaction.setCompletionBlock {
//				SCNTransaction.begin()
//				SCNTransaction.setAnimationDuration(0.5)
//
//				material.emission.contents = UIColor.blackColor()
//
//				SCNTransaction.commit()
//			}
//
//			material.emission.contents = UIColor.redColor()
//
//			SCNTransaction.commit()
//		}
//	}

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
		_avCaptureSession = AVCaptureSession()
		_avCaptureSession!.sessionPreset = AVCaptureSessionPresetMedium

		let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		do {
			_avCaptureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
			_avCaptureSession!.addInput(_avCaptureDeviceInput)
		} catch {
			// TODO: handle error
		}

		let previewLayer = AVCaptureVideoPreviewLayer(session: _avCaptureSession!)
		previewLayer.frame = view.bounds
		previewLayer.opaque = true
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait

		view.layer.addSublayer(previewLayer)
		_avCaptureSession!.startRunning()
	}

	private func setUpSceneView() ->
			(sceneView: SCNView, cameraNode: SCNNode, ghostNode: SCNNode, ghostPivotNode: SCNNode) {
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
		let orbNode = SCNNode(geometry: orb)
		let orbPivotNode = SCNNode()
		orbPivotNode.addChildNode(orbNode)
		orbNode.position = SCNVector3Make(0, 50, 50)
		scene.rootNode.addChildNode(orbPivotNode)

//		orbPivotNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 0, z: 2, duration: 1)))

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

		return (scnView, cameraNode, orbNode, orbPivotNode)
	}

	private func createMotionManager() -> CMMotionManager {
		let motionManager = CMMotionManager()
		motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
		motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XTrueNorthZVertical)

		return motionManager
	}
}
