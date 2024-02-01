//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import SwiftUI

public struct ButtonStyler {
    public let tint: Color
    public let background: Color
    public let border: BorderStyler?
    public let contentPadding: EdgeInsets
    
    public init(
        tint: Color = .white,
        background: Color = .red,
        border: BorderStyler? = nil,
        contentPadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) {
        self.tint = tint
        self.background = background
        self.border = border
        self.contentPadding = contentPadding
    }
}

public extension ButtonStyler {
    static var defaultStyler: Self {
        .init(border: .init())
    }
}
