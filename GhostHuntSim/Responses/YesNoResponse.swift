//
// Created by Jesse Douglas on 2016-09-07.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class YesNoResponse: ResponseBase {

    public let response: Bool

    init(requiredWords: [String], response: Bool) {
        self.response = response
        super.init(requiredWords: requiredWords)
    }

    public func respondToPhrase(phrase: String) -> Bool? {
        if shouldRespondToPhrase(phrase) {
            hasResponded = true
            return response
        }
        return nil
    }
}
