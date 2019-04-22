//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Michael Luo on 18/4/19.
//  Copyright © 2019 Michael Luo. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemon = [Pokemon]()
    var uncaughtPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        caughtPokemon = getCaughtPokemon()
        uncaughtPokemon = getUncaughtPokemon()
    }
    

    @IBAction func cancleTapped(_ sender: Any) {
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // caught and uncaught
        return 2
    }
    
    // Set header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        }
        return "UNCAUGHT"
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        }
        return uncaughtPokemon.count
    }
    
    // MAKE A NICE CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var pokemon:Pokemon
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = uncaughtPokemon[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.name
        
        if let imageName = pokemon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    
}
