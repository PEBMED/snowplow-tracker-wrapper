//
//  EventStub.swift
//  
//
//  Created by Luiz Diniz Hammerli on 23/02/22.
//

import snowplow_tracker_wrapper

final class EventStub: SnowplowEvent {
    static let SCHEMA = "test/event/jsonschema/1-0-0"
    static let PROP_TYPE = "value"

    let value: String

    init(value: String = "") {
        self.value = value
        super.init(schema: EventStub.SCHEMA)

        self.addKeyValue(key: EventStub.PROP_TYPE, value: self.value)
        self.enableEntitySend(entityKey: EntityStub.key)
    }
}
