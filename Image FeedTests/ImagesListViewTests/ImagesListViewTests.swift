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
    
    func testNotUpdatePhotos() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        //when
        let range = presenter.updatePhotos()
        
        //then
        XCTAssertNil(range)
    }
    
    func testUpdatePhotos() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        ImagesListService.shared.photos.append(photo)
        
        //when
        let range = presenter.updatePhotos()
        
        //then
        XCTAssertEqual(range, 0..<1)
    }
    
    func testGetDataCellNil() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        //when
        let dataCell = presenter.getDataCell(with: 0)
        
        //then
        XCTAssertNil(dataCell)
    }
    
    func testGetDataCell() throws {
        //given
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        presenter.photos.append(photo)
        presenter.photos.append(photo)
        
        //when
        guard let dataCell = presenter.getDataCell(with: 0) else {
            XCTAssert(true)
            return
        }
        
        //then
        XCTAssertFalse(dataCell.isLiked)
    }
}
