//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class FlashlightFlickerManifestation: Manifestation {

	private let minimum: Double
	private let messenger: Messenger

	init(minimumActivityLevel: Double, messenger m: Messenger) {
		minimum = minimumActivityLevel
		messenger = m
	}

	public var minimumActivityLevel: Double {
		return minimum
	}

	public func manifest() {
		messenger.publishMessage(FlashlightMessage(isOn: false))

		let delayRnd = (1...8).randomInt()
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 / Double(delayRnd) * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			self.messenger.publishMessage(FlashlightMessage(isOn: true))
		}
	}
}
