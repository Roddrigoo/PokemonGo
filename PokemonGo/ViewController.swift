//
//  ViewController.swift
//  PokemonGo
//
//  Created by Rodrigo Lourenço on 21/10/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var managerlocation = CLLocationManager()
    var counter = 0
    var coreData: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    @IBOutlet weak var mapPoke: MKMapView!
    
    @IBAction func centralPlayer(_ sender: Any) {
        self.cetralizer()
    }
    
    @IBAction func openPokeDesk(_ sender: Any) {
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - UIViewController
    //-----------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapPoke.delegate = self
        managerlocation.delegate = self
        managerlocation.requestWhenInUseAuthorization()
        managerlocation.startUpdatingLocation()
        
        //Recovers random pokemon
        
        self.coreData = CoreDataPokemon()
        self.pokemons = self.coreData.recoverPokemons()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (Timer) in
            
            if let coordinates = self.managerlocation.location?.coordinate{
                
                let totalPokemons = UInt32(self.pokemons.count)
                let indicePokemonsRandom = arc4random_uniform(totalPokemons)
                
                let pokemon  = self.pokemons[ Int(indicePokemonsRandom)]
                
                let annotation = PokemonAnnotation(local: coordinates, pokemon: pokemon)
                
                let latRandom = Double.random(in: -200...400) / 100000.0
                let longRandom = Double.random(in: -200...400) / 100000.0
                
                annotation.coordinate.latitude += latRandom
                annotation.coordinate.longitude += longRandom
                
                self.mapPoke.addAnnotation(annotation)
            }
        }
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - MapView
    //-----------------------------------------------------------------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        }else{
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage( named: pokemon.nameImage! )
            
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let note = view.annotation
        let pokemon = (view.annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation( note, animated: true)
        
        if note is MKUserLocation{
            return
        }
        
        if let coordAnnotation = note?.coordinate {
            let region = MKCoordinateRegion(center: coordAnnotation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapPoke.setRegion(region, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            if let coord = self.managerlocation.location?.coordinate{
                if self.mapPoke.visibleMapRect.contains(MKMapPoint(coord)) {
                    self.coreData.savePokemon(pokemon: pokemon)
                    self.mapPoke.removeAnnotation(note!)
                    
                    let alertControl = UIAlertController(title: "Congratulations!!!",
                                                         message: "You found a pokemon: \(pokemon.namePokemon!)",
                                                         preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertControl.addAction(ok)
                    
                    self.present(alertControl, animated: true, completion: nil)
                    
                }
                
            }else{
                
                let alertControl = UIAlertController(title: "You can't capture",
                                                     message: "Get closer to capture to: \(pokemon.namePokemon!) ",
                                                     preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertControl.addAction(ok)
                
                self.present(alertControl, animated: true, completion: nil)
            }
        }
    }
    
    //-----------------------------------------------------------------------------------
    //  MARK: - LocationManager
    //-----------------------------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.cetralizer()
        counter += 1
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .denied {
            
            let alertController = UIAlertController(title: "Location permission.",
                                                    message: "In order for you to hunt Pokemon, we need your location.",
                                                    preferredStyle: .alert)
            let actionConfig = UIAlertAction(title: "Open settings", style: .default, handler: {(alertConfig)in
                
                if let configs = NSURL (string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configs as URL)
                }
            })
            
            let actionCancel = UIAlertAction(title: "Cancell", style: .default, handler: nil)
            
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func cetralizer (){
        if let coordinates = managerlocation.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            mapPoke.setRegion(region, animated: true)
        }
    }
}
