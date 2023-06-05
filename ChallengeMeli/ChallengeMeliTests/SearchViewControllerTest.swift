//
//  Test_MLTests.swift
//  Test MLTests
//
//  Created by Juan Esteban Pelaez on 14/11/21.
//

import XCTest
@testable import ChallengeMeli

class SearchViewControllerTests: XCTestCase {

    private var sut: SearchViewController!
    private var urlSessionMock = MockURLSession()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "searchViewController") as? SearchViewController else {
            XCTFail("Could not instantiate viewController as SearchViewController")
            return
        }
        sut = viewController

        sut.viewModel = SearchViewModel(apiService: APIService(session: urlSessionMock))

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_SearchList() {

        urlSessionMock.data = try? JSONSerialization.data(withJSONObject: MockConstants.items)

        sut.searchController.searchBar.text = "motorola"
        sut.newSearch()

        let expectation = expectation(description: "Expectation from result")

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        XCTAssertTrue(sut.viewModel.numberOfCells > 0)
        XCTAssertTrue(sut.labelEmpty.isHidden)
        XCTAssertTrue(sut.viewError.isHidden)
    }

    func test_noResultsFound() {

        urlSessionMock.data = try? JSONSerialization.data(withJSONObject: MockConstants.empty)

        sut.searchController.searchBar.text = "yas8d7adsh"
        sut.newSearch()

        let expectation = expectation(description: "Expectation from empty list")

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        XCTAssertEqual(sut.viewModel.numberOfCells, 0)
        XCTAssertFalse(sut.labelEmpty.isHidden)
    }

}
