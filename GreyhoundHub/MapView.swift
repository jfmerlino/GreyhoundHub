import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct CustomAnnotation: Identifiable {
    var id: UUID
    let coordinate: CLLocationCoordinate2D
}

struct Polyline: View {
    var coordinates: [CLLocationCoordinate2D]
    var strokeColor: Color
    var lineWidth: CGFloat

    var body: some View {
        Path { path in
            for coordinate in coordinates {
                let point = MKMapPoint(coordinate)
                if path.isEmpty {
                    path.move(to: CGPoint(x: point.x, y: point.y))
                } else {
                    path.addLine(to: CGPoint(x: point.x, y: point.y))
                }
            }
        }
        .stroke(strokeColor, lineWidth: lineWidth)
    }
}

struct MapView: View {
    @State private var polylineCoordinates: [CLLocationCoordinate2D] = []
    @StateObject var locationManager = LocationManager()
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.3477, longitude: -76.6172),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State var testMarker = CustomAnnotation(id: UUID(), coordinate: CLLocationCoordinate2D(latitude: 39.34652606069628, longitude: -76.62186017151022))
    @Binding var dropOffPoint: [String]
    @State var drop: String?
    @State var dropOffLat: Double
    @State var dropOffLong: Double
    @State var dropCoordinate: CLLocationCoordinate2D?
    @State private var formattedTravelTime: String = ""

    @State private var annotations: [CustomAnnotation] = []
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: annotations) { annotation in
                                MapAnnotation(coordinate: annotation.coordinate) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 40)
                                        .foregroundColor(.red)
                                }
                            }
                            .overlay(
                                // Display the Polyline for the route
                                Polyline(
                                    coordinates: polylineCoordinates,
                                    strokeColor: .blue,
                                    lineWidth: 3
                                )
                            )
                            .ignoresSafeArea()
                            .gesture(DragGesture())
                        }
            else {
                ProgressView()
                    .scaleEffect(1.74)
                    .tint(.green)
            }
            VStack {
                HStack {
                    Text("**GreyhoundGrub**")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                }
                VStack {
                    if let location = locationManager.location {
                        Spacer()
                        Text("Head to \(dropOffPoint[-2])")
                            .font(.headline)
                        Text("**[PERSON]**")
                        Text("is delivering your food from [LOCATION]")
                        Spacer()
                        Spacer()
                    }
                }
                .foregroundColor(.green)
                .tint(.green)
                Spacer()
            }
        }
        .onAppear {
            drop = dropOffPoint[-2]
            if let drop = drop, let location = locations[drop] {
                let dropLocation = location
                // Now `dropLocation` contains the corresponding `CLLocationCoordinate2D` value for the given `dropCoordinate`
                print("Drop Location: \(dropLocation.latitude), \(dropLocation.longitude)")
                
                // Perform initial setup and route calculation
                locationManager.requestLocation()
                //dropCoordinate = CLLocationCoordinate2D(latitude: dropOffLat, longitude: dropOffLong)
                @State var dropDestination = CustomAnnotation(id: UUID(), coordinate: dropLocation)
                annotations.append(dropDestination)
                //annotations.append(CustomAnnotation(id: UUID(), coordinate: dropCoordinate!))
                getDirections()
            } else {
                print("Drop Coordinate not found in the locations dictionary.")
            }
        }
    }
    func getDirections() {
        guard let userLocation = locationManager.location, let dropCoordinate = dropCoordinate else {
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dropCoordinate))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else {
                print("No route found")
                return
            }

            // Display the estimated travel time in your SwiftUI view
            let estimatedTimeInSeconds = Int(route.expectedTravelTime)

            DispatchQueue.main.async {
                if estimatedTimeInSeconds > 0 {
                    let estimatedTimeFormatted = format(seconds: estimatedTimeInSeconds)
                    self.formattedTravelTime = estimatedTimeFormatted
                    print("Estimated travel time: \(estimatedTimeFormatted)")
                } else {
                    self.formattedTravelTime = "Not available"
                    print("Estimated travel time not available")
                }
            }

            // Set the region to fit the route
            let routeRegion = MKCoordinateRegion(route.polyline.boundingMapRect)
            self.region = routeRegion

            // Convert MKMapPoint to CLLocationCoordinate2D
            var coordinates: [CLLocationCoordinate2D] = []
            let pointCount = route.polyline.pointCount
            let pointsPointer = route.polyline.points()
            for i in 0..<pointCount {
                let coordinate = pointsPointer[i].coordinate
                coordinates.append(coordinate)
            }

            // Update the coordinates for the Polyline
            DispatchQueue.main.async {
                self.polylineCoordinates = coordinates
            }
            
            // Add the route to the map
             DispatchQueue.main.async {
                 self.annotations.removeAll() // Remove previous annotations
                 self.annotations.append(CustomAnnotation(id: UUID(), coordinate: userLocation))
                 self.annotations.append(CustomAnnotation(id: UUID(), coordinate: dropCoordinate))
                 self.annotations.append(contentsOf: route.steps.map { CustomAnnotation(id: UUID(), coordinate: $0.polyline.coordinate) })
             }


            // Print information about route steps
            for step in route.steps {
                print("Step: \(step.instructions), Distance: \(step.distance) meters")
            }
        }
    }



    
    // Helper function to format seconds into a readable time format
    func format(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: TimeInterval(seconds)) ?? ""
    }
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion?

    override init() {
        super.init()
        manager.delegate = self
        requestLocation()
        
        // For Preview Testing Comment This Out
        location = CLLocationCoordinate2D(latitude: 39.3477, longitude: -76.6172)
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        self.location = location
        self.region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

let locations: [String: CLLocationCoordinate2D] = [
        "Newman Towers": CLLocationCoordinate2D(latitude: 39.3454939264922, longitude: -76.62551290095425),
        "Avila Hall": CLLocationCoordinate2D(latitude: 39.346022546211046, longitude: -76.62547085960993),
        "Bellarmine Hall": CLLocationCoordinate2D(latitude: 39.34598281949305, longitude: -76.62499540568633),
        "Claver Hall": CLLocationCoordinate2D(latitude: 39.34635317836477, longitude: -76.62447684134848),
        "Dorothy Day Hall": CLLocationCoordinate2D(latitude: 39.34669792224484, longitude: -76.62437734798173),
        "Campion Tower": CLLocationCoordinate2D(latitude: 39.34596393764277, longitude: -76.62388898300387),
        "Lange Court": CLLocationCoordinate2D(latitude: 39.347495643334526, longitude: -76.62310068580624),
        "Hopkins Court": CLLocationCoordinate2D(latitude: 39.34675284710802, longitude: -76.62298807192086),
        "Knott Hall": CLLocationCoordinate2D(latitude: 39.34652606069628, longitude: -76.62186017151022),
        "Donnelly Science Center": CLLocationCoordinate2D(latitude: 39.34588124657631, longitude: -76.62111607001285),
        "Sellinger School of Business": CLLocationCoordinate2D(latitude: 39.34653422286221, longitude: -76.62108440611934),
        "Maryland Hall": CLLocationCoordinate2D(latitude: 39.34665257416089, longitude: -76.62031919535961),
        "Fernandez Center": CLLocationCoordinate2D(latitude: 39.34602408565758, longitude: -76.62041418706988),
        "Humanities": CLLocationCoordinate2D(latitude: 39.34648548042209, longitude: -76.61937371835),
        "Hammerman Hall": CLLocationCoordinate2D(latitude: 39.34854006122023, longitude: -76.61714974117571),
        "Butler Hall": CLLocationCoordinate2D(latitude: 39.34870349215041, longitude: -76.61626594922791),
        "Thea Bowman Hall": CLLocationCoordinate2D(latitude: 39.349317592849175, longitude: -76.61646448222753),
        "Loyola Notre Dame Library": CLLocationCoordinate2D(latitude: 39.34954017282285, longitude: -76.61684146883034),
        "Ahern Hall": CLLocationCoordinate2D(latitude: 39.35021235730865, longitude: -76.61518382086436),
        "McAuley Hall": CLLocationCoordinate2D(latitude: 39.35105648681514, longitude: -76.61498166869016),
        "Rahner Village": CLLocationCoordinate2D(latitude: 39.35218057722377, longitude: -76.61146662131412),
        "Fitness and Aquatics Center": CLLocationCoordinate2D(latitude: 39.352403129029845, longitude: -76.62422975712187)]

