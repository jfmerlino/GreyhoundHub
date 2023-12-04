import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct CustomAnnotation: Identifiable {
    var id: UUID
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.3477, longitude: -76.6172),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Binding private var dropOffPoint: String
    @Binding private var dropOffLat: Double
    @Binding private var dropOffLong: Double
    @State private var dropCoordinate: CLLocationCoordinate2D?

    // Expose the annotation using a computed property
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
                .ignoresSafeArea()
                .gesture(DragGesture())
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
                        Text("Estimated wait [TIME]")
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
            locationManager.requestLocation()
            // Set the drop coordinate here based on your logic or pass it in from the outside
            dropCoordinate = CLLocationCoordinate2D(latitude: dropOffLat, longitude: dropOffLong)

            // Add dropCoordinate to the annotations array
            annotations.append(CustomAnnotation(id: UUID(), coordinate: dropCoordinate!))
        }
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


/*
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
*/
