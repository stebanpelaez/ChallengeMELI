//
//  APIServiceTest.swift
//  ChallengeMeliTests
//
//  Created by Juan Esteban Peláez Martínez on 4/06/23.
//

import XCTest

@testable import ChallengeMeli

final class APIServiceTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetService() {

        let consumeService = expectation(description: "Consume get services from server")

        let urlSessionMock = MockURLSession()
        urlSessionMock.data = try? JSONSerialization.data(withJSONObject: MockConstants.responseDescription)

        let apiService = APIService(session: urlSessionMock)

        let url = Constants.urlDetailDescription.rawValue

        apiService.getService(url: url, type: Description.self) { result in
            switch result {
            case .success(let description):
                XCTAssertNotNil(description.plainText)
                consumeService.fulfill()
            case .failure(let error):
                assertionFailure()
            }
        }

        wait(for: [consumeService], timeout: 3.0)
    }

    func testGetServiceError() {

        let consumeService = expectation(description: "Consume get services Error from server")

        let urlSessionMock = MockURLSession()
        urlSessionMock.statusCode = 401
        urlSessionMock.data = try? JSONSerialization.data(withJSONObject: MockConstants.responseDescription)

        let apiService = APIService(session: urlSessionMock)

        let url = Constants.urlDetailDescription.rawValue

        apiService.getService(url: url, type: Description.self) { result in
            switch result {
            case .success(let description):
                assertionFailure()
            case .failure(let error):
                XCTAssertNotNil(error.localizedDescription)
                consumeService.fulfill()
            }
        }

        wait(for: [consumeService], timeout: 3.0)
    }

}
