//
//  Preferences.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty {

    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences = .shared

    init(
        _ keyPath: ReferenceWritableKeyPath<Preferences, Value>
    ) {
        self.keyPath = keyPath
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .mapToVoid()
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }

    private var value: Value {
        get {
            preferences[keyPath: keyPath]
        }
        nonmutating set {
            preferences[keyPath: keyPath] = newValue
            preferences.preferencesChangedSubject.send(keyPath)
        }
    }

    var wrappedValue: Value {
        get {
            if Thread.isMainThread {
                return value
            } else {
                return DispatchQueue.main.sync { value }
            }
        }
        nonmutating set {
            if Thread.isMainThread {
                value = newValue
            } else {
                DispatchQueue.main.sync { value = newValue }
            }
        }
    }

    var publisher: AnyPublisher<Value, Never> {
        preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == self.keyPath
            }
            .mapToVoid()
            .merge(with: Just(()))
            .map { _ in preferences[keyPath: keyPath] }
            .eraseToAnyPublisher()
    }

    var binding: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }

    public var projectedValue: Preference<Value> {
        self
    }

}

final class Preferences {
    
    static let shared = Preferences()
    private init() {}
    
    fileprivate var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    var contentViewType: ContentViewType = .main
}
