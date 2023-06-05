//
//  DetailViewControllerTest.swift
//  Test MLTests
//
//  Created by Juan Esteban Pelaez on 17/11/21.
//

import XCTest
@testable import ChallengeMeli

class DetailViewControllerTests: XCTestCase {

    private var sut: DetailViewController!
    private var urlSessionMock = MockURLSession()

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "detailViewController") as? DetailViewController else {
            XCTFail("Could not instantiate viewController as DetailViewController")
            return
        }

        urlSessionMock.data = try? JSONSerialization.data(withJSONObject: MockConstants.product)

        sut = viewController

        sut.productResult = MockConstants.resultItem
        sut.viewModel = DetailViewModel(apiService: APIService(session: urlSessionMock))

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_detailProduct() {

        let expectation = expectation(description: "Expectation from not result")

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        XCTAssertNotNil(sut.viewModel.product)
    }

}
