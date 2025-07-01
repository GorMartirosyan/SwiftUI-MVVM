//
//  PaymentView.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI

extension PaymentInfoView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    struct ViewState {
        var isLoading = false
        var isRefreshing = false
        var paymentTypes: [PaymentType]?
        var selectedPaymentType: PaymentType?
        var filterText = ""
    }
    
    enum ViewInput {
        case loadPaymentTypes
        case reloadPaymentTypes
        case choosePaymentType(PaymentType)
        case filterTextUpdated(String)
    }
}

struct PaymentInfoView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var refreshContinuation: CheckedContinuation<Void, Never>?

    @ViewBuilder
    private func textCell(
        item: PaymentType
    ) -> some View {
        HStack(spacing: 0) {
            Button {
                viewModel.trigger(.choosePaymentType(item))
            } label: {
                Text(item.name)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.black)
                    .padding(0)
            }
            Spacer()
            
            if viewModel.selectedPaymentType?.id == item.id {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    Spinner(isAnimating: true, style: .medium).eraseToAnyView()
                } else {
                    List {
                        ForEach(viewModel.paymentTypes ?? []) {
                            textCell(item: $0)
                        }
                    }
                    .refreshable {
                        await withCheckedContinuation { continuation in
                            refreshContinuation = continuation
                            viewModel.trigger(.reloadPaymentTypes)
                        }
                    }
                    .searchable(text: $viewModel.state.filterText, prompt: "Search")
                }
            }
            .onAppear { viewModel.trigger(.loadPaymentTypes) }
            .navigationTitle("Payment info")
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: viewModel.filterText) { newValue in
                viewModel.trigger(.filterTextUpdated(newValue))
            }
            .onChange(of: viewModel.isRefreshing) { isRefreshing in
                if !isRefreshing { refreshContinuation?.resume() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .opacity(viewModel.selectedPaymentType == nil ? 0 : 1)
                    .disabled(viewModel.selectedPaymentType == nil)
                }
            }
        }
    }
}


