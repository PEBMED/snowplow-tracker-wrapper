//
//  SnowploeEvent.swift
//  snowplow-tracker-wrapper
//
//  Copyright © 2021 PEBMED. All rights reserved.
//

open class SnowplowEvent {
    // MARK: - Public properties
    public let schema: String
    public var keyValueMap: [String: Any?]?

    // MARK: - Private properties
    private var entityList: [String]?

    // MARK: - Public computed properties
    public var enabledEntityKeyList: [String]? {
        entityList
    }

    // MARK: - Init
    public init(schema: String) {
        self.schema = schema
    }

    // MARK: - Public functions
    public func addKeyValue(key: String, value: Any?) {
        if keyValueMap == nil {
            keyValueMap = [String: Any?]()
        }
        keyValueMap?[key] = value
    }

    public func enableEntitySend(entityKey: String) {
        if entityList == nil {
            entityList = [String]()
        }

        entityList?.append(entityKey)
    }
}
