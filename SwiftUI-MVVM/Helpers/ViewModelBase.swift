//
//  ViewModelBase.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import Combine

class ViewModelBase<State, Input>: ViewModel {
    
    @Published var state: State
    var bindings: [AnyCancellable] { [] }
    
    init(
        state: State
    ) {
        self.state = state
        bind()
        print("init - \(String(describing: self))")
    }
    
    deinit {
        print("deinit - \(String(describing: self))")
    }
    
    final func bind() {
        bindings.forEach { $0.store(in: &cancelables) }
    }
    
    func trigger(
        _ input: Input
    ) {
        fatalError("Override trigger")
    }
}
