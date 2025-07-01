//
//  SwiftUI_MVVMApp.swift
//  SwiftUI-MVVM
//
//  Created by Gor Martirosyan on 19.06.25.
//

import SwiftUI
@_exported import MVVM_Base

@main
struct SwiftUI_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            AppMasterView(viewModel: AppMasterViewModel().toAnyViewModel())
        }
    }
}
