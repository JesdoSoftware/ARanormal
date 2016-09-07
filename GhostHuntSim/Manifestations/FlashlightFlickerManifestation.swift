//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class FlashlightFlickerManifestation: Manifestation {

    private let messenger: Messenger

    init(minimumActivityLevel: Double, messenger: Messenger) {
        self.minimumActivityLevel = minimumActivityLevel
        self.messenger = messenger
    }

    public var minimumActivityLevel: Double

    public func manifest() {
        let times = (1...3).randomInt()
        messenger.publishMessage(FlashlightFlickerMessage(times: times))
    }
}
