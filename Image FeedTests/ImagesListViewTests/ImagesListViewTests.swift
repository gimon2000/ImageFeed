//
//  ImagesListViewTests.swift
//  Image FeedTests
//
//  Created by gimon on 18.05.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    private let photo = Photo.init(
        id: "",
        size: CGSize(),
        createdAt: Date(),
        welcomeDescription: nil,
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false
    )
    
    func testNotUpdateTableView() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        //when
        presenter.updateTableViewAnimated()
        
        //then
        XCTAssertFalse(viewSpy.updateTableViewCalled)
    }
    
    func testUpdateTableView() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        presenter.photos.append(photo)
        
        //when
        presenter.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(viewSpy.updateTableViewCalled)
    }
    
    func testConfigCell() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        presenter.photos.append(photo)
        presenter.photos.append(photo)
        
        //when
        presenter.configCell(for: ImagesListCell(), with: 0)
        
        //then
        XCTAssertTrue(viewSpy.configCellCalled)
    }
}
