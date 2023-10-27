//
//  remote-config.swift
//  NativebrikTests
//
//  Created by Ryosuke Suzuki on 2023/10/27.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import Nativebrik

// https://nativebrik.com/experiments/result?projectId=ckto7v223akg00ag3jsg
let PROJECT_ID_FOR_TEST = "ckto7v223akg00ag3jsg"
// https://nativebrik.com/experiments/result?projectId=ckto7v223akg00ag3jsg&id=ckto9eq23akg00ag3jt0
let REMOTE_CONFIG_ID_1_FOR_TEST = "REMOTE_CONFIG_1"
let REMOTE_CONFIG_1_FOR_TEST_MESSAGE = "hello"
let UNKNOWN_EXPERIMENT_ID = "UNKNOWN_ID_XXXXXX"

final class RemoteConfigTests: XCTestCase {
    func testRemoteConfigShouldFetch() {
        let expectation = expectation(description: "Fetch remote config for test")
        
        var didLoadingPhaseCome = false
        let client = NativebrikClient(projectId: PROJECT_ID_FOR_TEST)
        client.experiment.remoteConfig(REMOTE_CONFIG_ID_1_FOR_TEST) { phase in
            switch phase {
            case .completed(let variant):
                let message = variant.getAsString("message")
                XCTAssertEqual(message, REMOTE_CONFIG_1_FOR_TEST_MESSAGE)
                expectation.fulfill()
            case .loading:
                didLoadingPhaseCome = true
            case .failure:
                XCTFail("should found the remote config")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(didLoadingPhaseCome)
        }
    }
    
    func testRemoteConfigShouldNotFetch() {
        let expectation = expectation(description: "Fetch non-exist remote config for test")
        
        var didLoadingPhaseCome = false
        let client = NativebrikClient(projectId: PROJECT_ID_FOR_TEST)
        client.experiment.remoteConfig(UNKNOWN_EXPERIMENT_ID) { phase in
            switch phase {
            case .completed:
                XCTFail("should found the remote config")
            case .loading:
                didLoadingPhaseCome = true
            case .failure:
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(didLoadingPhaseCome)
        }
    }
}

final class RemoteConfigAsViewTests: XCTestCase {
    
    struct RemoteView: View {
        @EnvironmentObject var nativebrik: NativebrikClient
        var body: some View {
            Group {
                nativebrik
                    .experiment
                    .remoteConfigAsView(REMOTE_CONFIG_ID_1_FOR_TEST) { phase in
                        switch phase {
                        case .completed(let variant):
                            Text(variant.get("message") ?? "No")
                        default:
                            Text("Not Found")
                        }
                    }
            }
        }
    }

    struct ContentView: View {
        var body: some View {
            NativebrikProvider(client: NativebrikClient(projectId: PROJECT_ID_FOR_TEST)) {
                RemoteView()
            }
        }
    }

    func testShouldFetch() throws {
        let _ = ContentView()
    }
}
