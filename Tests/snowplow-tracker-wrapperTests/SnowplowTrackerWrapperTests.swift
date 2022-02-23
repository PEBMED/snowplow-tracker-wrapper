import XCTest
import SnowplowTracker
@testable import snowplow_tracker_wrapper

final class SnowplowTrackerWrapperTests: XCTestCase {
    func test_init_shouldNotSendAnyEvent() {
        let (_, spy) = makeSUT()
        XCTAssertTrue(spy.events.isEmpty)
    }

    func test_sendEvent_shouldNotAddEntity() {
        expectEvent()
    }

    func test_sendEvent_shouldAddCorrectEntity() {
        expectEvent(with: [anyEntity()])
    }

    func test_sendEvent_shouldAddCorrectEntities() {
        expectEvent(with: [anyEntity(), anyEntity(), anyEntity()])
    }

    func test_sendEvent_shouldSendCorrectData() {
        let value = "Test Event \(UUID().description)"
        expect(event: EventStub(value: value), with: [EventStub.PROP_TYPE: value as NSObject], and: EventStub.SCHEMA)
    }

    func test_screenView_shouldSendCorrectData() {
        let (sut, spy) = makeSUT()
        let screenName = "Test Name"
        sut.trackScreenViewEvent(EventStub(), screenId: "", screenName: screenName)

        XCTAssertEqual(spy.events[0].payload["name"], screenName as NSObject)
        XCTAssertNotNil(spy.events[0].payload["id"])
    }

    func test_setUserID_shouldSetCorrectValue() {
        let (sut, spy) = makeSUT()

        let id = UUID().description
        sut.setUserId(id)

        XCTAssertEqual(spy.subject?.userId, id)
    }

    func test_getEntities_shouldReturnCorrectValue() {
        let (sut, _) = makeSUT()
        let entity = EntityStub(title: "Test Title")
        sut.addEntity(snowplowEntity: entity)

        let receivedValue = sut.getEntity(entityKey: EntityStub.key)?.first?.getValue(key: EntityStub.PROP_ID) as? String
        let expectedValue = entity.getValue(key: EntityStub.PROP_ID) as? String

        XCTAssertEqual(receivedValue, expectedValue)
    }

    func test_removeEntity_shouldReturnNil() {
        let (sut, _) = makeSUT()
        let entity = EntityStub(title: "Test Title")

        sut.addEntity(snowplowEntity: entity)
        sut.removeEntity(entityKey: EntityStub.key)

        XCTAssertNil(sut.getEntity(entityKey: EntityStub.key))
    }
}

// MARK: - Helpers
private extension SnowplowTrackerWrapperTests {
    func makeSUT() -> (SnowplowTrackerWrapper, TrackerControllerSpy) {
        let tracker = TrackerControllerSpy()
        let wrapper = SnowplowTrackerWrapper(tracker: tracker)
        return (wrapper, tracker)
    }

    private func anyEntity() -> EntityStub {
        let id = UUID().description
        return EntityStub(id: id, title: "Test Title Snowplow Wrapper \(id)")
    }

    private func toEntityDictionary(with json: SelfDescribingJson) -> [String: String] {
        return json.data as! [String: String]
    }

    private func getEntities(by event: Event) -> [(dict: [String: String], schema: String)] {
        event.contexts.compactMap { context in
            guard let json = context as? SelfDescribingJson else { return nil }
            return (toEntityDictionary(with: json), json.schema)
        }
    }

    func expectEvent(with entities: [EntityStub] = [], file: StaticString = #filePath, line: UInt = #line) {
        let (sut, spy) = makeSUT()
        let event = EventStub()

        entities.forEach { sut.addEntity(snowplowEntity: $0) }
        sut.sendEvent(snowplowEvent: event)
        let receivedEntites = getEntities(by: spy.events.first!)

        receivedEntites.enumerated().forEach { index, entity in
            XCTAssertEqual(entity.dict[EntityStub.PROP_ID], entities[index].id, file: file, line: line)
            XCTAssertEqual(entity.dict[EntityStub.PROP_TITLE], entities[index].title, file: file, line: line)
            XCTAssertEqual(entity.schema, EntityStub.SCHEMA, file: file, line: line)
        }
    }

    func expect(event: SnowplowEvent,
                with value: [String: NSObject],
                and schema: String,
                at index: Int = 0,
                file: StaticString = #filePath,
                line: UInt = #line) {
        let (sut, spy) = makeSUT()
        sut.sendEvent(snowplowEvent: event)

        guard let jsonEvent = spy.events[index] as? SelfDescribing else { return XCTFail("Expect event as a SelfDescribing object") }

        XCTAssertEqual(spy.events[index].payload, value)
        XCTAssertEqual(jsonEvent.schema, schema)
    }
}
