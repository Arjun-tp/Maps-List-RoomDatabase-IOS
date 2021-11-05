//
//  ViewController.swift
//  FinalProject
//

import UIKit
import CoreData
import MapKit

class ViewController: UIViewController {

    var selectedLocation:LocationsEntity? = nil
    var selectedindex:Int!
    var filterText:String = ""
    var datasource:DataSource!

    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var listView: UITableView!
    
    // Segment Control
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case 0 : mapview.isHidden = false; listView.isHidden = true
        case 1 : mapview.isHidden = true; listView.isHidden = false
        default: print("Error in segment control")
        }
        
    }
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = DataSource()
        mapview.isHidden = false
        listView.isHidden = true
        mapview.delegate = self
        searchbar.delegate = self
        listView.delegate = self
        listView.dataSource = self
        updatePins()
    }
    
    
    func updatePins(){
        selectedLocation = nil
        selectedindex = nil
        mapview.removeAnnotations(mapview.annotations)
        datasource.fetchLocations(filter: filterText)
        if let locations = datasource.locations {
            mapview.showAnnotations(locations, animated: true)
        } else {
            print("NO locations to show on map")
        }
        listView.reloadData()
    }
    
    @objc func editLocationDetails(_ sender: UIButton){
        editPinInEditController(sender.tag)
    }
    
    func editPinInEditController(_ index:Int){
        if let locations = datasource.locations {
            selectedLocation = locations[index]
            selectedindex = index
        }
        performSegue(withIdentifier: "editPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editPage"){
            let dest = segue.destination as! UpdateViewController
            dest.cb = updatePins
            dest.selectedPin = selectedLocation
            dest.selectedIndex = selectedindex
            dest.datasource = datasource
        }
    }
}

// MARK: Location
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is LocationsEntity else {
            print("return nil in mapview viewFor method")
            return nil
        }
        
        let identifier = "location"
        var annotationView = mapview.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = .systemYellow
            
            let righButton = UIButton(type: .detailDisclosure)
            righButton.addTarget(self, action: #selector(editLocationDetails), for: .touchUpInside)
            pinView.rightCalloutAccessoryView = righButton
            annotationView = pinView
        }
        
        if let annotationView = annotationView{
            annotationView.annotation = annotation
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let locations = datasource.locations{
                if let index = locations.firstIndex(of: annotation as! LocationsEntity){
                    button.tag = index
                }
            }
        }
        return annotationView
    }
}

extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("The search bar text is \(String(describing: searchbar.text))")
        searchBar.resignFirstResponder()
        filterText = searchbar.text ?? ""
        updatePins()
    }
}


// MARK: Table
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = datasource.locations?.count
        print("table view count \(String(describing: count))")
        if count == 0 {
            return 1
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if(datasource.locations?.count ?? 0 > 0){
            print("Creating valid cell \(indexPath.row)")

            let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell
        
            cell?.NameText.text = datasource?.locations?[indexPath.row].name
            cell?.countryText.text = datasource?.locations?[indexPath.row].country
            if let img = datasource?.locations?[indexPath.row].image {
                cell?.imageView?.image = UIImage(data: img)
            }
            return cell!
        } else {
            print("Creating empty cell \(indexPath.row)")

            var cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as? EmptyTableViewCell
            if(cell == nil){
                cell = EmptyTableViewCell()
            }
            cell?.labelText.text = "No result found"
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editPinInEditController(indexPath.row)
    }
    
}
