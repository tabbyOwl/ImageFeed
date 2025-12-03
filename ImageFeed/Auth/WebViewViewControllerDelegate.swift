//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
