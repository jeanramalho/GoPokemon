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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        setupLocationManager()
        setHierarchy()
        setConstraints()
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
        guard let location = locations.last else {return}
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
    }
    
    
    // metodo antigo
//    // trata quando a autorização não é permitida
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        
//        let status = manager.authorizationStatus
//        
//        if status != .authorizedWhenInUse && status != .notDetermined {
//            
//            let title: String = "Permissão de localização"
//            let msg: String = "Para que você possa caçar Pokemons, habilite sua localização!"
//            
//            // notificação de alerta
//            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//            
//            // Botão de ação para abrir configurações
//            let actionTitle: String = "Abrir configurações"
//            
//            let configAction = UIAlertAction(title: actionTitle, style: .default) { configAlert in
//                
//                if let config = NSURL(string: UIApplicationOpenNotificationSettingsURLString) {
//                    UIApplication.shared.open(config as URL)
//                }
//            }
//            // acao do botoa cancelar
//            let cancellAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
//            
//            //adiciona botoes de acao ao alert
//            alertController.addAction(configAction)
//            alertController.addAction(cancellAction)
//            
//            //apresenta alerta
//            present(alertController, animated: true, completion: nil)
//            
//        }
//    }
    
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
