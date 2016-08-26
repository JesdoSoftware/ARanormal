//
// Created by Jesse Douglas on 2016-08-25.
// Copyright (c) 2016 Jesse Douglas. All rights reserved.
//

import Foundation

public class ManifestationSet {

	private let manifestations: [Manifestation]
	private let chancePerSixty: Int

	init(manifestations m: [Manifestation], chancePerSixty chance: Int) {
		manifestations = m
		chancePerSixty = chance
	}

	public func getManifestation(activityLevel: Double) -> Manifestation? {
		let normalizedActivity: Double
		if activityLevel == 0 {
			normalizedActivity = 1
		} else {
			normalizedActivity = activityLevel
		}
		let rnd = (1...Int(round((60 / normalizedActivity)))).randomInt()
		if rnd <= chancePerSixty {
			let applicableManifestations = manifestations.filter({ $0.minimumActivityLevel <= activityLevel })
			let manifestation = applicableManifestations.randomItem()
			return manifestation
		}
		return nil
	}
}
