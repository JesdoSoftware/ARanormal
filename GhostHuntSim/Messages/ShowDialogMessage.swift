//
// Created by Jesse Douglas on 2016-10-12.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class ShowDialogMessage {
    public let text: String
    public let buttonText: String
    public let dismissalAction: (() -> Void)?

    init(text: String, buttonText: String, dismissalAction: (() -> Void)?) {
        self.text = text
        self.buttonText = buttonText
        self.dismissalAction = dismissalAction
    }
}
