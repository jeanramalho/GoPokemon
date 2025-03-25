//
//  ModelPokemon.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 24/03/25.
//
import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init(){
        
        //deve ser o nome do arquivo e nao da entidade
        persistentContainer = NSPersistentContainer(name: "GoPokemon")
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let erro = error {
                fatalError("Erro ao carregar core data: \(erro.localizedDescription )")
            }
            
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - Salva alterações no banco de dados
    func saveContext(){
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                try context.save()
                print("Dados salvos com sucesso")
            } catch {
                print("Erro ao salvar dados: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Salvar todos os pokemons
    func saveAllPokemons(){
        
        self.createPokemon(nomePokemon: "Mew", nomeImagem: "mew", capturado: false)
        self.createPokemon(nomePokemon: "zubat", nomeImagem: "zubat", capturado: false)
        self.createPokemon(nomePokemon: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.createPokemon(nomePokemon: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.createPokemon(nomePokemon: "Rattata", nomeImagem: "rattata", capturado: false)
        self.createPokemon(nomePokemon: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.createPokemon(nomePokemon: "Pikachu", nomeImagem: "pikachu-2", capturado: false)
        self.createPokemon(nomePokemon: "Meowth", nomeImagem: "meowth", capturado: false)
        self.createPokemon(nomePokemon: "Charmander", nomeImagem: "charmander", capturado: false)
        self.createPokemon(nomePokemon: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.createPokemon(nomePokemon: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.createPokemon(nomePokemon: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        
        saveContext()
    }
    
    //MARK: - Cria Pokemon
    func createPokemon(nomePokemon: String, nomeImagem: String, capturado: Bool){
        
        let newPokemon = Pokemons(context: context)
        newPokemon.nomePokemon = nomePokemon
        newPokemon.nomeImagem = nomeImagem
        newPokemon.capturado = capturado
        
        
    }
    
    //MARK: - Filtra pokemons capturados
    
    func fetchPokemonsCapturados(capturado: Bool) -> [Pokemons] {
        let fetchRequest: NSFetchRequest<Pokemons> = Pokemons.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "capturado = %@", NSNumber(value: capturado))
        
        do {
            let pokemons = try context.fetch(fetchRequest)
            return pokemons
        } catch {
            print("Erro ao localizar tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - Carrega Pokemons
    func buscaPokemons() -> [Pokemons] {
        let fetchRequest: NSFetchRequest<Pokemons> = Pokemons.fetchRequest()
        
        do {
            var pokemons = try context.fetch(fetchRequest)
            if pokemons.isEmpty {
                        self.saveAllPokemons()
                        pokemons = try context.fetch(fetchRequest) // Recarrega os Pokémon
                    }
            return pokemons
        } catch {
            print("Erro ao localizar tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    //MARK: - Atualiza Pokemon
    func updatePokemon(nomePokemon: String, capturado: Bool){
        
        let fetchRequest: NSFetchRequest<Pokemons> = Pokemons.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nomePokemon == %@", nomePokemon as CVarArg)
        
        do {
            let pokemons = try context.fetch(fetchRequest)
            if let pokemonToUpdate = pokemons.first {
                pokemonToUpdate.capturado = capturado
                saveContext()
            }
        } catch {
            print("Erro ao atualizar tarefa: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Deleta Pokemons
    func deletaPokemon(nomePokemon: String){
        let fetchRequest: NSFetchRequest<Pokemons> = Pokemons.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nomePokemon == %@", nomePokemon as CVarArg)
        
        do {
            let pokemons = try context.fetch(fetchRequest)
            if let pokemonToDelete = pokemons.first {
                context.delete(pokemonToDelete)
                saveContext()
            }
        } catch {
            print("Erro ao atualizar tarefa: \(error.localizedDescription)")
        }
    }
    
}
