//
//  SnowplowTrackerWrapper.swift
//  snowplow-tracker-wrapper
//
//  Copyright © 2021 PEBMED. All rights reserved.
//

import SnowplowTracker

public final class SnowplowTrackerWrapper: NSObject {
    // MARK: - Models
    public enum GDPRBasis: Int {
        case consent = 1
    }

    public struct GDPRConfiguration {
        let basis: GDPRBasis
        let documentId: String
        let documentVersion: String
        let documentDescription: String
    }

    // MARK: - Private properties
    private let tracker: TrackerController
    private var entityDictionary: [String: [SnowplowEntity]] = [:]
    private var isTrackerEnabled = true

    // MARK: - Private static properties
    private static var instance: SnowplowTrackerWrapper?

    // MARK: - Private init
    public init(tracker: TrackerController) {
        self.tracker = tracker
        super.init()
    }

    // MARK: - Public functions
    public func addEntity(snowplowEntity: SnowplowEntity) {
        if entityDictionary[snowplowEntity.entityKey] == nil {
            entityDictionary[snowplowEntity.entityKey] = [snowplowEntity]
        } else {
            entityDictionary[snowplowEntity.entityKey]?.append(snowplowEntity)
        }
    }

    public func removeEntity(entityKey: String ) {
        entityDictionary.removeValue(forKey: entityKey)
    }

    public func getEntity(entityKey: String) -> [SnowplowEntity]? {
        entityDictionary[entityKey]
    }

    public func sendEvent(snowplowEvent: SnowplowEvent) {
        guard isTrackerEnabled else { return }

        let event = createEventSelfDescribingJson(snowplowEvent: snowplowEvent)
        let entities = loadEventEntities(snowplowEvent)

        sendEvent(event: event, entities: entities)
    }

    public func trackScreenViewEvent(_ snowplowEvent: SnowplowEvent, screenId: String, screenName: String) {
        guard isTrackerEnabled else { return }

        let entities = loadEventEntities(snowplowEvent)
        let event = ScreenView(name: screenName, screenId: UUID())

        let mutableArray = NSMutableArray(array: entities)
        event.setContexts(mutableArray)

        tracker.track(event)
    }

    public func enableTracker(_ enable: Bool = true) {
        isTrackerEnabled = enable
    }

    public func setUserId(_ id: String?) {
        tracker.subject?.userId = id
    }

    // MARK: - Private functions
    private func createEventSelfDescribingJson(snowplowEvent: SnowplowEvent) -> SelfDescribingJson {
        let atributted = snowplowEvent.keyValueMap ?? [:]
        return SelfDescribingJson(schema: snowplowEvent.schema, andData: atributted as NSObject)
    }

    private func loadEventEntities(_ snowplowEvent: SnowplowEvent) -> [SelfDescribingJson] {
        var entities: [SelfDescribingJson] = []

        snowplowEvent.enabledEntityKeyList?.forEach { entityKey in
            guard let snowplowEntities = entityDictionary[entityKey] else {
                let message = """
                SnowplowTrackerWrapper
                #### Pay attention!!! You are trying to send an Entity
                that is not available on SnowplowTrackerWrapper.
                EntityKey: \(entityKey)
                """
                debugPrint(message)
                return
            }

            snowplowEntities.forEach { entity in
                if let data = entity.getKeyValueMap() as NSObject?, let sdj = SelfDescribingJson(schema: entity.schema, andData: data) {
                    entities.append(sdj)
                }
            }
        }

        return entities
    }

    private func sendEvent(event: SelfDescribingJson, entities: [SelfDescribingJson]) {
        let event = SelfDescribing(eventData: event)
        let mutableArray = NSMutableArray(array: entities)
        event.setContexts(mutableArray)
        tracker.track(event)
    }
}
