//
//  IconStyler.swift
//  
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import SwiftUI

public struct IconStyler {
    public let image: Image
    public let size: CGSize
    public let tint: Color
    
    public init(
        image: Image,
        size: CGSize,
        tint: Color
    ) {
        self.image = image
        self.size = size
        self.tint = tint
    }
}
