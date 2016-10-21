import Foundation

struct TextPosition {
    var line: UInt
    var column: UInt
}

extension TextPosition: Comparable {
    public static func <(lhs: TextPosition, rhs: TextPosition) -> Bool {
        return lhs.line < rhs.line && lhs.column < rhs.column
    }
    
    public static func ==(lhs: TextPosition, rhs: TextPosition) -> Bool {
        return lhs.line == rhs.line && lhs.column == rhs.column
    }
}

extension String {
    // maybe replace this with enumerateSubstrings?
    func allRanges(of string: String) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()
        var searchRange: Range<String.Index>? = nil
        while true {
            guard let range = range(of: string, range: searchRange) else {
                break
            }
            ranges.append(range)
            searchRange = range.upperBound ..< endIndex
        }
        return ranges
    }
    
    func position(where condition: (TextPosition, String.Index) -> Bool) -> (position: TextPosition, index: String.Index)? {
        var position = TextPosition(line: 0, column: 0)
        for i in characters.indices {
            if condition(position, i) {
                return (position, i)
            }
            let char = self[i]
            let charScalar = UnicodeScalar(String(char))!
            if CharacterSet.newlines.contains(charScalar) {
                position.line += 1
                position.column = 0
            }
            else {
                position.column += 1
            }
        }
        if condition(position, endIndex) {
            return (position, endIndex)
        }
        return nil
    }
    
    func position(of index: String.Index) -> TextPosition? {
        return position(where: { _, _index in
            _index == index
        })?.position
    }
    
    func positionRange(of range: Range<String.Index>) -> Range<TextPosition>? {
        guard let lowerBound = position(of: range.lowerBound) else {
            return nil
        }
        guard let upperBound = position(of: range.upperBound) else {
            return nil
        }
        return lowerBound ..< upperBound
    }
    
    func positionRanges(of string: String) -> [Range<TextPosition>] {
        return allRanges(of: string).map { positionRange(of: $0)! }
    }
    
    func index(for position: TextPosition) -> String.Index? {
        return self.position(where: { _position, _ in
            _position == position
        })?.index
    }
    
    func range(for positionRange: Range<TextPosition>) -> Range<String.Index>? {
        guard let lowerBound = index(for: positionRange.lowerBound) else {
            return nil
        }
        guard let upperBound = index(for: positionRange.upperBound) else {
            return nil
        }
        return lowerBound ..< upperBound
    }
}
