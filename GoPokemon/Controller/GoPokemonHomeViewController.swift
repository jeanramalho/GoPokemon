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
    var pokemons: [Pokemons] = []
    var coreDataPokemons = CoreDataManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.pokemons = coreDataPokemons.buscaPokemons()

        
        showPokemons()
        setupContentView()
        setupLocationManager()
        setHierarchy()
        setConstraints()
    }
    

    
    private func setupContentView(){
        let updateLocationButton = contentView.updateLocationButton
        updateLocationButton.addTarget(self, action: #selector(centerPlayer), for: .touchUpInside)
        
        contentView.pokeAgendaButton.addTarget(self, action: #selector(showPokeAgenda), for: .touchUpInside)
        
        self.contentView.mapView.delegate = self
    }
    
    private func showPokemons(){
        //Agenda uma repeticao de codigo por depois de um tempo determinado
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { Timer in
            
            if let coordenadas = self.locationManager.location?.coordinate {
                
                //Pega um pokemon aleatorio
                let allPokemons = UInt32(self.pokemons.count)
                let indexPokemonAleatorio = arc4random_uniform(allPokemons)
                let pokemon = self.pokemons[Int(indexPokemonAleatorio)]
                
                let annotation = PokemonAnnotation(coordenadas: coordenadas, pokemon: pokemon)
                
                // Gera valores aleatorios para serem adicionados a latitude e longitude do usuário e gerar uma anotacao proxima e aleatoria
                let latitudeAleatoria = ((Double(arc4random_uniform(300))) - 150) / 100000.0
                let longitudeAleatoria = ((Double(arc4random_uniform(300))) - 150) / 100000.0
                
        
                annotation.coordinate.latitude += latitudeAleatoria
                annotation.coordinate.longitude += longitudeAleatoria
                
                self.contentView.mapView.addAnnotation(annotation)
                
            }
        }
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
    
    @objc private func showPokeAgenda(){
        let pokeAgenda = PokeAgendaViewController()
        
        pokeAgenda.modalPresentationStyle = .pageSheet
        
        present(pokeAgenda, animated: true, completion: nil)
        
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
    
    //metodo chamado sempre que uma anotacao é chamada
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        anotacaoView.image = UIImage(named: "player")
        //Caso a anotacao seja a localizacao do usuario a imagem é do player caso nao é do pokemon
        if annotation is MKUserLocation {
            anotacaoView.image = UIImage(named: "player")
        } else {
            if let pokeAnnotation =  annotation as? PokemonAnnotation {
                let nomeImagemPokemon = pokeAnnotation.pokemon.nomeImagem ?? ""
                anotacaoView.image = UIImage(named: nomeImagemPokemon)
            }
            
        }
        
        var frame = anotacaoView.frame
        frame.size.width = 40
        frame.size.height = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let pokemon = (view.annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
            return
        }
        
        if let nomePokemon = pokemon.nomePokemon {
            self.coreDataPokemons.updatePokemon(nomePokemon: nomePokemon, capturado: true)
        }
        
        
    }

}
