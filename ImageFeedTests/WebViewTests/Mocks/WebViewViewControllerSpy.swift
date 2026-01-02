//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/28.
//

import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(_ request: URLRequest) {
        print("🍎 spy load")
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {
    }

    func setProgressHidden(_ isHidden: Bool) {
    }
}
