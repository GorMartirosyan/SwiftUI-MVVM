//
//  PaymentAPI.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 29.06.25.
//

import Combine

extension API { enum Payment {} }

extension API.Payment {
    typealias Response = API.Payment.Model.Response.PaymentType
    
    static func getPaymentTypes() -> AnyPublisher<[Response], Error> {
        let items: [Response] = [
            .init(id: 1, title: "Apple Pay"),
            .init(id: 2, title: "Visa"),
            .init(id: 3, title: "Mastercard"),
            .init(id: 4, title: "Maestro"),
            .init(id: 5, title: "Google Pay")
        ].shuffled()
        return Publishers.sampleRequest(items)
    }
}

