//
//  TextStyler.swift
//
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import SwiftUI

public struct TextStyler {
    public let font: Font
    public let tint: Color
    
    public init(
        font: Font = .headline,
        tint: Color = .black
    ) {
        self.font = font
        self.tint = tint
    }
}
