//
//  LocationService.swift
//  StudyBuddy
//
//  Created by Ina Song on 14/5/2026.
//

import CoreLocation

/// Provides user location updates via CoreLocation
protocol LocationServiceProtocol: AnyObject {
    var onLocationUpdate: ((CLLocation) -> Void)? { get set }
    var onLocationError: ((Error) -> Void)? { get set }
    var onAuthorizationDenied: (() -> Void)? { get set }
    func start()
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    var onAuthorizationDenied: (() -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onLocationUpdate?(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            onAuthorizationDenied?()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
