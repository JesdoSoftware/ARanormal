//
// Created by Jesse Douglas on 2016-08-16.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class Messenger {

    private var subscribers: [MessengerSubscriber] = []

    public func addSubscriber(subscriber: MessengerSubscriber) {
        subscribers.append(subscriber)
    }

    public func publishMessage(message: AnyObject) {
        for subscriber in subscribers {
            subscriber.processMessage(message)
        }
    }
}
