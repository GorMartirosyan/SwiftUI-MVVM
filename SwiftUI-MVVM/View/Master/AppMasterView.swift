//
//  AppMasterView.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI

extension AppMasterView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    struct ViewState {
        var contentViewType: ContentViewType?
        var mainViewModel: DiscountView.ViewModel?
        var finishViewModel: FinishView.ViewModel?
    }
    
    enum ViewInput { }
}

struct AppMasterView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.contentViewType {
        case .main:
            Unwrap(viewModel.mainViewModel) { DiscountView(viewModel: $0) }
        case .finish:
            Unwrap(viewModel.finishViewModel) { FinishView(viewModel: $0) }
        case .none:
            NotImplementedView()
        }
    }
}
