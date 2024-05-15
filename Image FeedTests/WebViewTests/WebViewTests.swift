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
    
    func testPresenterCallsLoadRequest() throws {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = WebViewViewControllerSpy()
        let webViewPresenter = WebViewPresenter(
            authHelper: AuthHelper(
                configuration: AuthConfiguration.standard
            )
        )
        viewController.presenter = webViewPresenter
        webViewPresenter.view = viewController
        
        //when
        webViewPresenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadCalled, "load not called")
    }
    
    func testProgressVisibleWhenLessThenOne() throws {
        //given
        let webViewPresenter = WebViewPresenter(
            authHelper: AuthHelper(
                configuration: AuthConfiguration.standard
            )
        )
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = webViewPresenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress, "shouldHideProgress not false")
    }
    
    func testProgressHiddenWhenOne() throws {
        //given
        let webViewPresenter = WebViewPresenter(
            authHelper: AuthHelper(
                configuration: AuthConfiguration.standard
            )
        )
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = webViewPresenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress, "shouldHideProgress not true")
    }
    
    func testAuthHelperAuthURL() throws {
        //given
        let authConfiguration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: authConfiguration)
        
        //when
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else {
            XCTAssertTrue(false, "url?.absoluteString nil")
            return
        }
        
        //then
        XCTAssertTrue(urlString.contains(authConfiguration.unsplashURLString))
        XCTAssertTrue(urlString.contains("/oauth/authorize"))
        XCTAssertTrue(urlString.contains(authConfiguration.accessKey))
        XCTAssertTrue(urlString.contains(authConfiguration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(authConfiguration.accessScope))
    }
    
    func testCodeFromURL() throws {
        //given
        guard var components = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        else {
            XCTAssertTrue(false, "components nil")
            return
        }
        components.queryItems = [ URLQueryItem(name: "code", value: "test code") ]
        guard let url = components.url else {
            XCTAssertTrue(false, "url nil")
            return
        }
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}
