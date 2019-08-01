//
//  JSONDataEncoderTests.swift
//  SampleTests
//
//  Created by Tino Rachui on 01.08.19.
//  Copyright © 2019 Ahmet Akbal. All rights reserved.
//

import XCTest
@testable import Sample
import APLNetworkLayer

struct ModelObject: Codable {
    var title: String?
    var subtitle: String?
}

class JSONDataEncoderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONEncoder() {
        let modelObject = ModelObject(title: "Title", subtitle: "Subtitle")
        let data = try? JSONDataEncoder.withObject(modelObject)

        XCTAssertNotNil(data, "Data could not be encoded")

        let decodedData: ModelObject? = try? JSONDataDecoder.fromData(data: data!)

        XCTAssert(modelObject.title == decodedData?.title &&
                  modelObject.subtitle == decodedData?.subtitle,
                  "Decoded object doesn't match the original object")
    }
}
