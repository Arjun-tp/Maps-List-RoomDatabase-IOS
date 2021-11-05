//
//  CountryController.swift
//  ArjunS2Project
//

import UIKit

class CountryController: UITableViewController {

    var countries:[String] = ["Argentina", "Australia", "Austria", "Bahrain", "Bangladesh", "Belgium", "Bhutan", "Brazil", "Canada", "China", "Costa Rica", "Croatia", "Cuba", "Denmark", "Egypt", "Germany", "Hungary", "India", "Ireland", "Israel", "Japan", "Kuwait", "Luxembourg", "Netherlands", "New Zealand", "Portugal", "Qatar", "South Korea", "Sweden", "Switzerland", "Thailand", "Turkey", "United Arab Emirates", "Zimbabwe"]
    var cb:((String)->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cb(countries[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return countries.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            }
            
            cell?.textLabel?.text = countries[indexPath.row]
            
            return cell!
        }
}


func parse(_ data:Data) -> [SearchResults]? {
    let decoder = JSONDecoder()
    do{
        let results = try decoder.decode([SearchResults].self, from: data)
        return results
    } catch
    {
        print("Error parsing")
        return nil
    }
}
