//
//  RouteInformationItem.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import SwiftUI

public struct RouteInformationItem: View {
    // MARK: - Dependencies
    
    @State private var showLocations: Bool = false
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

public extension RouteInformationItem {
    struct Model {
        public enum LocationsDisplayMode {
            case list
            case toggledList
        }
        
        let startLocationTitle: String
        let destinationLocationTitle: String
        let locationTitles: [String]
        let priceText: String
        let numberOfStopsTitle: String
        let passThroughLocationsTitle: String
        let locationsDisplayMode: LocationsDisplayMode
        
        public init(
            startLocationTitle: String,
            destinationLocationTitle: String,
            locationTitles: [String],
            priceText: String,
            numberOfStopsTitle: String,
            passThroughLocationsTitle: String,
            locationsDisplayMode: LocationsDisplayMode
        ) {
            self.startLocationTitle = startLocationTitle
            self.destinationLocationTitle = destinationLocationTitle
            self.locationTitles = locationTitles
            self.priceText = priceText
            self.locationsDisplayMode = locationsDisplayMode
            self.numberOfStopsTitle = numberOfStopsTitle
            self.passThroughLocationsTitle = passThroughLocationsTitle
        }
    }
}

public extension RouteInformationItem {
    struct Styler {
        let border: BorderStyler
        let contentSpacing: CGFloat
        let contentPadding: EdgeInsets
        let icon: IconStyler
        let baseTitles: TextStyler
        let priceTitle: TextStyler
        let button: ButtonStyler
        let line: Line
        
        public init(
            border: BorderStyler = .init(),
            contentSpacing: CGFloat = 4,
            contentPadding: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8),
            icon: IconStyler = .init(
                image: .init(systemName: "airplane.circle"),
                size: .init(width: 20, height: 20),
                tint: .black
            ),
            baseTitles: TextStyler = .init(),
            priceTitle: TextStyler = .init(font: .title, tint: .black),
            button: ButtonStyler = .defaultStyler,
            line: Line = .init()
        ) {
            self.border = border
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.icon = icon
            self.baseTitles = baseTitles
            self.priceTitle = priceTitle
            self.button = button
            self.line = line
        }
    }
}

public extension RouteInformationItem.Styler {
    struct Line {
        let width: CGFloat
        let tint: Color
        let cornerRadius: CGFloat
        let corners: UIRectCorner
        
        public init(
            width: CGFloat = 2,
            tint: Color = .black,
            cornerRadius: CGFloat = 2,
            corners: UIRectCorner = .allCorners
        ) {
            self.width = width
            self.tint = tint
            self.cornerRadius = cornerRadius
            self.corners = corners
        }
    }
}

// MARK: - Views

private extension RouteInformationItem {
    @ViewBuilder
    var content: some View {
        VStack(spacing: styler.contentSpacing) {
            baseInfo
            numberOfStops
            additionalInfo
        }
        .padding(styler.contentPadding)
    }
    
    var baseInfo: some View {
        HStack {
            startPoint
            icon
            destinationPoint
        }
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
    
    var startPoint: some View {
        HStack {
            Text(model.startLocationTitle)
                .multilineTextAlignment(.leading)
                .font(styler.baseTitles.font)
                .foregroundStyle(styler.baseTitles.tint)
            line
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
    }
    
    var destinationPoint: some View {
        HStack {
            line
            Text(model.destinationLocationTitle)
                .multilineTextAlignment(.trailing)
                .font(styler.baseTitles.font)
                .foregroundStyle(styler.baseTitles.tint)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
    }
    
    var numberOfStops: some View {
        Text(model.numberOfStopsTitle)
            .font(styler.baseTitles.font)
            .foregroundStyle(styler.baseTitles.tint)
    }
    
    @ViewBuilder
    var additionalInfo: some View {
        switch model.locationsDisplayMode {
        case .list:
            additionalInfoWithList
        case .toggledList:
            additionalInfoWithToggledList
        }
    }
    
    var additionalInfoWithList: some View {
        VStack {
            HStack(alignment: .top) {
                if !model.locationTitles.isEmpty {
                    VStack {
                        HStack {
                            passthroughtLocationsTitle
                            Spacer()
                        }
                        list
                    }
                }
                
                Spacer()
                price
            }
            
            if showLocations {
                list
            }
        }
    }
    
    var additionalInfoWithToggledList: some View {
        VStack {
            HStack {
                if !model.locationTitles.isEmpty {
                    listButton
                }
                Spacer()
                price
            }
            
            if showLocations {
                list
            }
        }
    }
    
    var listButton: some View {
        Button {
            withAnimation(.easeInOut) { showLocations.toggle() }
        } label: {
            Text(model.passThroughLocationsTitle)
                .font(styler.baseTitles.font)
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        }
        .foregroundStyle(styler.button.tint)
        .background(styler.button.background)
        .strokeWithRoundedCorners(borderStyler: styler.button.border)
    }
    
    var passthroughtLocationsTitle: some View {
        Text(model.passThroughLocationsTitle)
            .font(styler.baseTitles.font)
            .foregroundStyle(styler.baseTitles.tint)
    }
    
    var price: some View {
        Text(model.priceText)
            .bold()
            .font(styler.priceTitle.font)
            .foregroundStyle(styler.priceTitle.tint)
    }
    
    var list: some View {
        Group {
            ForEach(model.locationTitles, id: \.self) { locationTitle in
                HStack {
                    Text(locationTitle)
                        .font(styler.baseTitles.font)
                        .foregroundStyle(styler.baseTitles.tint)
                    Spacer()
                }
                .transition(.opacity)
            }
        }
    }
    
    var line: some View {
        Rectangle()
            .frame(height: styler.line.width)
            .foregroundStyle(styler.line.tint)
            .cornerRadius(styler.line.cornerRadius, corners: styler.line.corners)
    }
}

#Preview {
    RouteInformationItem(
        model: .init(
            startLocationTitle: "Start location",
            destinationLocationTitle: "Destination location",
            locationTitles: ["First", "Second"],
            priceText: "800 $", 
            numberOfStopsTitle: "2 stops",
            passThroughLocationsTitle: "Goes through:",
            locationsDisplayMode: .toggledList
        ), 
        styler: .init()
    )
    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
}
