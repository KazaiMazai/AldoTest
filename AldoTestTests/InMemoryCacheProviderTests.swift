//
//  InMemoryCacheProviderTests.swift
//  AldoTestTests
//
//  Created by Sergey Kazakov on 19/02/2020.
//  Copyright © 2020 Piyush Sharma. All rights reserved.
//

import Foundation

import XCTest
import EitherResult
@testable import AldoTest

class InMemoryCacheProviderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCacheRetrievedSuccess() {
        let timestampProvideerMock = MockCacheTimestampProvider(currentTimestamp: Date())
        let cacheLifespanTimeInterval = 1.0

        let inMemoryCacheProvider = InMemoryCacheProvider<String, Data>(cacheTimestampProvider: timestampProvideerMock,
                                                                        cacheLifespanTimeInterval: cacheLifespanTimeInterval)

        let testStringKey = "Key"
        let testStringValue = "Hello"

        guard let testData = testStringValue.data(using: .utf8) else {
            assertionFailure("Could not get test data")
            return
        }


        let expectation = XCTestExpectation(description: "Wait for cache callback")

        inMemoryCacheProvider.addObject(testData, for: testStringKey) {
            timestampProvideerMock.currentTimestamp = timestampProvideerMock.currentTimestamp.addingTimeInterval(cacheLifespanTimeInterval * 0.5)

            inMemoryCacheProvider.retrieveObjectFor(key: testStringKey) {
                $0.onError({ assertionFailure($0.localizedDescription) })
                  .do { result in
                    switch result {
                    case .stale:
                        assertionFailure("Cached result is stale")
                    case .notFound:
                        assertionFailure("Cached result not found")
                    case .retrievedFromCache(let data):
                        assert(testData == data)
                    }

                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testCacheOutOfDate() {
        let timestampProvideerMock = MockCacheTimestampProvider(currentTimestamp: Date())
        let cacheLifespanTimeInterval = 1.0

        let inMemoryCacheProvider = InMemoryCacheProvider<String, Data>(cacheTimestampProvider: timestampProvideerMock,
                                                                        cacheLifespanTimeInterval: cacheLifespanTimeInterval)

        let testStringKey = "Key"
        let testStringValue = "Hello"

        guard let testData = testStringValue.data(using: .utf8) else {
            assertionFailure("Could not get test data")
            return
        }


        let expectation = XCTestExpectation(description: "Wait for cache callback")

        inMemoryCacheProvider.addObject(testData, for: testStringKey) {
            timestampProvideerMock.currentTimestamp = timestampProvideerMock.currentTimestamp.addingTimeInterval(cacheLifespanTimeInterval * 5)

            inMemoryCacheProvider.retrieveObjectFor(key: testStringKey) {
                $0.onError({ assertionFailure($0.localizedDescription) })
                  .do { result in

                    switch result {
                    case .stale:
                        break
                    case .notFound:
                        assertionFailure("Cached result not found")
                    case .retrievedFromCache(_):
                        assertionFailure("Some cached result is returned")
                    }

                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testMissingCache() {
           let timestampProvideerMock = MockCacheTimestampProvider(currentTimestamp: Date())
           let cacheLifespanTimeInterval = 1.0

           let inMemoryCacheProvider = InMemoryCacheProvider<String, Data>(cacheTimestampProvider: timestampProvideerMock,
                                                                           cacheLifespanTimeInterval: cacheLifespanTimeInterval)

           let testStringKey = "Key"
           let testStringValue = "Hello"

           guard let testData = testStringValue.data(using: .utf8) else {
               assertionFailure("Could not get test data")
               return
           }


           let expectation = XCTestExpectation(description: "Wait for cache callback")

           timestampProvideerMock.currentTimestamp = timestampProvideerMock.currentTimestamp.addingTimeInterval(cacheLifespanTimeInterval * 5)

           inMemoryCacheProvider.retrieveObjectFor(key: testStringKey) {
               $0.onError({ assertionFailure($0.localizedDescription) })
                 .do { result in

                   switch result {
                   case .stale:
                       assertionFailure("Cached result is stale")
                   case .notFound:
                       break
                   case .retrievedFromCache(_):
                       assertionFailure("Some cached result is returned")
                   }

                   expectation.fulfill()
               }
           }

           wait(for: [expectation], timeout: 10.0)
       }

}
