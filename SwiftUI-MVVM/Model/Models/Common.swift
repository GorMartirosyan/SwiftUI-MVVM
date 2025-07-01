//
//  Common.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 30.06.25.
//

enum Model {
    typealias ID = API.ID
}

extension Model.ID {
    static func random() -> Self {
        self.random(in: 0...Self.max)
    }
}
