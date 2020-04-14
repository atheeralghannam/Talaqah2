//
//  CategoriesViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class CategoriesViewController: UIViewController {
    
      //Checkboxes outlets for save thier state (maybe not needed)
      @IBOutlet weak var body: UIButton!
      @IBOutlet weak var personal: UIButton!
      @IBOutlet weak var family: UIButton!
      @IBOutlet weak var food: UIButton!
      @IBOutlet weak var cloths: UIButton!
      @IBOutlet weak var drinks: UIButton!
      @IBOutlet weak var vegetables: UIButton!
      @IBOutlet weak var fruits: UIButton!
      @IBOutlet weak var pots: UIButton!
      @IBOutlet weak var house: UIButton!
      @IBOutlet weak var furniture: UIButton!
      @IBOutlet weak var devices: UIButton!
      @IBOutlet weak var `public`: UIButton!
      @IBOutlet weak var transportation: UIButton!
      @IBOutlet weak var jobs: UIButton!
      @IBOutlet weak var animal: UIButton!
      @IBOutlet weak var shapes: UIButton!
      @IBOutlet weak var colors: UIButton!
    var categories = [""]
    var settings = [0]
    var patient : Patient?
    var first = false
    let db = Firestore.firestore()
    var isSave = false
    //    var activityIndecator: UIActivityIndicatorView = UIActivityIndicatorView()
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .landscapeLeft
       }
       override var shouldAutorotate: Bool {
           return true
       }
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Do any additional setup after loading the view.
           let value = UIInterfaceOrientation.landscapeLeft.rawValue
           UIDevice.current.setValue(value, forKey: "orientation")
           let tal = UIColor(named: "Tala")
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = self.view.bounds
           gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
           self.view.layer.insertSublayer(gradientLayer, at: 0)
           //removeCatiegory(categ: "")
           initCheckedBoxes()
       }
    @IBAction func setComplixity(_ sender: UIButton) {
        if isSave {
            //preform segue full screen to set
            self.performSegue(withIdentifier: "toCom", sender: self)
            
        } else{
            let alertController = UIAlertController(title: "لم يتم حفظ التغييرات", message:
                "انقر حفظ ليتم حفظ تغييراتك", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ASelectedCategories(_ sender: UIButton) {
        //Checkbox
        if sender.isSelected {
            sender.isSelected = false
            removeCatiegory(categ: sender.currentTitle!)
        } else {
            sender.isSelected = true
            fillCatiegory(categ: sender.currentTitle!)
        }
        
    }
    
    @IBAction func Save(_ sender: UIButton) {
        patientCate()
        //(preform segue or not?)
    }
    func initCheckedBoxes(){
          //how
          //complexity incresed here change code
          for cat in categories {
              if cat == "body"{
                  body.isSelected = true
              }
              else if cat == "personal"{
                  personal.isSelected = true
              }
              else if cat == "family"{
                  family.isSelected = true
              }
              else if cat == "food"{
                  food.isSelected = true
              }
              else if cat == "cloths"{
                  cloths.isSelected = true
              }
              else if cat == "drinks"{
                  drinks.isSelected = true
              }else if cat == "vegetables"{
                  vegetables.isSelected = true
              }else if cat == "fruits"{
                  fruits.isSelected = true
              }else if cat == "pots"{
                  pots.isSelected = true
              }else if cat == "house"{
                  house.isSelected = true
              }else if cat == "furniture"{
                  furniture.isSelected = true
              }else if cat == "devices"{
                  devices.isSelected = true
              }else if cat == "public"{
                  `public`.isSelected = true
              }else if cat == "transportation"{
                  transportation.isSelected = true
              }else if cat == "jobs"{
                  jobs.isSelected = true
              }else if cat == "animal"{
                  animal.isSelected = true
              }else if cat == "shapes"{
                  shapes.isSelected = true
              }else if cat == "colors"{
                  colors.isSelected = true
              }
          }
      }
    @IBAction func Back(_ sender: UIButton) {
          //preform segue
          self.performSegue(withIdentifier: "back", sender: self)
      }
      func fillCatiegory(categ : String){
          if categories.isEmpty{
              first = true
          }
          categories.append(categ)
          
      }
      func removeCatiegory(categ : String){
          if let removedCategoryIndex = categories.firstIndex(of: categ){
              categories.remove(at: removedCategoryIndex)
          }
      }
      
      private func patientCate(){
          //fill patient categories in firestore with the chocen ones
          db.collection("patients")
              .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
              .getDocuments() { (querySnapshot, error) in
                  if let error = error {
                      print(error.localizedDescription)
                  } else if querySnapshot!.documents.count != 1 {
                      print("More than one documents or none")
                  } else {
                      let document = querySnapshot!.documents.first
                      document!.reference.updateData([
                          "categories" : self.categories
                      ])
                  }
          }
          let alertController = UIAlertController(title: "تم الحفظ", message:
              "تم حفظ التغييرات بنجاح!", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "حسنًا", style: .default))
          self.present(alertController, animated: true, completion: nil)
          isSave = true
          //    activityIndecator.stopAnimating()
          //    UIApplication.shared.endIgnoringInteractionEvents()
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "back"{
              let destnationVC = segue.destination as! SettingsViewController
            destnationVC.settings = settings
            destnationVC.categories = categories
            destnationVC.patinet = patient
              destnationVC.modalPresentationStyle = .fullScreen
          }
          if segue.identifier == "toCom"{
              let destnationVC = segue.destination as! ComplixityViewController
              destnationVC.isCat = true
              destnationVC.Settings = settings
                destnationVC.categories = categories
            destnationVC.patient = patient
              destnationVC.modalPresentationStyle = .fullScreen
          }
      }

}
