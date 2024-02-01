//
//  RoundedCorner.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import SwiftUI

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    init(
        radius: CGFloat,
        corners: UIRectCorner = .allCorners
    ) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        return Path(path.cgPath)
    }
}

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    @ViewBuilder
    func strokeWithRoundedCorners(
        borderStyler: BorderStyler?
    ) -> some View {
        if let borderStyler {
            let shape = RoundedCorner(radius: borderStyler.radius, corners: borderStyler.corners)
            clipShape(shape)
                .overlay {
                    shape
                        .stroke(borderStyler.color, style: borderStyler.style)
                }
        } else { self }
    }
}
