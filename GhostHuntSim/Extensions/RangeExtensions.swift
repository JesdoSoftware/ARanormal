//
// Created by Jesse Douglas on 2016-08-23.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

extension Range
{
    public func randomInt() -> Int
    {
        var offset = 0

        if (startIndex as! Int) < 0   // allow negative ranges
        {
            offset = abs(startIndex as! Int)
        }

        let mini = UInt32(startIndex as! Int + offset)
        let maxi = UInt32(endIndex as! Int + offset)

        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}