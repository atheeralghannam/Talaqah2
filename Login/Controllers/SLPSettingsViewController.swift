//
//  SLPSettingsViewController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 24/03/2020.
//  Copyright © 2020 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
class SLPSettingsViewController: UIViewController {
    
    let db = Firestore.firestore()
    var categories = [""]
    var settings = [3,2,2,2]
    var patient : Patient?
    var uid = ""
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let tal = UIColor(named: "Tala")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChoiceSelected(_ sender: UIButton) {
        if (sender.restorationIdentifier == "Cat" ){
            self.performSegue(withIdentifier: "toCat", sender: self)
        }
        
        //Verb
        if sender.restorationIdentifier == "Com"{
            self.performSegue(withIdentifier: "toCom", sender: self)
        }
        if sender.restorationIdentifier == "cues"{
            //cues
            self.performSegue(withIdentifier: "cues", sender: self)
        }
    }
    
    @IBAction func DeletePatient(_ sender: UIButton) {
        let alertView = SCLAlertView()
        
        alertView.addButton("نعم") {
            
            
            self.db.collection("patients")
                .whereField("NID", isEqualTo : self.patient!.NID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if querySnapshot!.documents.count != 1 {
                        print("More than one documents or none")
                    } else {
                        
                        
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "slpUid": ""
                        ])
                        
                    }}
            
            
            
            let appearance = SCLAlertView.SCLAppearance(
                       showCloseButton: false
                   )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("حسنًا") {
                self.performSegue(withIdentifier: "deletePatient", sender: self)
            }
            alert.showSuccess("تم حذف المريض بنجاح", subTitle: "")
        }
        alertView.showWarning( "إزالة المريض", subTitle: "هل أنت متأكد من أنك تريد إزالة هذا المريض؟", closeButtonTitle: "لا")
        
        
        
        
    }
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            let destnationVC = segue.destination as! DetailViewController
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
        if segue.identifier == "toCat"{
            let destnationVC = segue.destination as! CatSLpViewController
            destnationVC.categories = categories
            destnationVC.settings = settings
            destnationVC.patient = patient
            destnationVC.uid = uid
            destnationVC.modalPresentationStyle = .fullScreen
        }
        if segue.identifier == "toCom"{
            let destnationVC = segue.destination as! ComSLpViewController
            destnationVC.Settings = settings
            destnationVC.categories = categories
            destnationVC.uid = uid
            destnationVC.patient = patient
            
            print(settings)
            destnationVC.modalPresentationStyle = .fullScreen
        }
        if segue.identifier == "cues"{
            let destnationVC = segue.destination as! SLPCuesViewController
            destnationVC.settings = settings
            destnationVC.cat = categories
            destnationVC.uid = uid
            destnationVC.patient = patient
            
            print(settings)
            destnationVC.modalPresentationStyle = .fullScreen
        }
        if segue.identifier == "deletePatient"{
            let destnationVC = segue.destination as! PatientsTableViewController
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
}
