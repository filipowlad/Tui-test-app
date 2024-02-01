//
//  AddNewRouteView.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import API
import Components
import MapKit
import SwiftUI

public struct AddNewRouteView<
    ProgressStyle: ProgressViewStyle,
    Localizer: AddNewRouteLocalizing,
    Connections: ConnectionsService,
    Storage: StorageService
>: View {
    public typealias ViewModel = AddNewRouteViewModel<Localizer, Connections, Storage>
    typealias ViewState = ViewModel.ViewState
    
    // MARK: - Dependencies
    
    @ObservedObject private var viewModel: ViewModel
    private var state: ViewState { viewModel.state }
    
    private var styler: Styler<ProgressStyle>
    
    // MARK: - Properties
    
    @FocusState private var focusedLocationPicker: FocusedLocationPicker?
    @State private var airplaneCoordinates: CLLocationCoordinate2D = .init()
    
    public init(
        viewModel: ViewModel,
        styler: Styler<ProgressStyle>
    ) {
        self.viewModel = viewModel
        self.styler = styler
    }
    
    public var body: some View {
        ZStack {
            map
            content
            
            if state.fetchState == .loading {
                loader
            }
        }
        .task {
            await viewModel.initialFetch()
        }
        .onChange(of: focusedLocationPicker, onFocusedLocationPickerChanged)
        .onChange(of: state.fetchState, onFetchStateChanged)
        .animation(.easeInOut, value: state.fetchState)
        .animation(.easeInOut, value: state.routeItem)
    }
}

// MARK: - Models

public extension AddNewRouteView {
    struct Styler<LoaderStyle: ProgressViewStyle> {
        let contentSpacing: CGFloat
        let contentPadding: EdgeInsets
        let locationItems: SelectLocationItem.Styler
        let map: MapComponent.Styler
        let routeInformation: RouteInformationItem.Styler
        let saveButton: ButtonStyler
        let loader: Loader<LoaderStyle>
        
        public init(
            contentSpacing: CGFloat = 16,
            contentPadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            locationItems: SelectLocationItem.Styler = .init(),
            map: MapComponent.Styler = .init(),
            routeInformation: RouteInformationItem.Styler = .init(),
            saveButton: ButtonStyler = .defaultStyler,
            loader: Loader<LoaderStyle>
        ) {
            self.contentSpacing = contentSpacing
            self.contentPadding = contentPadding
            self.locationItems = locationItems
            self.map = map
            self.routeInformation = routeInformation
            self.saveButton = saveButton
            self.loader = loader
        }
    }
}

public extension AddNewRouteView {
    struct Loader<Style: ProgressViewStyle> {
        let text: TextStyler
        let style: Style
        
        public init(
            text: TextStyler = .init(),
            style: Style
        ) {
            self.text = text
            self.style = style
        }
    }
}

private extension AddNewRouteView {
    enum FocusedLocationPicker {
        case start, destination
    }
}

// MARK: - Views

private extension AddNewRouteView {
    @ViewBuilder
    var content: some View {
        VStack(spacing: styler.contentSpacing) {
            if state.fetchState == .success {
                startLocation
                destinationLocation
            }
            
            Spacer()
            
            if let route = state.routeItem {
                routeInformation(for: route)
                saveButton
            }
        }
        .padding(styler.contentPadding)
    }
    
    var startLocation: some View {
        locationPicker(
            text: .init(
                get: { state.startLocationText },
                set: viewModel.updateStartLocationText
            ),
            selectedLocationId: .init(
                get: { state.startLocation?.id },
                set: viewModel.updateStartLocation
            ),
            prompt: state.localizer.startLocationPrompt,
            locations: state.startLocations,
            errorOccured: state.startLocationErrorOccured
        )
        .focused($focusedLocationPicker, equals: .start)
    }
    
    var destinationLocation: some View {
        locationPicker(
            text: .init(
                get: { state.destinationLocationText },
                set: viewModel.updateDestinationLocationText
            ),
            selectedLocationId: .init(
                get: { state.destinationLocation?.id },
                set: viewModel.updateDestinationLocation
            ),
            prompt: state.localizer.destinationLocationPrompt,
            locations: state.destinationLocations,
            errorOccured: state.destinationLocationErrorOccured
        )
        .focused($focusedLocationPicker, equals: .destination)
    }
    
    var map: some View {
        MapComponent(
            position: $viewModel.state.mapData.mapCameraPosition,
            model: .init(
                route: state.routeItem.flatMap { routeItem in
                    .init(
                        locations: routeItem.route.locations.map { location in
                            .init(
                                title: location.title,
                                coordinates: location.coordinates.cllocationCoordinates
                            )
                        }
                    )
                }
            ),
            styler: styler.map
        )
    }
    
    func routeInformation(for routeItem: ViewState.RouteItem) -> some View {
        RouteInformationItem(
            model: .init(
                startLocationTitle: routeItem.route.startLocation.title,
                destinationLocationTitle: routeItem.route.destinationLocationItem.title,
                locationTitles: routeItem.route.passThroughLocations.map(\.title),
                priceText: routeItem.priceText,
                numberOfStopsTitle: routeItem.stopsTitle,
                passThroughLocationsTitle: routeItem.goesThroughTitle,
                locationsDisplayMode: .list
            ),
            styler: styler.routeInformation
        )
        .transition(.opacity)
    }
    
    var saveButton: some View {
        Button {
            viewModel.saveRoute()
        } label: {
            Text(state.localizer.saveButton)
                .bold()
                .frame(maxWidth: .greatestFiniteMagnitude)
                .padding(styler.saveButton.contentPadding)
        }
        .foregroundStyle(styler.saveButton.tint)
        .background(styler.saveButton.background)
        .strokeWithRoundedCorners(borderStyler: .init())
        .transition(.opacity)
    }
    
    var loader: some View {
        ProgressView {
            Text(state.localizer.loader)
                .font(styler.loader.text.font)
                .foregroundStyle(styler.loader.text.tint)
        }
        .progressViewStyle(styler.loader.style)
    }
}

// MARK: - Location

private extension AddNewRouteView {
    func locationPicker(
        text: Binding<String>,
        selectedLocationId: Binding<UUID?>,
        prompt: String,
        locations: [ViewState.LocationItem],
        errorOccured: Bool
    ) -> some View {
        SelectLocationItem(
            text: text,
            selectedLocationId: selectedLocationId,
            model: .init(
                prompt: prompt,
                locations: locations.map { locationItem in
                        .init(
                            id: locationItem.id,
                            title: locationItem.location.title
                        )
                    }, 
                errorOccurred: errorOccured
            ),
            styler: styler.locationItems
        )
        .transition(.opacity)
    }
}

// MARK: - `onChange` handling

private extension AddNewRouteView {
    func onFetchStateChanged(oldState: ViewState.FetchState, newState: ViewState.FetchState) {
        if newState == .success {
            focusedLocationPicker = .start
        }
    }
    
    func onFocusedLocationPickerChanged(oldState: FocusedLocationPicker?, newState: FocusedLocationPicker?) {
        if oldState == .start && newState != .destination {
            focusedLocationPicker = state.destinationLocation == nil ? .destination : nil
        }
        
        if oldState == .destination && newState != .start {
            focusedLocationPicker = state.startLocation == nil ? .start : nil
        }
        
        viewModel.updateStartLocationError(
            with: newState == .start ? false : oldState == .start
        )
        
        viewModel.updateDestinationLocationError(
            with: newState == .destination ? false : oldState == .destination
        )
    }
}
