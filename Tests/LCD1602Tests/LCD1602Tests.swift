import XCTest
import SwiftIO
@testable import LCD1602

final class LCD1602Tests: XCTestCase {

    static var allTests = [
        ("testExample", testExample),
    ]

    func testExample() throws {
        let i2c = I2C(Id.I2C0)
        let _ = LCD1602(i2c)
    }
}
