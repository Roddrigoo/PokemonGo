//
//  PokeScheduleViewController.swift
//  PokemonGo
//
//  Created by Rodrigo Lourenço on 28/10/21.
//

import UIKit

class PokeScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonsFree: [Pokemon] = []
    var pokemonsCaptured: [Pokemon] = []
    
    //-----------------------------------------------------------------------------------
    //  MARK: - UIViewController
    //-----------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreData = CoreDataPokemon()
        
        self.pokemonsCaptured = coreData.recoverPokemonCaptured(recover: true)
        self.pokemonsFree = coreData.recoverPokemonCaptured(recover: false)
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - UITableView
    //-----------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Captured"
        }else{
            return "Not captured"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.pokemonsCaptured.count
        }else{
            return self.pokemonsFree.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCaptured[ indexPath.row ]
        }else{
            pokemon = self.pokemonsFree[ indexPath.row ]
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = pokemon.namePokemon
        cell.imageView?.image = UIImage( named: pokemon.nameImage! )
        
        return cell
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - Custom Methods
    //-----------------------------------------------------------------------------------
    
    @IBAction func backMap(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
