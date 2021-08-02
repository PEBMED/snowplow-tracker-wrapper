//
//  SnowplowEntity.swift
//  snowplow-tracker-wrapper
//
//  Copyright © 2021 PEBMED. All rights reserved.
//

public class SnowplowEntity {
    // MARK: - Public properties
    public let schema: String
    public let entityKey: String

    // MARK: - Private properties
    private var keyValueMap = [String: Any?]()

    // MARK: - Init
    public init(schema: String, entityKey: String) {
        self.schema = schema
        self.entityKey = entityKey
    }

    // MARK: - Public functions
    public func addKeyValue(attributeKey: String, value: Any?) {
        keyValueMap[attributeKey] = value
    }

    public func getValue(key: String) -> Any {
        keyValueMap[key] as Any
    }

    public func getKeyValueMap() -> [String: Any?] {
        keyValueMap
    }
}
