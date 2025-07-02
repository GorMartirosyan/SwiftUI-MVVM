//
//  DiscountViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import Combine
import SwiftUI

class DiscountViewModel: ViewModelBase<DiscountView.ViewState, DiscountView.ViewInput> {
    @Preference(\.contentViewType) var contentViewType

    private var timerSubscription: Cancellable?
    private let timeLeftSubject = CurrentValueSubject<TimeInterval?, Never>(nil)
    static let timerDuration: TimeInterval = 60
    
    init() {
        super.init(state: .init())
        startTimer()
    }
    
    override var bindings: [AnyCancellable] {
        [
            timeLeftSubject
                .assign(to: \.state.timeLeft, on: self)
        ]
    }
    
    private lazy var timePassedPublisher: AnyPublisher<TimeInterval, Never> = {
        var subscriptionDate = Date()
        return Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .handleEvents(receiveSubscription: { _ in subscriptionDate = Date() })
            .map { subscriptionDate.distance(to: $0) }
            .eraseToAnyPublisher()
    }()

    private func startTimer() {
        timeLeftSubject.send(DiscountViewModel.timerDuration)
        timerSubscription = timePassedPublisher
            .sink { [weak self] timePassed in
                guard timePassed < DiscountViewModel.timerDuration else { self?.stopTimer(); return }
                let timeLeft = timePassed.distance(to: DiscountViewModel.timerDuration)
                self?.timeLeftSubject.send(timeLeft)
            }
    }
    
    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
        state.timeLeft = nil
    }
    
    private func createPaymentViewModel() -> PaymentInfoView.ViewModel? {
        return PaymentViewModel(selectedPaymentType: self.state.selectedPayment,
                                paymentService: PaymentService(),
                                onSelected: { self.state.selectedPayment = $0 }).toAnyViewModel()
    }
    
    override func trigger(
        _ input: DiscountView.ViewInput
    ) {
        switch input {
        case .didTapOnOpenPayment:
            self.state.paymentViewModel = createPaymentViewModel()
        case .didTapOnFinish:
            self.contentViewType = .finish
        }
    }
}

