//
//  PaymentModel.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 30.06.25.
//

extension API.Payment {
    enum Model {
        enum Request { }
        enum Response { }
    }
}

extension API.Payment.Model.Response {
    
    struct PaymentType: Codable {
        let id: API.ID
        let title: String
    }
}

// MARK: - Fakes

extension API.Payment.Model.Response.PaymentType {
    static let fakes: [Self] = [
        .init(id: .random(), title: "Option 1"),
        .init(id: .random(), title: "Option 2"),
        .init(id: .random(), title: "Option 3"),
        .init(id: .random(), title: "Option 4"),
        .init(id: .random(), title: "Option 5")
    ]
}
