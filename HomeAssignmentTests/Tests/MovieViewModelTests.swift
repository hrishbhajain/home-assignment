//
//  MovieViewModelTests.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 30/03/25.
//

import XCTest
@testable import HomeAssignment

class MockNetworkManager {
    var mockResult: Result<MovieResponse, NetworkError>?

    func request<T: Decodable>(_ endpoint: EndPoint, method: HTTPMethod = .GET, parameters: JSONDictionary? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let result = self.mockResult as? Result<T, NetworkError> {
                completion(result)
            } else {
                completion(.failure(.networkError(NSError(domain: "MockNetworkError", code: -1009, userInfo: nil))))
            }
        }
    }
}



class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MovieViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchMovies_Success() {
        // Arrange
        let mockResponse = MovieResponse(
            page: 1,
            results: [
                MovieData(
                    adult: false,
                    backdropPath: "/avengers_backdrop.jpg",
                    genreIDS: [28, 12, 878],
                    id: 1,
                    originalTitle: "The Avengers",
                    overview: "Superhero movie",
                    popularity: 8.9,
                    posterPath: "/avengers.jpg",
                    releaseDate: "2012-04-26",
                    title: "Avengers",
                    video: false,
                    voteAverage: 8.5,
                    voteCount: 12000
                ),
                MovieData(
                    adult: false,
                    backdropPath: "/batman_backdrop.jpg",
                    genreIDS: [28, 80, 18],
                    id: 2,
                    originalTitle: "The Dark Knight Rises",
                    overview: "Dark knight rises",
                    popularity: 9.2,
                    posterPath: "/batman.jpg",
                    releaseDate: "2012-07-20",
                    title: "Batman",
                    video: false,
                    voteAverage: 8.2,
                    voteCount: 15000
                )
            ],
            totalPages: 1,
            totalResults: 2
        )

        mockNetworkManager.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Movies should be fetched successfully")

        // Act
        viewModel.fetchMovies(reset: true)  

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assert
            XCTAssertEqual(self.viewModel.getMovies().count, 20, "Expected 2 movies, but got \(self.viewModel.getMovies().count)")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }



    func testFetchMovies_Failure() {
        // Arrange
        mockNetworkManager.mockResult = .failure(.networkError(NSError(domain: "", code: -1009, userInfo: nil)))

        let expectation = self.expectation(description: "Wait for network failure to trigger errorOccurred")

        // In order to make this work, send some incorrect data to api
        viewModel.fetchMovies()

        // Wait for the async network failure response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assert
            XCTAssertTrue(self.viewModel.errorOccurred, "Expected errorOccurred to be true, but it was false.")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
