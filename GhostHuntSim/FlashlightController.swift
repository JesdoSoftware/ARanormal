//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import AVFoundation

public class FlashlightController: MessengerSubscriber {

	private let captureDevice: AVCaptureDevice

	init(captureDevice device: AVCaptureDevice) {
		captureDevice = device
	}

	public func processMessage(message: AnyObject) {
		if let flashlightMessage = message as? FlashlightMessage {
			if flashlightMessage.isOn {
				turnOnFlashlight()
			} else {
				turnOffFlashlight()
			}
		}
	}

	private func turnOnFlashlight() {
		do {
			try captureDevice.lockForConfiguration()
//			captureDevice.setExposureModeCustomWithDuration(captureDevice.activeFormat.maxExposureDuration,
//					ISO: captureDevice.activeFormat.maxISO,
//					completionHandler: nil)
			try captureDevice.setTorchModeOnWithLevel(0.1)
			captureDevice.unlockForConfiguration()
		} catch {
			// TODO: handle error
		}
	}

	private func turnOffFlashlight() {
		do {
			try captureDevice.lockForConfiguration()
			captureDevice.torchMode = AVCaptureTorchMode.Off
			captureDevice.unlockForConfiguration()
		} catch {
			// TODO: handle error
		}
	}
}
