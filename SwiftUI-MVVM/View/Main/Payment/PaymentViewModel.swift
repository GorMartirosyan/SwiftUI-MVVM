//
//  PaymentViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import Combine

class PaymentViewModel: ViewModelBase<PaymentInfoView.ViewState, PaymentInfoView.ViewInput> {
    fileprivate let textFilterSubject = CurrentValueSubject<String, Never>("")
    fileprivate let paymentTypesSubject = CurrentValueSubject<[PaymentType], Never>([])
    fileprivate let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var paymentService: PaymentServiceProtocol
    let onSelected: (PaymentType) -> Void
    
    init(selectedPaymentType: PaymentType?,
         paymentService: PaymentServiceProtocol,
         onSelected: @escaping (PaymentType) -> Void = { _ in }) {
        
        self.paymentService = paymentService
        self.onSelected = onSelected
        super.init(state: .init(selectedPaymentType: selectedPaymentType))
        self.state.selectedPaymentType = selectedPaymentType
    }
    
    override var bindings: [AnyCancellable] {
        [
            Publishers.CombineLatest(paymentTypesSubject, textFilterSubject)
                .map { types, filterText in
                    if filterText.isEmpty {
                        return types
                    } else {
                        return types.filter {
                            $0.name.contains(filterText)
                        }
                    }
                }
                .assignWeakly(to: \.state.paymentTypes, on: self),
            
            isLoadingSubject
                .assignWeakly(to: \.state.isLoading, on: self),
            
        ]
    }
    
    private func loadPaymentMethods() {
        paymentService.getPaymentTypes()
            .handleEvents(receiveSubscription: {[weak self] _ in self?.isLoadingSubject.send(true) },
                          receiveCompletion: {[weak self] _ in self?.isLoadingSubject.send(false) }
            )
            .sinkResult{ [weak self] result in
                switch result {
                case let .success(types):
                    self?.paymentTypesSubject.send(types)
                case let .failure(error):
                    print(error)
                }
            }
            .store(in: &cancelables)
    }

    private func reloadPaymentMethods() {
        paymentService.getPaymentTypes()
            .handleEvents(receiveSubscription: {[weak self] _ in self?.state.isRefreshing = true },
                          receiveCompletion: {[weak self] _ in self?.state.isRefreshing = false }
            )
            .sinkResult{ [weak self] result in
                switch result {
                case let .success(types):
                    self?.paymentTypesSubject.send(types)
                case let .failure(error):
                    print(error)
                }
            }
            .store(in: &cancelables)
    }
    
    override func trigger(
        _ input: PaymentInfoView.ViewInput
    ) {
        switch input {
        case .loadPaymentTypes:
            self.loadPaymentMethods()
        case let .choosePaymentType(payment):
            self.onSelected(payment)
            self.state.selectedPaymentType = payment
        case .reloadPaymentTypes:
            self.reloadPaymentMethods()
        case let .filterTextUpdated(filterText):
            state.filterText = String(filterText)
            textFilterSubject.send(state.filterText)
        }
    }
}
