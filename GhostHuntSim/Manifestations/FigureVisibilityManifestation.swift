//
// Created by Jesse Douglas on 2016-09-22.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class FigureVisibilityManifestation: VisibilityManifestationBase {

    private let filename: String
    private let width: CGFloat
    private let height: CGFloat

    init(minimumActivityLevel: Double, ghostNode: SCNNode, visibility: Double, messenger: Messenger,
            filename: String, width: CGFloat, height: CGFloat) {
        self.filename = filename
        self.width = width
        self.height = height

        super.init(minimumActivityLevel: minimumActivityLevel, ghostNode: ghostNode, visibility: visibility,
                messenger: messenger)
    }

    override func doSetGeometry() {
        let box = SCNBox(width: width, height: height, length: 1, chamferRadius: 0)

        let material = SCNMaterial()
        material.diffuse.contents = filename
        box.firstMaterial = material

        ghostNode.geometry = box
    }
}
