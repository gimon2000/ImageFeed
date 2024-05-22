//
//  ProfileViewControllerTests.swift
//  Image FeedTests
//
//  Created by gimon on 19.05.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    func testAlertExit() throws {
        //given
        let alertPresenter = AlertPresenterSpy()
        let profileViewController = ProfileViewController(alertPresenter: alertPresenter)
        alertPresenter.view = profileViewController
        
        //when
        profileViewController.didClickExitButton((Any).self)
        
        //then
        XCTAssertTrue(alertPresenter.alertExitCalled)
    }
}
