//
//  ProfileCoordinatorSpy.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/23.
//
import ImageFeed

final class ProfileCoordinatorSpy: ProfileCoordinatorDelegate {
    var didLogoutCalled = false

    func didLogout() {
        didLogoutCalled = true
    }
}
