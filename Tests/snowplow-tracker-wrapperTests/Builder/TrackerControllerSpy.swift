//
//  File.swift
//  
//
//  Created by Luiz Diniz Hammerli on 23/02/22.
//

import SnowplowTracker

final class TrackerControllerSpy: TrackerController {
    var events = [Event]()

    func track(_ event: Event) {
        events.append(event)
    }

    var version: String = ""

    var isTracking: Bool = true

    var namespace: String = ""

    var subject: SubjectController? = SubjectControllerStub()

    var session: SessionController? = nil

    var network: NetworkController? = nil

    var emitter: EmitterController = EmitterConfigurationStub()

    var gdpr: GDPRController = GDPRControllerStub(basis: .consent, documentId: "", documentVersion: "", documentDescription: "")

    var globalContexts: GlobalContextsController = GlobalContextsControllerStub()

    func pause() {}

    func resume() {}

    var appId: String = ""

    var devicePlatform: DevicePlatform = .connectedTV

    var base64Encoding: Bool = false

    var logLevel: LogLevel = .debug

    var loggerDelegate: LoggerDelegate? = nil

    var applicationContext: Bool = true

    var platformContext: Bool = true

    var geoLocationContext: Bool = true

    var sessionContext: Bool = true

    var deepLinkContext: Bool = true

    var screenContext: Bool = true

    var screenViewAutotracking: Bool = true

    var lifecycleAutotracking: Bool = true

    var installAutotracking: Bool = true

    var exceptionAutotracking: Bool = true

    var diagnosticAutotracking: Bool = true

    var trackerVersionSuffix: String? = nil
}

final class EmitterConfigurationStub: EmitterController {
    var dbCount: Int = 0

    var isSending: Bool = true

    func flush() {}

    var bufferOption: BufferOption = .defaultGroup

    var emitRange: Int = 0

    var threadPoolSize: Int = 0

    var byteLimitGet: Int = 0

    var byteLimitPost: Int = 0

    var requestCallback: RequestCallback? = nil
}

final class GDPRControllerStub: GDPRController {
    var isEnabled: Bool = false

    var basisForProcessing: GDPRProcessingBasis
    var documentId: String?
    var documentVersion: String?
    var documentDescription: String?

    func reset(basis basisForProcessing: GDPRProcessingBasis,
               documentId: String?,
               documentVersion: String?,
               documentDescription: String?) {}

    func enable() -> Bool {
        return true
    }

    func disable() {}

    public init(
        basis: GDPRProcessingBasis,
        documentId: String,
        documentVersion: String,
        documentDescription: String
    ) {
        self.basisForProcessing = basis
        self.documentId = documentId
        self.documentVersion = documentVersion
        self.documentDescription = documentDescription
    }
}

final class GlobalContextsControllerStub: GlobalContextsController {
    var tags: [String] = []

    var contextGenerators: NSMutableDictionary = NSMutableDictionary()

    func add(tag: String, contextGenerator generator: GlobalContext) -> Bool {
        return true
    }

    func remove(tag: String) -> GlobalContext? {
        return nil
    }
}

final class SubjectControllerStub: SubjectController {
    var userId: String?

    var networkUserId: String?

    var domainUserId: String?

    var useragent: String?

    var ipAddress: String?

    var timezone: String?

    var language: String?

    var screenResolution: SPSize?

    var screenViewPort: SPSize?

    var colorDepth: NSNumber?

    var geoLatitude: NSNumber?

    var geoLongitude: NSNumber?

    var geoLatitudeLongitudeAccuracy: NSNumber?

    var geoAltitude: NSNumber?

    var geoAltitudeAccuracy: NSNumber?

    var geoBearing: NSNumber?

    var geoSpeed: NSNumber?

    var geoTimestamp: NSNumber?

}
