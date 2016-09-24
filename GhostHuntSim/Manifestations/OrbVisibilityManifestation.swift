//
// Created by Jesse Douglas on 2016-09-06.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class OrbVisibilityManifestation: VisibilityManifestationBase {

    override func doSetGeometry() {
        let sphere = SCNSphere(radius: 1)

        sphere.firstMaterial = SCNMaterial()
        sphere.firstMaterial!.emission.contents = UIColor.darkGrayColor()

        ghostNode.geometry = sphere
    }
}
