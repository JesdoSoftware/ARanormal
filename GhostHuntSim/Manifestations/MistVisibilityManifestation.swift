//
// Created by Jesse Douglas on 2016-09-19.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation
import SceneKit

public class MistVisibilityManifestation: VisibilityManifestationBase {

    override func doSetGeometry() {
        let particleSystem = SCNParticleSystem(named: "Mist.scnp", inDirectory: nil)!
        ghostNode.addParticleSystem(particleSystem)
    }

    override func doUnsetGeometry() {
        ghostNode.removeAllParticleSystems()
    }
}
