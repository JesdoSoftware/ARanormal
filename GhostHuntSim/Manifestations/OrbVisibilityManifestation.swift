//
// Created by Jesse Douglas on 2016-09-06.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class OrbVisibilityManifestation: VisibilityManifestationBase {

    override func doSetGeometry() {
        ghostNode.geometry = SCNSphere(radius: 2)
    }

    override func doUnsetGeometry() {
        ghostNode.geometry = SCNSphere(radius: 0)
    }
}
