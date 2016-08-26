//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class FlashlightOffManifestation: Manifestation {

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
	}
}
