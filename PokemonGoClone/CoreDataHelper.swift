//
//  CoreDataHelper.swift
//  PokemonGoClone
//
//  Created by Michael Luo on 18/4/19.
//  Copyright © 2019 Michael Luo. All rights reserved.
//

import CoreData
import UIKit

func addAllPokemon() {
    // Add pokemon one by one
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
}

func createPokemon(name:String, imageName:String) {
    
    
    
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(context: context)
        pokemon.name = name;
        pokemon.imageName = imageName
        pokemon.caught = false
        
        try? context.save()
    }
}

func getAllPokemons() ->[Pokemon]{
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let pokeData = try? context.fetch(Pokemon.fetchRequest())  {
       
            if let pokemons = pokeData as? [Pokemon] {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemons()
                }
                return pokemons
            }
        }
    }
    
    return []
}

func getCaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == true")
        if let pokemon = try? context.fetch(fetchRequest) {
            return pokemon
        }
    }
    
    return []
}

func getUncaughtPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        fetchRequest.predicate = NSPredicate(format: "caught == false")
        if let pokemon = try? context.fetch(fetchRequest) {
            return pokemon
        }
    }
    
    return []
}
