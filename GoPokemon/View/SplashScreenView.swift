//
//  SplashScreenView.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 21/03/25.
//
import Foundation
import UIKit

class SplashScreenView: UIView {
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "background")
        image.clipsToBounds = true
        return image
    }()
    
    lazy var goImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "go-logo")
        return image
    }()
    
    lazy var pokemonImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "pokemon-logo")
        image.clipsToBounds = true
        return image
    }()
    
    lazy var logoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        addSubview(backgroundImageView)
        
        addSubview(logoStackView)
        
        logoStackView.addArrangedSubview(goImageView)
        logoStackView.addArrangedSubview(pokemonImageView)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            // Fundo ocupando toda a tela
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Container das imagens centralizado
            logoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Definir larguras PROPORCIONAIS das imagens (não altura)
            goImageView.widthAnchor.constraint(equalTo: logoStackView.widthAnchor, multiplier: 0.6),
            pokemonImageView.widthAnchor.constraint(equalTo: logoStackView.widthAnchor, multiplier: 0.8),
                        
            // Definir altura das imagens para controlar melhor o tamanho total
            goImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            pokemonImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])

    }
}
