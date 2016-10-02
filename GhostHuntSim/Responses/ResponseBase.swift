//
// Created by Jesse Douglas on 2016-09-10.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class ResponseBase {

    public let requiredWords: [String]
    var hasResponded: Bool = false

    init(requiredWords: [String]) {
        self.requiredWords = requiredWords
    }

    public func shouldRespondToPhrase(phrase: String) -> Bool {
        if hasResponded
        {
            return false
        }

        let phraseWords = phrase.componentsSeparatedByString(" ")
        for requiredWord in requiredWords {
            if !phraseWords.contains(requiredWord) {
                return false
            }
        }
        return true
    }
}
