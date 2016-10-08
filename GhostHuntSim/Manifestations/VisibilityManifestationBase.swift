//
// Created by Jesse Douglas on 2016-09-19.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class VisibilityManifestationBase: Manifestation {

    let ghostNode: SCNNode

    private let visibility: Double
    private let messenger: Messenger

    private let fadeDuration = 0.5

    init(minimumActivityLevel: Double, ghostNode: SCNNode, visibility: Double, messenger: Messenger) {
        self.minimumActivityLevel = minimumActivityLevel
        self.ghostNode = ghostNode
        self.visibility = visibility
        self.messenger = messenger
    }

    public var minimumActivityLevel: Double

    func doSetGeometry() { }
    func doUnsetGeometry() { }

    public func manifest() {
        messenger.publishMessage(IsGhostVisibleMessage(isVisible: true))

        doSetGeometry()
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(fadeDuration)
        ghostNode.opacity = CGFloat(visibility)
        SCNTransaction.commit()

        let delayRnd = (1...5).randomInt()
        dispatchAfterSeconds(Double(delayRnd)) {
            self.messenger.publishMessage(IsGhostVisibleMessage(isVisible: false))

            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(self.fadeDuration)
            self.ghostNode.opacity = 0
            self.doUnsetGeometry()
            SCNTransaction.commit()
        }
    }
}
