//
//  GoPokemonHomeView.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 21/03/25.
//
import Foundation
import UIKit
import MapKit

class GoPokemonHomeView: UIView {
    
    lazy var updateLocationButton: UIButton = {
        //Configuracao do tamanho da imagem do botao
        var config = UIButton.Configuration.plain()
        
        //remove padding da imagem dentro do botao
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "compass") {
            let imagemRedimensionada = image.withRenderingMode(.alwaysOriginal)
                .resizeImage(to: CGSize(width: 60, height: 60))
            button.setImage(imagemRedimensionada, for: .normal)
        }
        
        button.backgroundColor = .clear

        return button
    }()
    
    lazy var pokeAgendaButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "pokeball") {
            let imageRedimensionada = image.withRenderingMode(.alwaysOriginal)
                .resizeImage(to: CGSize(width: 60, height: 60))
            button.setImage(imageRedimensionada, for: .normal)
        }
        return button
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(mapView)
        addSubview(updateLocationButton)
        addSubview(pokeAgendaButton)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            updateLocationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            updateLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            pokeAgendaButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pokeAgendaButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
        ])
    }
}


//UIKIt nao redimensiona imagens nativamente, entao temos que criar uma extensao com uma funcao para esse trabalho
extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
