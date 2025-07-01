//
//  PaymentType.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 30.06.25.
//

struct PaymentType: Codable, Identifiable {
    let id: Model.ID
    let name: String
}

extension API.Payment.Model.Response.PaymentType {
    func toDomain() -> PaymentType {
        .init(
            id: id,
            name: title
        )
    }
}
