//
//  RoutesView.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import API
import Components
import SwiftUI

public struct RoutesView<
    Localizer: RoutesLocalizing,
    Storage: StorageService
>: View {
    public typealias ViewModel = RoutesViewModel<Localizer, Storage>
    typealias ViewState = ViewModel.ViewState
    
    // MARK: - Dependencies
    
    @ObservedObject private var viewModel: ViewModel
    private var state: ViewState { viewModel.state }
    private let styler: Styler
    
    // MARK: - Properties
    
    @State private var shouldShowElements: Bool = false
    
    public init(
        viewModel: ViewModel,
        styler: Styler
    ) {
        self.viewModel = viewModel
        self.styler = styler
    }
    
    public var body: some View {
        content
            .background(backgroundImage)
            .task {
                try? await Task.sleep(nanoseconds: 5_000_000)
                shouldShowElements = true
            }
            .animation(.easeInOut, value: shouldShowElements)
    }
}

// MARK: - Models

public extension RoutesView {
    struct Styler {
        let backgroundImage: Image
        let listContentPadding: EdgeInsets
        let routeInformationItem: RouteInformationItem.Styler
        let addNewRouteItem: AddNewRouteItem.Styler
        
        public init(
            backgroundImage: Image,
            listContentPadding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16),
            routeInformationItem: RouteInformationItem.Styler = .init(),
            addNewRouteItem: AddNewRouteItem.Styler = .init()
        ) {
            self.backgroundImage = backgroundImage
            self.listContentPadding = listContentPadding
            self.routeInformationItem = routeInformationItem
            self.addNewRouteItem = addNewRouteItem
        }
    }
}

// MARK: - Views

private extension RoutesView {
    @ViewBuilder
    var content: some View {
        ScrollView {
            LazyVStack {
                if shouldShowElements {
                    addNewRouteCell()
                    ForEach(state.routeItems, content: routeCell)
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: state.routeItems)
    }
    
    @ViewBuilder
    var backgroundImage: some View {
        styler.backgroundImage
            .resizable()
            .ignoresSafeArea()
    }
}

// MARK: - Cells

private extension RoutesView {
    func routeCell(for routeItem: ViewState.RouteItem) -> some View {
        RouteInformationItem(
            model: .init(
                startLocationTitle: routeItem.route.startLocation.title,
                destinationLocationTitle: routeItem.route.destinationLocation.title,
                locationTitles: routeItem.route.passThroughLocations.map(\.title),
                priceText: routeItem.priceText,
                numberOfStopsTitle: routeItem.stopsTitle,
                passThroughLocationsTitle: routeItem.goesThroughTitle,
                locationsDisplayMode: .toggledList
            ),
            styler: styler.routeInformationItem
        )
        .transition(.opacity.combined(with: .offset(.init(width: 0, height: -20))))
        .onTapGesture {
            viewModel.didTapShowRoute.send(routeItem)
        }
    }
    
    func addNewRouteCell() -> some View {
        AddNewRouteItem(
            model: .init(title: state.addNewRouteTitle),
            styler: styler.addNewRouteItem
        )
        .transition(.opacity.combined(with: .offset(.init(width: 0, height: -20))))
        .onTapGesture {
            viewModel.didTapShowAddNewRoute.send()
        }
    }
}
