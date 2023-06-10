//
//  Observable.swift
//  Orion
//
//  Created by 0x41c on 2023-06-08.
//

import Foundation

/// A certificate used to provide the required information to trigger event on an
/// observable target.
struct ObserverCertificate<ContextEventType: Hashable>: Equatable {
    /// The event this observer might be registered for.
    var event: ContextEventType
    /// The target of the ``selector`` property. Should extend from ``NSObject``.
    var target: NSObject
    /// The method that will be called when the event is fired.
    var selector: Selector
}

/// An observable object, but with a different name! Provides simple utility methods
/// for establishing an application state with an event-based observer model.
class Observable<ContextEventType: Hashable>: NSObject {
    typealias Certificate = ObserverCertificate<ContextEventType>

    /// A map of certificate collections.
    private var observers: [ContextEventType: [Certificate]] = [:]

    /// Determines if a request to operate on the registry is valid i.e. the request can be fulfilled.
    private func isValidRegistryRequest(
        for certificate: Certificate,
        requiresEvent: Bool,
        shouldContain: Bool
    ) -> Bool {
        let event = certificate.event
        guard !requiresEvent || observers[event] != nil else { return false }
        if observers[event] == nil { return true }

        let contains = observers[event]?.contains(certificate) ?? false
        return shouldContain ? contains : !contains
    }

    /// Registers an observer targeting this object.
    func registerObserver(_ event: ContextEventType, withTarget target: NSObject,
                          selector: Selector) -> Certificate? {
        registerObserver(
            ObserverCertificate(
                event: event,
                target: target,
                selector: selector
            )
        )
    }

    /// Registers an observer targeting this object.
    func registerObserver(_ certificate: Certificate) -> Certificate? {
        let event = certificate.event

        guard isValidRegistryRequest(
            for: certificate,
            requiresEvent: false,
            shouldContain: false
        ) else {
            Logger.warn("Attempted to register duplicate observer: \(certificate)")
            return nil
        }

        if observers[event] == nil {
            observers[event] = []
        }

        observers[event]?.append(certificate)
        return certificate
    }

    /// Removes an observer from this object for the given event type.
    func removeObserver(_ event: ContextEventType, withTarget target: NSObject,
                        selector: Selector) {
        removeObserver(
            ObserverCertificate(
                event: event,
                target: target,
                selector: selector
            )
        )
    }

    /// Removes an observer from this object for the given event type.
    func removeObserver(_ certificate: Certificate) {
        let event = certificate.event
        guard isValidRegistryRequest(
            for: certificate,
            requiresEvent: true,
            shouldContain: true
        ) else {
            Logger.warn("Attempted to remove an observer that didn't exist beforehand: \(certificate)")
            return
        }

        // swiftlint:disable:next force_unwrapping
        observers[event]?.remove(at: observers[event]!.firstIndex(of: certificate)!)
    }

    /// Triggers the observers of the given event.
    func fire(event: ContextEventType) {
        guard observers[event] != nil else {
            return
        }
        observers[event]?.forEach({ certificate in
            certificate.target.perform(certificate.selector)
        })
    }

    /// A two-step event that typically has a `somethingWillOccur` phase, and a `somethingDidOccur` phase.
    typealias DualPhaseEventGroup = (first: ContextEventType, second: ContextEventType)

    /// Triggers the observers of a dual phase grouping. Wraps a blocks execution expected to
    /// change a contextual state warranting the firing the events.
    func fire(event: DualPhaseEventGroup, wrapping block: () -> Void) {
        fire(event: event.first)
        block()
        fire(event: event.second)
    }
}
