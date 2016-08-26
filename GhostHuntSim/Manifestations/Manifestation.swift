//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public protocol Manifestation {

	var minimumActivityLevel: Double { get }
	func manifest()
}
