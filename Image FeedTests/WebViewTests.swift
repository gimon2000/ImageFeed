//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by gimon on 14.05.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() throws {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "WebViewViewControllerID"
        ) as! WebViewViewController
        let webViewPresenter = WebViewPresenterSpy()
        viewController.presenter = webViewPresenter
        webViewPresenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(webViewPresenter.viewDidLoadCalled, "ViewDidLoad not called")
    }
}
