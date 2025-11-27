//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Evgeniy Kostyaev on 27.11.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testViewController() throws {
        let trackersViewController = TrackersViewController()
        
        assertSnapshots(of: {
            trackersViewController
        }(), as: [.image])
    }
}
