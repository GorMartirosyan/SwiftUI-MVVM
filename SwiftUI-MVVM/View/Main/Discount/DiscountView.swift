//
//  DiscountView.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI

extension DiscountView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    struct ViewState {
        var paymentViewModel: PaymentInfoView.ViewModel?
        var selectedPayment: PaymentType?
        var timeLeft: TimeInterval?
    }
    
    enum ViewInput {
        case didTapOnOpenPayment
        case didTapOnFinish
    }
}

struct DiscountView: View {
    @ObservedObject var viewModel: ViewModel
    
    private var timeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }
    
    private var timeLeftString: String? {
        guard let timeLeft = viewModel.state.timeLeft else { return nil }
        return timeFormatter.string(from: timeLeft)
    }
    
    @ViewBuilder
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(20)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    Group {
                        if viewModel.selectedPayment != nil {
                            Text("Selected payment method: \(viewModel.selectedPayment?.name ?? "")")
                        } else {
                            Text("No payment method selected")
                        }
                    }.foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("You have only \(timeLeftString ?? "0") seconds left to get the discount")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    actionButton(title: "Open payment") {
                        viewModel.trigger(.didTapOnOpenPayment)
                    }
                    
                    if viewModel.state.selectedPayment != nil {
                        
                        Spacer().frame(height: 16)
                        
                        actionButton(title: "Finish") {
                            viewModel.trigger(.didTapOnFinish)
                        }
                    }
                }.padding(.horizontal, 16)
                    .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheetNavigation(item: $viewModel.state.paymentViewModel) { PaymentInfoView(viewModel: $0)
            }
        }
    }
}
