import XCTest
@testable import APLNetworkLayer

final class APLNetworkLayerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(APLNetworkLayer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
