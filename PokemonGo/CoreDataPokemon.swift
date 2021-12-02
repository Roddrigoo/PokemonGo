//
//  CoreDataPokemon.swift
//  PokemonGo
//
//  Created by Rodrigo Lourenço on 27/10/21.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
    //-----------------------------------------------------------------------------------
    //  MARK: - Recover context
    //-----------------------------------------------------------------------------------
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        return context!
    }
    
    func recoverPokemonCaptured(recover: Bool) ->  [Pokemon] {
        
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        request.predicate = NSPredicate(format: "captured = %d", recover as CVarArg)
        
        do{
            let pokemons = try context.fetch(request) as [Pokemon]
            return pokemons
        }catch{}
        
        return []
    }
    
    func recoverPokemons() -> [Pokemon]{
        let context = self.getContext ()
        
        do{
            let pokemons = try context.fetch( Pokemon.fetchRequest())
            
            if pokemons.count == 0{
                self.addAllPokemons()
                return self.recoverPokemons()
            }
            
            return pokemons
        }catch{}
        
        return []
    }
    
    func savePokemon(pokemon: Pokemon){
        let context = self.getContext()
        pokemon.captured = true
        
        do{
            try context.save()
        }catch{}
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - Add Pokemons
    //-----------------------------------------------------------------------------------
    
    func addAllPokemons(){
        
        let context = self.getContext()
        
        self.creatPokemon(namePokemon: "Mew", nameImage: "mew", captured: false)
        self.creatPokemon(namePokemon: "Meowth", nameImage: "meowth", captured: false)
        self.creatPokemon(namePokemon: "Pikachu", nameImage: "pikachu-2", captured: false)
        self.creatPokemon(namePokemon: "Squirtle", nameImage: "squirtle", captured: false)
        self.creatPokemon(namePokemon: "Charmander", nameImage: "charmander", captured: false)
        self.creatPokemon(namePokemon: "Bullbasaur", nameImage: "bullbasaur", captured: false)
        self.creatPokemon(namePokemon: "Bellsprout", nameImage: "bellsprout", captured: false)
        self.creatPokemon(namePokemon: "psyduck", nameImage: "psyduck", captured: false)
        
        do{
            try context.save()
        }catch{}
        
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - Create pokemons
    //-----------------------------------------------------------------------------------
    
    func creatPokemon(namePokemon: String, nameImage: String, captured: Bool){
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.namePokemon = namePokemon
        pokemon.nameImage = nameImage
        pokemon.captured = captured
    }
}
