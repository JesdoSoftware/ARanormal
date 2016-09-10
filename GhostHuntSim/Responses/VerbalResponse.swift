//
// Created by Jesse Douglas on 2016-09-10.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class VerbalResponse: ResponseBase {

    public let response: String

    init(requiredWords: [String], response: String) {
        self.response = response
        super.init(requiredWords: requiredWords)
    }

    public func respondToPhrase(phrase: String) -> String? {
        if shouldRespondToPhrase(phrase) {
            return response
        }
        return nil
    }
}
