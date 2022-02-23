//
//  EntityStub.swift
//  
//
//  Created by Luiz Diniz Hammerli on 23/02/22.
//

import snowplow_tracker_wrapper
import Foundation

final class EntityStub: SnowplowEntity {
    static let SCHEMA = "test/entity/jsonschema/1-0-0"
    static let key = "TEST_ENTITY"

    static let PROP_ID = "test_id"
    static let PROP_TITLE = "test_title"

    let id: String
    let title: String

    init(id: String = UUID().description, title: String = "Test Title") {
        self.id = id
        self.title = title

        super.init(schema: EntityStub.SCHEMA, entityKey: EntityStub.key)

        self.addKeyValue(attributeKey: EntityStub.PROP_ID, value: id)
        self.addKeyValue(attributeKey: EntityStub.PROP_TITLE, value: title)
    }
}
