//
// Created by Jesse Douglas on 2016-09-06.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class OrbVisibilityManifestation: Manifestation {

    init(minimumActivityLevel: Double) {
        self.minimumActivityLevel = minimumActivityLevel
    }

    public var minimumActivityLevel: Double

    public func manifest() {

    }
}
