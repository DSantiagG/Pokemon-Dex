//
//  Array+OverlapChunks.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import Foundation

extension Array {
    /// Split the array into consecutive chunks of the given `size`, where each
    /// chunk overlaps the previous one by `overlap` elements.
    ///
    /// - Parameters:
    ///   - size: The maximum number of elements in each chunk. Must be > 0.
    ///   - overlap: Number of elements that the next chunk should overlap with the previous. Must be < `size`.
    /// - Returns: An array of arrays (`[[Element]]`) where each inner array is a chunk. Returns an empty array for invalid parameters.
    ///
    /// Example:
    /// ```swift
    /// [1,2,3,4,5].overlappedChunks(size: 3, overlap: 1)
    /// // -> [[1,2,3], [3,4,5]]
    /// ```
    func overlappedChunks(size: Int, overlap: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        guard overlap < size else { return [] }
        
        var result: [[Element]] = []
        var index = 0
        
        while index < self.count {
            let end = Swift.min(index + size, self.count)
            result.append(Array(self[index..<end]))
            if end == self.count { break }
            index = end - overlap
        }
        
        return result
    }
}
