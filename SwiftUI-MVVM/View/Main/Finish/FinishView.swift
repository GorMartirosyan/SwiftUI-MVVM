//
//  FinishView.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI

extension FinishView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    struct ViewState { }
    
    enum ViewInput { }
}

struct FinishView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            Text("Congratulations 🥳")
                .foregroundColor(.white)
        }
    }
}
