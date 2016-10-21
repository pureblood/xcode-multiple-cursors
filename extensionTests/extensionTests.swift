//
//  extensionTests.swift
//  extensionTests
//
//  Created by Ricky Joudrey on 10/20/16.
//  Copyright © 2016 com. All rights reserved.
//

import XCTest

let lines = [
    "struct A {",
    "   let t: Int",
    "}"
]
let buffer = lines.joined(separator: "\n")

class extensionTests: XCTestCase {
    
    func testSingleLineMatch() {
        let letRange = buffer.positionRanges(of: "let").first!
        XCTAssert(letRange.lowerBound.line == 1)
        XCTAssert(letRange.lowerBound.column == 3)
        XCTAssert(letRange.upperBound.line == 1)
        XCTAssert(letRange.upperBound.column == 6)
    }
    
    func testMultiLineMatch() {
        let intRange = buffer.positionRanges(of: "Int\n}").first!
        XCTAssert(intRange.lowerBound.line == 1)
        XCTAssert(intRange.lowerBound.column == 10)
        XCTAssert(intRange.upperBound.line == 2)
        XCTAssert(intRange.upperBound.column == 1)
    }
    
    func testSingleLineSelection() {
        let textPositionRange = TextPosition(line: 1, column: 3) ..< TextPosition(line: 1, column: 6)
        let bufferRange = buffer.range(for: textPositionRange)!
        XCTAssert(String(buffer[bufferRange]) == "let")
    }
    
    func testMultiLineSelection() {
        let textPositionRange = TextPosition(line: 1, column: 10) ..< TextPosition(line: 2, column: 1)
        let bufferRange = buffer.range(for: textPositionRange)!
        XCTAssert(String(buffer[bufferRange]) == "Int\n}")
    }
}
