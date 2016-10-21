//
//  SourceEditorCommand.swift
//  extension
//
//  Created by Ricky Joudrey on 10/11/16.
//  Copyright © 2016 com. All rights reserved.
//

import Foundation
import XcodeKit

class MarkAllLikeThisCommand: NSObject, XCSourceEditorCommand {
    enum Errors: Error {
        case TooManySelections
        case NoSelections
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let buffer = invocation.buffer
        let selections = buffer.selections
        let numSelections = selections.count
        guard let selectionRange = selections.firstObject as? XCSourceTextRange, numSelections == 1 else {
            if numSelections == 0 {
                completionHandler(Errors.NoSelections)
            }
            else {
                completionHandler(Errors.TooManySelections)
            }
            return
        }
        completionHandler(nil)
    }
}
