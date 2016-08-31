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
		let times = (1...3).randomInt()
		messenger.publishMessage(FlashlightFlickerMessage(times: times))
	}
}
