//
// Created by Jesse Douglas on 2016-09-06.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class OrbVisibilityManifestation: Manifestation {

    private let ghostNode: SCNNode
    private let visibility: Double

    private let fadeDuration = 0.5

    init(minimumActivityLevel: Double, ghostNode: SCNNode, visibility: Double) {
        self.minimumActivityLevel = minimumActivityLevel
        self.ghostNode = ghostNode
        self.visibility = visibility
    }

    public var minimumActivityLevel: Double

    public func manifest() {
        ghostNode.geometry = SCNSphere(radius: 2)
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(fadeDuration)
        ghostNode.opacity = CGFloat(visibility)
        SCNTransaction.commit()

        let delayRnd = (1...5).randomInt()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delayRnd) * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(self.fadeDuration)
            self.ghostNode.opacity = 0
            SCNTransaction.commit()
        }
    }
}
