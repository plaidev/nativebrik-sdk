//
//  E2EApp.swift
//  E2E
//
//  Created by Ryosuke Suzuki on 2023/11/14.
//

import SwiftUI
import Nativebrik

@main
struct E2EApp: App {
    var body: some Scene {
        WindowGroup {
            NativebrikProvider(client: NativebrikClient(projectId: "ckto7v223akg00ag3jsg")) {
                ContentView()
            }
        }
    }
}
