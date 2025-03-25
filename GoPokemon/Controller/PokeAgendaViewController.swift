//
//  PokeAgendaViewController.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 25/03/25.
//
import Foundation
import UIKit

class PokeAgendaViewController: UIViewController {
    
    let contentView: PokeAgendaView = PokeAgendaView()
    let coreDataManager = CoreDataManager.shared
    var pokemonsCapturados: [Pokemons] = []
    var pokemonsNaoCapturados: [Pokemons] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        pokemonsCapturados = coreDataManager.fetchPokemonsCapturados(capturado: true)
        pokemonsNaoCapturados = coreDataManager.fetchPokemonsCapturados(capturado: false)
        
    
        
        setupContentView()
        setHierarchy()
        setConstraints()
    }
    
    private func setupContentView(){
        
        contentView.pokeAgendaTableView.delegate = self
        contentView.pokeAgendaTableView.dataSource = self
        contentView.pokeAgendaTableView.register(PokeAgendaTableViewCell.self, forCellReuseIdentifier: PokeAgendaTableViewCell.identifier)
        
        contentView.mapButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
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
    
    @objc private func closeModal(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension PokeAgendaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pokemons Capturados"
        } else {
            return "Pokemons Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsCapturados.count
        } else {
            return pokemonsNaoCapturados.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemons
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturados[indexPath.row]
        } else {
            pokemon = self.pokemonsNaoCapturados[indexPath.row]
        }
        
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeAgendaTableViewCell.identifier, for: indexPath) as? PokeAgendaTableViewCell else {return UITableViewCell()}
        
        cell.pokemonLabel.text =  pokemon.nomePokemon
        cell.pokemonImage.image = UIImage(named: pokemon.nomeImagem ?? "")
        
        return cell
    }
    
    
}
