//
//  UpdateViewController.swift
//  ArjunS2Project
//
//

import UIKit
import Photos
import CoreData

class UpdateViewController: UIViewController {
    
    var selectedPin:LocationsEntity? = nil
    var selectedIndex:Int!
    var datasource:DataSource?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var birthdaySelector: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    var genders:[String] = ["Male","Female","Others"]
    
    @IBAction func AddImageButton(_ sender: Any) {
        takePhotoWithCamera()
    }
    var image:UIImage? = nil
    var cb:(()->())?
    @IBOutlet weak var selectedImagePreview: UIImageView!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var lattitudeText: UITextField!
    @IBOutlet weak var longitudeText: UITextField!
    @IBOutlet weak var deleteBtnView: UIButton!
    @IBAction func deleteBtn(_ sender: Any) {
        let res = datasource?.delete(location: selectedPin!, index: selectedIndex)
        if(res!){
            cb?()
            dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Save Button Function
    @IBAction func saveBtn(_ sender: Any) {
        if(name.text?.isEmpty ?? true || lattitudeText.text?.isEmpty ?? true || longitudeText.text?.isEmpty ?? true){
            print("Fill all fields")
            return
        }
        
        if(countryBtn.titleLabel?.text == "Select Country"){
            print("Country not selected")
            return
        }
        
        if selectedPin != nil{
            selectedPin?.birthday = birthdaySelector.date
            selectedPin?.country = countryBtn.titleLabel?.text
            selectedPin?.gender = genders[genderPicker.selectedRow(inComponent: 0)]
            selectedPin?.lattitude = Double(lattitudeText.text!) ?? 0
            selectedPin?.longitude = Double(longitudeText.text!) ?? 0
            selectedPin?.name = name.text
            selectedPin?.image = image?.jpegData(compressionQuality: 1) as Data?
            
            let res = datasource?.update(location: selectedPin!, index: selectedIndex)
            if(res!){
                cb?()
                dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
            } else {
                print("Error Saving")
            }
        } else {
            let res = datasource?.saveLocations(
                    name: name.text!,
                    birthday: birthdaySelector.date,
                    country: (countryBtn.titleLabel?.text)!,
                    gender: genders[genderPicker.selectedRow(inComponent: 0)],
                    latti: Double(lattitudeText.text!) ?? 0,
                    longi: Double(longitudeText.text!) ?? 0,
                image: (image?.jpegData(compressionQuality: 1) as Data?)! )
            
            if(res!){
                cb?()
                dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
            } else {
                print("Error Saving")
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self
//        self.hideKeyboardWhenTappedAround()
        if let selectedLocation = selectedPin{
            name.text = selectedLocation.name
            birthdaySelector.date = selectedLocation.birthday!
            genderPicker.selectRow(genders.firstIndex(of: selectedLocation.gender!)!, inComponent: 0, animated: true)
            countryBtn.setTitle(selectedLocation.country, for: .normal)
            if let img = selectedLocation.image{
                selectedImagePreview.image = UIImage(data: img)
            }
            lattitudeText.text = String(selectedLocation.lattitude)
            longitudeText.text = String(selectedLocation.longitude)
            deleteBtnView.isHidden = false
        } else{
            deleteBtnView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectCountry"){
            let dest = segue.destination as! CountryController
            dest.cb = countrySelectedCallback
        }
    }
    
    func countrySelectedCallback(country:String){
        countryBtn.setTitle(country, for: .normal)
        print("Country selected: \(country)")
    }
}


// MARK: Image Picker
extension UpdateViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImagePreview.image = pickedImage
            image = selectedImagePreview.image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Picker View
extension UpdateViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
}

//extension UpdateViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UpdateViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
