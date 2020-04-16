//
//  DetailViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 08/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
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
    @IBOutlet var patientGender: UITextField!
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
        

        //selectedPatient
        UserDefaults.standard.set(patient?.uid, forKey: Constants.selectedPatient)

        
        SetUpElements()

        if let patient = patient {
            navigationItem.title = patient.FirstName
//            imageView.image = UIImage(named: recipe.thumbnails)
            
//            let name = patient.FirstName + " " + patient.LastName
                        
            patientFullName.text = patient.FirstName + " " + patient.LastName
            
            patientID.text =  patient.NID
            
            patientPhone.text =  patient.PhoneNumber
            
            patientGender.text =  patient.Gender
            
            patientEmail.text = patient.Email
       
        
        
        
        }
        
        patientFullName.delegate = self
        patientID.delegate = self
        patientPhone.delegate = self
        patientGender.delegate = self
        patientEmail.delegate = self

        
    }
    func SetUpElements() {
        
        // Hide the error label
        
        // Style the elements
        Utilities.styleTextField(textfield: patientFullName)
        Utilities.styleTextField(textfield: patientID)
        Utilities.styleTextField(textfield: patientPhone)
        Utilities.styleTextField(textfield: patientEmail)
        Utilities.styleTextField(textfield: patientGender)


        patientPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        patientPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    @IBAction func removePatientTapped(_ sender: Any) {
        
        
        
        

                                                        
                                                        
                                                        let refreshAlert = UIAlertController(title: "إزالة المريض", message:"هل أنت متأكد من أنك تريد إزالة هذا المريض؟", preferredStyle: UIAlertController.Style.alert)
                                                               
                                                               refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                                                         
                                                                   
                                                                self.db.collection("patients")
                                                                    .whereField("NID", isEqualTo : self.patient?.NID)
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
                                                                                //            self.tableView.reloadData()
                                                                                                       
                                                                                                        
                                                                                                        
                                                                //                                        self.showToast(message: "تمت الإضافة بنجاح", font: UIFont(name: "Times New Roman", size: 12.0)!)

                                                                                                    }}
                                                                                
                                                                                
                                                                                                  var refreshAlert = UIAlertController(title: "تم حذف المريض بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)

                                                                                                    refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                                                                      print("Handle Ok logic here")
                                                                                                   
                                                                                                        self.performSegue(withIdentifier: "backToPatientsList", sender: nil)
                                                                                                        
        //                                                                                                let patientsVC = self.storyboard?.instantiateViewController(withIdentifier: "patientsList") as! UIViewController
        //
        //                                                                                                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //                                                                                                appDel.window?.rootViewController = patientsVC
                                                                                                        
                                                                                                      }))

                                                                

                                                                                                    self.present(refreshAlert, animated: true, completion: nil)
                                                                
                                                                
                                                                   
                                                               }))
                                                               
                                                               refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                   print("Handle Cancel Logic here")
                                                               }))
                                                               
                                                        self.present(refreshAlert, animated: true, completion: nil)
                                                        
                                                        
        
        
        
        
        

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
    
    
    
    @IBAction func viewProgressClicked(_ sender: Any) {
//      let db = Firestore.firestore()

      
          
          db.collection("patients").whereField("uid", isEqualTo: UserDefaults.standard.string(forKey: Constants.selectedPatient) ).getDocuments { (snapshot, error) in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                  if let snapshot = snapshot {
                      
                      for document in snapshot.documents {
                          
                          let data = document.data()
                          
                        self.array = data["progress"] as! [String]
                          
                        if (self.array.isEmpty){
                              let alert = UIAlertController(title: "عذرًا", message: "لم يتم إجراء أي تمرين", preferredStyle: UIAlertController.Style.alert)
                                         
                                         // add an action (button)
                                         alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
                                         
                                         // show the alert
                                         self.present(alert, animated: true, completion: nil)
   
                          } else{
                            self.performSegue(withIdentifier: "toSlpViewProgress", sender: nil)
                        }
                        
                       
                      }
                      
                
                      
                      
                  }
              }
          }
    }
    
    
}

