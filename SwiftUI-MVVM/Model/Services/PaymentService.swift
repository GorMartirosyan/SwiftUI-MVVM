//
//  PaymentService.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 29.06.25.
//

import Combine

protocol PaymentServiceProtocol {
    func getPaymentTypes() -> AnyPublisher<[PaymentType], Error>
}

final class PaymentService: PaymentServiceProtocol {
    func getPaymentTypes() -> AnyPublisher<[PaymentType], Error> {
        API.Payment.getPaymentTypes()
            .map { items in items.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
