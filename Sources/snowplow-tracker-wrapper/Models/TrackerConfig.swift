//
//  TrackerConfig.swift
//  snowplow-tracker-wrapper
//
//  Copyright © 2021 PEBMED. All rights reserved.
//

public struct TrackerConfig {
    public let nameSpace: String
    public let appID: String
    public let emitterUri: String

    public init(nameSpace: String, appID: String, emitterUri: String) {
        self.nameSpace = nameSpace
        self.appID = appID
        self.emitterUri = emitterUri
    }
}
