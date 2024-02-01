//
//  SelectLocationItem.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import SwiftUI

public struct SelectLocationItem: View {
    // MARK: - Dependencies
    
    @Binding private var text: String
    @Binding private var selectedLocationId: UUID?
    private var model: Model
    private var styler: Styler
    
    // MARK: - Properties
    
    @FocusState private var textFieldIsFocused
    
    public init(
        text: Binding<String>,
        selectedLocationId: Binding<UUID?>,
        model: Model,
        styler: Styler
    ) {
        self._text = text
        self._selectedLocationId = selectedLocationId
        self.model = model
        self.styler = styler
    }
    
    public var body: some View {
        content
            .onChange(of: textFieldIsFocused) { _, newState in
                if newState == false, text == model.locations.first?.title {
                    selectedLocationId = model.locations.first?.id
                }
            }
    }
}

// MARK: - Models

public extension SelectLocationItem {
    struct Model {
        let prompt: String
        let locations: [Location]
        let errorOccurred: Bool
        
        public init(
            prompt: String,
            locations: [Location],
            errorOccurred: Bool
        ) {
            self.prompt = prompt
            self.locations = locations
            self.errorOccurred = errorOccurred
        }
    }
}

public extension SelectLocationItem.Model {
    struct Location: Identifiable {
        public let id: UUID
        let title: String
        
        public init(id: UUID, title: String) {
            self.id = id
            self.title = title
        }
    }
}

public extension SelectLocationItem {
    struct Styler {
        let contentSpacing: CGFloat
        let contentPadding: EdgeInsets
        let defaultBorder: BorderStyler
        let errorBorder: BorderStyler
        let prompt: TextStyler
        let textField: TextStyler
        let textFieldAutocomplete: TextStyler
        let location: TextStyler
        
        public init(
            contentSpacing: CGFloat = 4,
            contentPadding: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            defaultBorder: BorderStyler = .init(),
            errorBorder: BorderStyler = .init(color: .red),
            prompt: TextStyler = .init(font: .caption),
            textField: TextStyler = .init(),
            textFieldAutocomplete: TextStyler = .init(tint: .gray),
            location: TextStyler = .init()
        ) {
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.defaultBorder = defaultBorder
            self.errorBorder = errorBorder
            self.prompt = prompt
            self.textField = textField
            self.textFieldAutocomplete = textFieldAutocomplete
            self.location = location
        }
    }
}

private extension SelectLocationItem {
    var content: some View {
        VStack(spacing: styler.contentSpacing) {
            prompt
            textField
            list
        }
        .padding(styler.contentPadding)
        .background(.regularMaterial)
        .strokeWithRoundedCorners(
            borderStyler: model.errorOccurred ? styler.errorBorder : styler.defaultBorder
        )
    }
    
    var prompt: some View {
        HStack {
            Text(model.prompt)
                .bold()
                .font(styler.prompt.font)
                .foregroundStyle(styler.prompt.tint)
            Spacer()
        }
    }
    
    @ViewBuilder
    var textField: some View {
        ZStack {
            if let firstLocation = model.locations.first, textFieldIsFocused {
                HStack {
                    Text(firstLocation.title)
                        .font(styler.textFieldAutocomplete.font)
                        .foregroundStyle(styler.textFieldAutocomplete.tint)
                    Spacer()
                }
            }
            
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .font(styler.textField.font)
                .foregroundStyle(styler.textField.tint)
                .onSubmit {
                    if let firstLocation = model.locations.first {
                        text = firstLocation.title
                        selectedLocationId = firstLocation.id
                    }
                }
                .focused($textFieldIsFocused)
        }
    }
    
    @ViewBuilder
    var list: some View {
        if textFieldIsFocused {
            Group {
                ForEach(model.locations, content: locationItem)
            }
        }
    }
}

// MARK: - Utilities

private extension SelectLocationItem {
    func locationItem(_ locationItem: Model.Location) -> some View {
        VStack {
            Divider()
            HStack {
                Text(locationItem.title)
                    .font(styler.location.font)
                    .foregroundStyle(styler.location.tint)
                Spacer()
            }
        }
        .clipShape(Rectangle())
        .onTapGesture {
            selectedLocationId = locationItem.id
            textFieldIsFocused = false
        }
    }
}
