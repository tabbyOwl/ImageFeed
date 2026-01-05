//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/24.
//
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    
    var reloadDataCalled = false
    var insertRowsCalled = false
    var reloadRowsCalled = false
    var showErrorCalled = false
    var showHUDCalled = false
    var hideHUDCalled = false
    
    var insertedOldCount: Int?
    var insertedNewCount: Int?
    var reloadedIndexPaths: [IndexPath]?
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func insertRows(oldCount: Int, newCount: Int) {
        insertRowsCalled = true
        insertedOldCount = oldCount
        insertedNewCount = newCount
    }
    
    func reloadRows(indexPaths: [IndexPath]) {
        reloadRowsCalled = true
        reloadedIndexPaths = indexPaths
    }
    
    func showError() {
        showErrorCalled = true
    }
    
    func showLoadingHUD() {
        showHUDCalled = true
    }
    
    func hideLoadingHUD() {
        hideHUDCalled = true
    }
}
