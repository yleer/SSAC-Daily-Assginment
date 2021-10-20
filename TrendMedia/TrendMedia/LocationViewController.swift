//
//  LocationViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/20.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    var mapAnnotations: [TheaterLocation] = [
        TheaterLocation(type: "롯데시네마", location: "롯데시네마 서울대입구", latitude: 37.4824761978647, longitude: 126.9521680487202),
        TheaterLocation(type: "롯데시네마", location: "롯데시네마 가산디지털", latitude: 37.47947929602294, longitude: 126.88891083192269),
        TheaterLocation(type: "메가박스", location: "메가박스 이수", latitude: 37.48581351541419, longitude:  126.98092132899579),
        TheaterLocation(type: "메가박스", location: "메가박스 강남", latitude: 37.49948523972615, longitude: 127.02570417165666),
        TheaterLocation(type: "CGV", location: "CGV 영등포", latitude: 37.52666023337906, longitude: 126.9258351013706),
        TheaterLocation(type: "CGV", location: "CGV 용산 아이파크몰", latitude: 37.53149302830903, longitude: 126.9654030486416)
    ]
    var annotationsArray : [MKAnnotation] = []
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        createAnnotations()
        
        setCurrentLocationAsDefault()
    }
    
    func setCurrentLocationAsDefault(){
        if locationManager.authorizationStatus ==  .denied || locationManager.authorizationStatus == .restricted{
            let coordinate = CLLocationCoordinate2D(latitude: 37.565245215354295, longitude: 126.97714200196343)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let defaultRegion = MKCoordinateRegion(center: coordinate, span: span)
            let clLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            getCurrentAddress(location: clLoc)
            mapView.setRegion(defaultRegion, animated: true)
        }
    }
    func getCurrentAddress(location : CLLocation) {
        let geoCoder = CLGeocoder()

        let locale = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placMarker, error in
            guard error == nil, let place = placMarker?.first else{
                print("불가능")
                return
            }
            
            if let administrativeArea = place.administrativeArea, let loca = place.locality{
                self.navigationItem.title = administrativeArea + "  " + loca
            }
        }
    }
    func createAnnotations(){
        for item in mapAnnotations{
            let annotation = MKPointAnnotation()
            let clLocation = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            annotation.title = item.type
            annotation.coordinate = clLocation
            mapView.addAnnotation(annotation)
            annotationsArray.append(annotation)
        }
    }
    func filterAnnotations(_ name: String) {
        mapView.removeAnnotations(annotationsArray)
        if name == "전체"{
            for annot in annotationsArray{
                mapView.addAnnotation(annot)
                
            }
        }else{
            for annot in annotationsArray{
                if annot.title!! == name{
                    mapView.addAnnotation(annot)
                }
            }
        }
        
    }
    @IBAction func filterTheater(_ sender: UIBarButtonItem) {
        let vc = UIAlertController(title: "원하는 영화관을 선택해주세요.", message: "CGV, 메가박스, 롯데시네마, 전체중에서 골라주세요", preferredStyle: .actionSheet)
        let CGVAction = UIAlertAction(title: "CGV", style: .default) { uiAlertAction in
            self.filterAnnotations(uiAlertAction.title!)
        }
        let megaboxAction = UIAlertAction(title: "메가박스", style: .default) { uiAlertAction in
            self.filterAnnotations(uiAlertAction.title!)
        }
        let lotteAction = UIAlertAction(title: "롯데시네마", style: .default) { uiAlertAction in
            self.filterAnnotations(uiAlertAction.title!)
        }
        let allAction = UIAlertAction(title: "전체", style: .default) { uiAlertAction in
            self.filterAnnotations(uiAlertAction.title!)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        vc.addAction(CGVAction)
        vc.addAction(megaboxAction)
        vc.addAction(lotteAction)
        vc.addAction(allAction)
        vc.addAction(cancelAction)
        
        
        present(vc, animated: true, completion: nil)
    }
}



// MARK: mapView 관련 delegate.
extension LocationViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mark selected")
    }
}

extension LocationViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate{
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            let clLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            getCurrentAddress(location: clLoc)
            mapView.setRegion(region, animated: true)
        }else{
            print("not good")
        }
        
    }
    
    // Error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error : getting location from user.")
        
    }
    // called when auth changed.
    // 14 이후
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkCLAuthStatus()
    }
    // 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkCLAuthStatus()
    }
    
    func checkCLAuthStatus(){
        let authStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *){
            authStatus = locationManager.authorizationStatus // IOS 14이상 가능
        }else{
            authStatus = CLLocationManager.authorizationStatus() // IOS 14이상 미만
        }
        if CLLocationManager.locationServicesEnabled(){
            checkCurrentLocationAuth(authStatus)
        }else{
            print("Location service blocked. Go to setting and enable it.")
        }
    }
    
    func checkCurrentLocationAuth(_ status : CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
        case .restricted, .denied:
            print("denied , 설정으로 유도")
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            print("always")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("default")
        }
    }
}



