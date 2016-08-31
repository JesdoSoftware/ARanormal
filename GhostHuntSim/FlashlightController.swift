//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import AVFoundation

public class FlashlightController: MessengerSubscriber {

	private let captureDevice: AVCaptureDevice
	private var isOn: Bool = false

	init(captureDevice device: AVCaptureDevice) {
		captureDevice = device
	}

	public func processMessage(message: AnyObject) {
		if let flashlightOnOffMessage = message as? FlashlightOnOffMessage {
			if flashlightOnOffMessage.isOn {
				turnOnFlashlight()
			} else {
				turnOffFlashlight()
			}
		} else if let flashlightFlickerMessage = message as? FlashlightFlickerMessage {
			flickerFlashlight(times: flashlightFlickerMessage.times)
		}
	}

	private func turnOnFlashlight() {
		if (!isOn) {
			do {
				try captureDevice.lockForConfiguration()
//			captureDevice.setExposureModeCustomWithDuration(captureDevice.activeFormat.maxExposureDuration,
//					ISO: captureDevice.activeFormat.maxISO,
//					completionHandler: nil)
				try captureDevice.setTorchModeOnWithLevel(0.1)
				captureDevice.unlockForConfiguration()

				isOn = true
			} catch {
				// TODO: handle error
			}
		}
	}

	private func turnOffFlashlight() {
		if (isOn) {
			do {
				try captureDevice.lockForConfiguration()
				captureDevice.torchMode = AVCaptureTorchMode.Off
				captureDevice.unlockForConfiguration()

				isOn = false
			} catch {
				// TODO: handle error
			}
		}
	}

	private func flickerFlashlight(times times: Int) {
		if (isOn) {
			self.turnOffFlashlight()

			let delayRnd = (1 ... 8).randomInt()
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 / Double(delayRnd) * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				self.turnOnFlashlight()

				if times > 1 {
					let nextFlickerTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
					dispatch_after(nextFlickerTime, dispatch_get_main_queue()) {
						self.flickerFlashlight(times: times - 1)
					}
				}
			}
		}
	}
}
