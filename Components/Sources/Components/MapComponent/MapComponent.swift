//
//  MapComponent.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import Combine
import MapKit
import SwiftUI

public struct MapComponent: View {
    // MARK: - Dependencies
    
    @Binding private var position: MapCameraPosition
    private let model: Model
    private let styler: Styler
    
    // MARK: - Properties
    
    @State private var animationTrigger: UUID = .init()
    
    public init(
        position: Binding<MapCameraPosition>,
        model: Model,
        styler: Styler
    ) {
        self._position = position
        self.model = model
        self.styler = styler
    }
    
    public var body: some View {
        map
            .task {
                if model.route != nil {
                    try? await Task.sleep(nanoseconds: 5_000_000)
                    animationTrigger = .init()
                }
            }
    }
}

// MARK: - Models

public extension MapComponent {
    struct Model: Hashable {
        let route: Route?
        
        public init(route: Route?) {
            self.route = route
        }
    }
    
    struct Styler {
        let parameters: Parameters
        let mapLines: MapLines
        let mapAnnotation: IconStyler
        
        public init(
            parameters: Parameters = .init(),
            mapLines: MapLines = .init(),
            mapAnnotation: IconStyler = .init(
                image: .init(systemName: "mappin.circle"),
                size: .init(width: 30, height: 30),
                tint: .red
            )
        ) {
            self.parameters = parameters
            self.mapLines = mapLines
            self.mapAnnotation = mapAnnotation
        }
    }
}

public extension MapComponent.Model {
    struct Route: Hashable {
        let locations: [Location]
        
        public init(locations: [Location]) {
            self.locations = locations
        }
    }
    
    struct Location: Hashable {
        let title: String
        let coordinates: CLLocationCoordinate2D
        
        public init(
            title: String,
            coordinates: CLLocationCoordinate2D
        ) {
            self.title = title
            self.coordinates = coordinates
        }
        
        public static func == (lhs: MapComponent.Model.Location, rhs: MapComponent.Model.Location) -> Bool {
            lhs.title == rhs.title &&
            lhs.coordinates.latitude == rhs.coordinates.latitude &&
            lhs.coordinates.longitude == rhs.coordinates.longitude
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(title)
            hasher.combine(coordinates.latitude)
            hasher.combine(coordinates.longitude)
        }
    }
}

public extension MapComponent.Styler {
    struct Parameters {
        let animationDuration: TimeInterval
        let maxCameraDistance: Double
        
        public init(
            animationDuration: TimeInterval = 20,
            maxCameraDistance: Double = 8000000
        ) {
            self.animationDuration = animationDuration
            self.maxCameraDistance = maxCameraDistance
        }
    }
    
    struct MapLines {
        let color: Color
        let width: CGFloat
        
        public init(
            color: Color = .black,
            width: CGFloat = 2
        ) {
            self.color = color
            self.width = width
        }
    }
}

// MARK: - Views

private extension MapComponent {
    var map: some View {
        Map(
            position: $position,
            interactionModes: []
        ) {
            if let route = model.route {
                mapLines(for: route)
                mapLocationAnnotations(for: route)
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(edges: .all)
        .onChange(of: model.route) {
            animationTrigger = .init()
        }
        .mapCameraKeyframeAnimator(trigger: animationTrigger) { camera in
            let locationsCoordinates = model.route?.locations.map(\.coordinates) ?? []
            
            KeyframeTrack(\MapCamera.centerCoordinate) {
                let animationDuration = styler.parameters.animationDuration / Double(max(1, locationsCoordinates.count))
                for coordinates in locationsCoordinates {
                    LinearKeyframe(
                        coordinates,
                        duration: animationDuration,
                        timingCurve: .easeOut
                    )
                }
            }
            
            KeyframeTrack(\MapCamera.distance) {
                let animationDuration = styler.parameters.animationDuration / Double(locationsCoordinates.count + 1)
                for _ in locationsCoordinates {
                    CubicKeyframe(
                        styler.parameters.maxCameraDistance,
                        duration: animationDuration
                    )
                }
                CubicKeyframe(
                    camera.distance,
                    duration: animationDuration
                )
            }
        }
    }
}

// MARK: - Map content

private extension MapComponent {
    func mapLines(for route: Model.Route) -> some MapContent {
        MapPolyline(
            coordinates: route.locations
                .map(\.coordinates)
        )
        .stroke(styler.mapLines.color, lineWidth: styler.mapLines.width)
    }
    
    func mapLocationAnnotations(for route: Model.Route) -> some MapContent {
        ForEach(route.locations, id: \.self) { location in
            Annotation(coordinate: location.coordinates) {
                styler.mapAnnotation.image
                    .resizable()
                    .frame(
                        width: styler.mapAnnotation.size.width,
                        height: styler.mapAnnotation.size.height
                    )
                    .foregroundStyle(styler.mapAnnotation.tint)
            } label: {
                Text(location.title)
            }
        }
    }
}

// MARK: - Preview

private struct MapComponentPreviewView: View {
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        MapComponent(
            position: $mapCameraPosition,
            model: .init(route: nil), 
            styler: .init()
        )
    }
}

#Preview {
    MapComponentPreviewView()
}
