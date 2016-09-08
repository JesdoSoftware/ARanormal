//
// Created by Jesse Douglas on 2016-09-07.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public struct YesNoResponse {

    public let requiredWords: [String]
    public let response: Bool

    init(requiredWords: [String], response: Bool) {
        self.requiredWords = requiredWords
        self.response = response
    }

    public func respondToPhrase(phrase: String) -> Bool? {
        let phraseWords = phrase.componentsSeparatedByString(" ")
        for requiredWord in requiredWords {
            if !phraseWords.contains(requiredWord) {
                return nil
            }
        }
        return response
    }
}
