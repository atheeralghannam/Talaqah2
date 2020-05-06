//
//  DetailViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 08/07/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class DetailViewController: UIViewController, UITextFieldDelegate {

var patient: Patient?
    var array=[String]()

    let db = Firestore.firestore()



    @IBOutlet weak var viewProgressButton: UIButton!
    
    
    @IBOutlet var remove: UIButton!
    

    

    
    
    @IBOutlet var patientFullName: UITextField!
    
    @IBOutlet var patientID: UITextField!
    @IBOutlet var patientEmail: UITextField!
    @IBOutlet var patientPhone: UITextField!
//    @IBOutlet var patientGender: UITextField!
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
        
//
//        //selectedPatient
//        UserDefaults.standard.set(patient!.uid, forKey: Constants.selectedPatient)

        
        SetUpElements()

        if let patient = patient {
                        
            patientFullName.text = patient.FirstName + " " + patient.LastName
            
            patientID.text =  patient.NID
            
            patientPhone.text =  patient.PhoneNumber
            
//            patientGender.text =  patient.Gender
            
            patientEmail.text = patient.Email
       
        
        
        
        }
        
        patientFullName.delegate = self
        patientID.delegate = self
        patientPhone.delegate = self
//        patientGender.delegate = self
        patientEmail.delegate = self

        
    }
    func SetUpElements() {
        
        // Hide the error label
        
        // Style the elements
        Utilities.styleTextField(textfield: patientFullName)
        Utilities.styleTextField(textfield: patientID)
        Utilities.styleTextField(textfield: patientPhone)
        Utilities.styleTextField(textfield: patientEmail)
//        Utilities.styleTextField(textfield: patientGender)


        patientPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        patientPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    @IBAction func pSettings(_ sender: UIButton) {
        if patient != nil {
                   self.performSegue(withIdentifier: "patientSettings", sender: self)
               } else{
                  //
               }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patientSettings"{
            let destnationVC = segue.destination as! SLPSettingsViewController
            destnationVC.settings = patient!.settings
            destnationVC.categories = patient!.categories
            destnationVC.uid = patient!.uid
            destnationVC.patient = patient
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
    
    
    
}

