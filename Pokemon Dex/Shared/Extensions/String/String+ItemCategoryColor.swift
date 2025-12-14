//
//  String+ItemCategoryColor.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import SwiftUI
import CryptoKit

extension String {
    var categoryColor: Color {
        let digest = SHA256.hash(data: Data(self.utf8))
        let firstByte = digest.withUnsafeBytes { rawBuffer -> UInt8 in
            return rawBuffer.first ?? 0
        }
        let hash64 = UInt64(firstByte)

        let hueBands: [(Double, Double)] = [
            (350, 370), // red
            (20, 30),   // dark orange
            (30, 40),   // medium orange
            (300, 330), // pink
            (320, 335), // magenta
            (270, 290), // purple
            (200, 215), // deep blue
            (215, 230), // medium blue
            (230, 240), // slightly cooler blue
            (195, 205), // sky blue
            (120, 135), // medium green
            (135, 150), // cooler green
            (40, 50),   // amber / yellow-orange (dark)
            (55, 65),   // dark yellow (avoiding pure yellow)
            (20, 25),   // brown (warm)
        ]

        // Choose a band from the hash
        let bandIndex = Int(hash64 % UInt64(hueBands.count))
        let band = hueBands[bandIndex]

        // Within the band, shift the hue using another part of the hash
        let intra = Double((hash64 / 7) % 10) / 10.0 // 0.0, 0.1, ..., 0.9
        var hueDeg = band.0 + (band.1 - band.0) * intra
        if hueDeg >= 360 { hueDeg -= 360 }
        let hue = hueDeg / 360.0

        // Control saturation and brightness to avoid washed-out or garish colors
        // Increase saturation moderately, decrease brightness slightly
        let saturation = 0.65 + Double((hash64 / 97) % 10) * 0.01 // ~0.65–0.74
        let brightness = 0.72 + Double((hash64 / 193) % 10) * 0.005 // ~0.72–0.77

        return Color(hue: hue, saturation: min(max(saturation, 0.0), 1.0),
                     brightness: min(max(brightness, 0.0), 1.0))
    }
}
