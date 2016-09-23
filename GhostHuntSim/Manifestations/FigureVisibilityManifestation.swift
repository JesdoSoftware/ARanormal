//
// Created by Jesse Douglas on 2016-09-22.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class FigureVisibilityManifestation: VisibilityManifestationBase {

    override func doSetGeometry() {
        let box = SCNBox(width: 12, height: 24, length: 1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = "Ghost.png"
        box.firstMaterial = material

        ghostNode.geometry = box
    }
}
