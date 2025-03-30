//
//  NetworkManagerTests.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 30/03/25.
//

import XCTest
@testable import HomeAssignment

class NetworkManagerTests: XCTestCase {
    var mockSession: MockURLSession!
    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession) // Inject mock session
    }

    override func tearDown() {
        mockSession = nil
        networkManager = nil
        super.tearDown()
    }

    func testRequest_Success() {
        let mockData = """
        { "results": [{ "id": 1, "title": "Test Movie" }] }
        """.data(using: .utf8)!

        mockSession.data = mockData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let expectation = self.expectation(description: "Completion handler invoked")

        networkManager.request(.movies, method: .GET) { (result: Result<MovieResponse, NetworkError>) in
            switch result {
            case .success(let movieResponse):
                XCTAssertEqual(movieResponse.results?.first?.id, 1)
                XCTAssertEqual(movieResponse.results?.first?.title, "Test Movie")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

}
