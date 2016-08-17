//
// Created by Jesse Douglas on 2016-08-16.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class TemperatureMessage {

	public let direction: TemperatureDirection

	init(direction dir: TemperatureDirection) {
		direction = dir
	}

	public enum TemperatureDirection {
		case Up
		case Down
	}
}
