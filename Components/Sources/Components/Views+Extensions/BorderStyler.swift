//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import SwiftUI

public struct BorderStyler {
    public let color: Color
    public let style: StrokeStyle
    public let radius: CGFloat
    public let corners: UIRectCorner
    
    public init(
        color: Color = .black,
        style: StrokeStyle = .init(lineWidth: 2),
        radius: CGFloat = 6,
        corners: UIRectCorner = .allCorners
    ) {
        self.color = color
        self.style = style
        self.radius = radius
        self.corners = corners
    }
}
