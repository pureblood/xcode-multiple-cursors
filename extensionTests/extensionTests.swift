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
        XCTAssert(letRange.start.line == 1)
        XCTAssert(letRange.start.column == 3)
        XCTAssert(letRange.end.line == 1)
        XCTAssert(letRange.end.column == 5)
    }
    
    func testMultiLineMatch() {
        let intRange = buffer.positionRanges(of: "Int\n}").first!
        XCTAssert(intRange.start.line == 1)
        XCTAssert(intRange.start.column == 10)
        XCTAssert(intRange.end.line == 2)
        XCTAssert(intRange.end.column == 0)
    }
    
    func testSingleLineSelection() {
        let textPositionRange = TextRange(
            start: TextPosition(line: 1, column: 3),
            end: TextPosition(line: 1, column: 5))
        let bufferRange = buffer.range(for: textPositionRange)!
        XCTAssert(String(buffer[bufferRange]) == "let")
    }
    
    func testMultiLineSelection() {
        let textPositionRange = TextRange(
            start: TextPosition(line: 1, column: 10),
            end: TextPosition(line: 2, column: 0))
        let bufferRange = buffer.range(for: textPositionRange)!
        XCTAssert(String(buffer[bufferRange]) == "Int\n}")
    }
}
