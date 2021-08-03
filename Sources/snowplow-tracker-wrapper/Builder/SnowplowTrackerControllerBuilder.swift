//
//  SnowplowTrackerControllerBuilder.swift
//  snowplow-tracker-wrapper
//
//  Copyright © 2021 PEBMED. All rights reserved.
//

import SnowplowTracker

public final class SnowplowTrackerControllerBuilder {
    private let trackerConfig: TrackerConfig
    private let userId: String

    private var tracker: TrackerConfiguration?
    private lazy var network = NetworkConfiguration(endpoint: trackerConfig.emitterUri)
    private var emitter: EmitterConfiguration?
    private var gdpr: GDPRConfiguration?
    private var globalContexts: GlobalContextsConfiguration?
    private var subject: SubjectConfiguration?

    public init(trackerConfig: TrackerConfig, userId: String) {
        self.trackerConfig = trackerConfig
        self.userId = userId
    }

    @discardableResult
    public func setNetwork() -> Self {
        let networkConnection = DefaultNetworkConnection.build { [trackerConfig] builder in
            builder.setUrlEndpoint(trackerConfig.emitterUri)
            builder.setHttpMethod(.get)
            builder.setEmitThreadPoolSize(20)
            builder.setByteLimitPost(52_000)
        }
        network = NetworkConfiguration(networkConnection: networkConnection)
        return self
    }

    @discardableResult
    public func setTracker() -> Self {
        tracker = TrackerConfiguration()
            .base64Encoding(false)
            .sessionContext(true)
            .platformContext(true)
            .geoLocationContext(false)
            .lifecycleAutotracking(true)
            .screenViewAutotracking(false)
            .screenContext(true)
            .applicationContext(true)
            .exceptionAutotracking(true)
            .installAutotracking(true)
            .diagnosticAutotracking(true)
            .logLevel(.verbose)
            .appId(trackerConfig.appID)
        return self
    }

    @discardableResult
    public func setEmitter() -> Self {
        let eventStore = SQLiteEventStore(namespace: trackerConfig.nameSpace)
        emitter = EmitterConfiguration()
            .eventStore(eventStore)
            .emitRange(500)
        return self
    }

    @discardableResult
    public func gdpr(_ config: SnowplowTrackerWrapper.GDPRConfiguration) -> Self {
        gdpr = GDPRConfiguration(
            basis: .init(rawValue: config.basis.rawValue)!,
            documentId: config.documentId,
            documentVersion: config.documentVersion,
            documentDescription: config.documentDescription
        )
        return self
    }

    @discardableResult
    public func setGlobalContexts() -> Self {
        globalContexts = GlobalContextsConfiguration()
        return self
    }

    @discardableResult
    public func setSubject() -> Self {
        subject = SubjectConfiguration()
            .userId(userId)
        return self
    }

    public func build() -> TrackerController {
        var configurations: [Configuration] = []

        if let configuration = tracker {
            configurations.append(configuration)
        }
        if let configuration = emitter {
            configurations.append(configuration)
        }
        if let configuration = gdpr {
            configurations.append(configuration)
        }
        if let configuration = globalContexts {
            configurations.append(configuration)
        }
        if let configuration = subject {
            configurations.append(configuration)
        }

        return Snowplow.createTracker(namespace: trackerConfig.nameSpace, network: network, configurations: configurations)
    }
}
