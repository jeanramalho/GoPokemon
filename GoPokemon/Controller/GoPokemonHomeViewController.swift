//
//  GoPokemonHomeViewController.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 21/03/25.
//
import Foundation
import UIKit
import MapKit

class GoPokemonHomeViewController: UIViewController {
    
    let contentView: GoPokemonHomeView = GoPokemonHomeView()
    var locationManager = CLLocationManager()
    var contador = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        setupContentView()
        setupLocationManager()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        let updateLocationButton = contentView.updateLocationButton
        updateLocationButton.addTarget(self, action: #selector(centerPlayer), for: .touchUpInside)
    }
    
    private func setHierarchy(){
        view.addSubview(contentView)
    }
    
    private func setConstraints(){
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func centerMapLocation(){
        let mapa = self.contentView.mapView
        
        //Maneira menos verbosa e mais rapida de centralizar localização de usuário no mapa
        if let userCoordinates = self.locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userCoordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(region, animated: true)
        }
        
    }
    
    @objc private func centerPlayer(){
        centerMapLocation()
    }
    
    
}

extension GoPokemonHomeViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    private func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let map = contentView.mapView
        map.showsUserLocation = true
        
        
        if contador < 3 {
            centerMapLocation()
            contador += 1
        
        } else {
            locationManager.stopUpdatingLocation()
        }
        
        
    }
    
    // Metodo novo
    // Método chamado sempre que o status de permissão muda
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let status = manager.authorizationStatus
        
        // Verifica se a permissão não foi concedida
        guard status == .authorizedWhenInUse || status == .notDetermined else {
            showLocationPermissionAlert()
            return
        }
    }
    
    // Exibe um alerta pedindo para o usuário ativar a localização
    private func showLocationPermissionAlert() {
        let title = "Permissão de Localização"
        let message = "Para que você possa caçar Pokémons, habilite sua localização!"

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Botão que leva às configurações do app
        let settingsAction = UIAlertAction(title: "Abrir Configurações", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }

        // Botão de cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        // Apresenta o alerta na ViewController associada
        present(alertController, animated: true)
    }
    
   

}
