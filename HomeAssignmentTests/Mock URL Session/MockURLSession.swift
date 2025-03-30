//
//  MockURLSession.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 30/03/25.
//

import Foundation
@testable import HomeAssignment

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return MockURLSessionDataTask() // Return a mock data task
    }
}

// Mock URLSessionDataTask (since we don't actually execute tasks)
class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() { } // Do nothing
}

