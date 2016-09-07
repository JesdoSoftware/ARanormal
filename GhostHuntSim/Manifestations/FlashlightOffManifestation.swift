//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class FlashlightOffManifestation: Manifestation {

    private let messenger: Messenger

    init(minimumActivityLevel: Double, messenger: Messenger) {
        self.minimumActivityLevel = minimumActivityLevel
        self.messenger = messenger
    }

    public var minimumActivityLevel: Double

    public func manifest() {
        messenger.publishMessage(FlashlightOnOffMessage(isOn: false))
    }
}
