//
// Created by Jesse Douglas on 2016-10-08.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public func dispatchAfterSeconds(when: Double, block: dispatch_block_t) {
    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(when * Double(NSEC_PER_SEC)))
    dispatch_after(dispatchTime, dispatch_get_main_queue(), block)
}