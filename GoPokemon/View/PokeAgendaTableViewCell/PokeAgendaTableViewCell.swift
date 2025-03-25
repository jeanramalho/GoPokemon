//
//  PokeAgendaTableViewCell.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 25/03/25.
//
import Foundation
import UIKit

class PokeAgendaTableViewCell: UITableViewCell {
    
    static let identifier: String = "PokeAgendaTableViewCell"
    
    lazy var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image =  UIImage(named: "pikachu-2")
        return image
    }()
    
    lazy var pokemonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.text = "Pikachu"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(pokemonImage)
        addSubview(pokemonLabel)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            pokemonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            pokemonImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            pokemonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pokemonLabel.leadingAnchor.constraint(equalTo: pokemonImage.trailingAnchor, constant: 20),
        ])
    }
}
