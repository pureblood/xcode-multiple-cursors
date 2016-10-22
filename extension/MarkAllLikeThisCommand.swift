//
//  SourceEditorCommand.swift
//  extension
//
//  Created by Ricky Joudrey on 10/11/16.
//  Copyright © 2016 com. All rights reserved.
//

import Foundation
import XcodeKit

extension TextPosition {
    init(position: XCSourceTextPosition) {
        self.init(line: UInt(position.line), column: UInt(position.column))
    }
}

extension TextRange {
    init(position: XCSourceTextRange) {
        self.init(start: TextPosition(position: position.start),
                  end: TextPosition(position: position.end))
    }
}

extension XCSourceTextPosition {
    init(position: TextPosition) {
        line = Int(position.line)
        column = Int(position.column)
    }
}

extension XCSourceTextRange {
    convenience init(range: TextRange) {
        self.init(start: XCSourceTextPosition(position: range.start),
                  end: XCSourceTextPosition(position: range.end))
    }
}

class MarkAllLikeThisCommand: NSObject, XCSourceEditorCommand {
    enum Errors: Error {
        case TooManySelections
        case NoSelections
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let buffer = invocation.buffer.completeBuffer
        let selections = invocation.buffer.selections.map { $0 as! XCSourceTextRange }
        guard let selection = selections.first, selections.count == 1 else {
            if selections.count == 0 {
                completionHandler(Errors.NoSelections)
            }
            else {
                completionHandler(Errors.TooManySelections)
            }
            return
        }
        let selectedText = buffer[buffer.range(for: TextRange(position: selection))!]
        let matches = buffer.positionRanges(of: selectedText).map(XCSourceTextRange.init)
        invocation.buffer.selections.removeAllObjects()
        // This does nothing :(
        invocation.buffer.selections.addObjects(from: matches)
        completionHandler(nil)
    }
}
