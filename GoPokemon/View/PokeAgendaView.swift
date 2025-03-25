//
//  Untitled.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 25/03/25.
//
import Foundation
import UIKit

class PokeAgendaView: UIView {
    
    lazy var pokeAgendaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var mapButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "map") {
            let imagemRedimensionada = image.withRenderingMode(.alwaysOriginal)
                .resizeImage(to: CGSize(width: 60, height: 60))
            button.setImage(imagemRedimensionada, for: .normal)
        }
        
        return button
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
        addSubview(pokeAgendaTableView)
        addSubview(mapButton)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            pokeAgendaTableView.topAnchor.constraint(equalTo: topAnchor),
            pokeAgendaTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pokeAgendaTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pokeAgendaTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}

