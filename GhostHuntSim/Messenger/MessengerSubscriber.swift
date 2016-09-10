//
// Created by Jesse Douglas on 2016-08-16.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public protocol MessengerSubscriber {

    func processMessage(message: AnyObject)
}
