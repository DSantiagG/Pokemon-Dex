//
//  Array+OverlapChunks.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import Foundation

extension Array {
    func overlappedChunks(size: Int, overlap: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        guard overlap < size else { return [] }
        
        var result: [[Element]] = []
        var index = 0
        
        while index < self.count {
            let end = Swift.min(index + size, self.count)
            result.append(Array(self[index..<end]))
            if end == self.count { break }
            index = end - 1
        }
        
        return result
    }
}
