//
//  RouteView.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import API
import Components
import SwiftUI

public struct RouteView<
    Localizer: RouteLocalizing,
    Storage: StorageService
>: View {
    public typealias ViewModel = RouteViewModel<Localizer, Storage>
    typealias ViewState = ViewModel.ViewState
    
    @ObservedObject private var viewModel: ViewModel
    private var state: ViewState { viewModel.state }
    
    private let styler: Styler
    
    public init(
        viewModel: ViewModel,
        styler: Styler = .init()
    ) {
        self.viewModel = viewModel
        self.styler = styler
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            map
            content
        }
    }
}

// MARK: - Models

public extension RouteView {
    struct Styler {
        let contentSpacing: CGFloat
        let contentPadding: EdgeInsets
        let mapComponent: MapComponent.Styler
        let routeInformationItem: RouteInformationItem.Styler
        let button: ButtonStyler
        
        public init(
            contentSpacing: CGFloat = 16,
            contentPadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            mapComponent: MapComponent.Styler = .init(),
            routeInformationItem: RouteInformationItem.Styler = .init(),
            button: ButtonStyler = .defaultStyler
        ) {
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.mapComponent = mapComponent
            self.routeInformationItem = routeInformationItem
            self.button = button
        }
    }
}

// MARK: - Views

private extension RouteView {
    var content: some View {
        VStack(spacing: styler.contentSpacing) {
            routeInformation
            deleteButton
        }
        .padding(styler.contentPadding)
    }
    
    var map: some View {
        MapComponent(
            position: .init(
                get: { state.mapData.mapCameraPosition },
                set: viewModel.updateMapCameraPosition
            ),
            model: .init(
                route: .init(
                    locations: state.route.locations.map { location in
                        .init(
                            title: location.title,
                            coordinates: location.coordinates.cllocationCoordinates
                        )
                    }
                )
            ),
            styler: styler.mapComponent
        )
    }
    
    var routeInformation: some View {
        RouteInformationItem(
            model: .init(
                startLocationTitle: state.route.startLocation.title,
                destinationLocationTitle: state.route.destinationLocation.title,
                locationTitles: state.route.passThroughLocations.map(\.title),
                priceText: state.priceText, 
                numberOfStopsTitle: state.stopsTitle,
                passThroughLocationsTitle: state.goesThroughTitle,
                locationsDisplayMode: .list
            ),
            styler: styler.routeInformationItem
        )
    }
    
    var deleteButton: some View {
        Button {
            viewModel.deleteRoute()
        } label: {
            Text(state.deleteButtonTitle)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .padding(styler.button.contentPadding)
        }
        .foregroundStyle(styler.button.tint)
        .background(styler.button.background)
        .strokeWithRoundedCorners(borderStyler: styler.button.border)
    }
}
