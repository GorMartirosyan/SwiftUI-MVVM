//
//  AppMasterViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import Foundation
import Combine

class AppMasterViewModel: ViewModelBase<AppMasterView.ViewState, AppMasterView.ViewInput> {
    
    @Preference(\.contentViewType) private static var contentViewType
    private var sceneCancelable: AnyCancellable?
    
    init() {
        super.init(state: .init())
    }
    
    override var bindings: [AnyCancellable] {
        [
            AppMasterViewModel.$contentViewType.publisher
                .receive(on: DispatchQueue.main, options: nil)
                .sink { _ in self.setContentViewType() }
        ]
    }
    
    private func setContentViewType() {
        defer { state.contentViewType = Self.contentViewType }
        
        switch Self.contentViewType {
        case .main:
            state.mainViewModel = createContentViewModel()
            
        case .finish:
            state.finishViewModel = createFinishViewModel()
        }
    }
    
    private func createFinishViewModel() -> FinishView.ViewModel? {
        return FinishViewModel().toAnyViewModel()
    }

    private func createContentViewModel() -> DiscountView.ViewModel? {
        return DiscountViewModel().toAnyViewModel()
    }

}
