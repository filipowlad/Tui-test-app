//
//  AddNewRouteItem.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import SwiftUI

public struct AddNewRouteItem: View {
    private let model: Model
    private let styler: Styler
    
    public init(
        model: Model,
        styler: Styler
    ) {
        self.model = model
        self.styler = styler
    }
    
    public var body: some View {
        content
            .background(.regularMaterial)
            .strokeWithRoundedCorners(borderStyler: styler.border)
    }
}

// MARK: - Models

public extension AddNewRouteItem {
    struct Model: Hashable {
        let title: String
        
        public init(title: String) {
            self.title = title
        }
    }
}

public extension AddNewRouteItem {
    struct Styler {
        let contentSpacing: CGFloat
        let contentPadding: EdgeInsets
        let border: BorderStyler
        let icon: IconStyler
        let title: TextStyler
        
        public init(
            contentSpacing: CGFloat = 8,
            contentPadding: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            border: BorderStyler = .init(),
            icon: IconStyler = .init(
                image: .init(systemName: "plus"),
                size: .init(width: 15, height: 15),
                tint: .black
            ),
            title: TextStyler = .init()
        ) {
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.border = border
            self.icon = icon
            self.title = title
        }
    }
}

// MARK: - Views

private extension AddNewRouteItem {
    var content: some View {
        HStack(spacing: styler.contentSpacing) {
            icon
            title
            Color.clear
        }
        .contentShape(Rectangle())
        .padding(styler.contentPadding)
    }
    
    var icon: some View {
        styler.icon.image
            .resizable()
            .frame(
                width: styler.icon.size.width,
                height: styler.icon.size.height
            )
            .foregroundStyle(styler.icon.tint)
    }
    
    var title: some View {
        Text(model.title)
            .multilineTextAlignment(.leading)
            .font(styler.title.font)
            .foregroundStyle(styler.title.tint)
    }
}

#Preview {
    AddNewRouteItem(model: .init(title: "Add new route"), styler: .init())
}
