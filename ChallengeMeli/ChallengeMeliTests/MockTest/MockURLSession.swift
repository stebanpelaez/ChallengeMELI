//
//  URLSessionMock.swift
//  vssh-ios-communicationTests
//
//  Created by Juan Esteban Peláez Martínez on 23/04/23.
//  Copyright © 2023 Valid Colombia. All rights reserved.
//

import Foundation

//  Mock para simular la respuesta http para las pruebas unitarias

class MockURLSession: URLSession {

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var statusCode: Int = 200

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let data = self.data
        let error = self.error

        return MockURLSessionDataTask {
            if let response = HTTPURLResponse(url: url, statusCode: self.statusCode, httpVersion: nil, headerFields: nil) {
                completionHandler(data, response, error)
            }
        }
    }

}

class MockURLSessionDataTask: URLSessionDataTask {

    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
