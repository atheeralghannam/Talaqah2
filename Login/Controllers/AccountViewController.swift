//
//  AccountViewController.swift
//  Login
//
//  Created by Horiah on 11/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class AccountViewController: UIViewController {
    
    //var patientArray = [Any]()
    var newPatient = [String: String]()
    private var document: [DocumentSnapshot] = []
    var pEmail = String(), fName = String(), lName = String(), pGender = String(), pnID = String(), phoneNumber = String()
    
    var cue = String.self
    var array=[String]()
    
    
    @IBOutlet var PatientName: UITextField!
    
    @IBOutlet var PatientGender: UITextField!
    
   
    @IBOutlet var NID: UITextField!
    
    @IBOutlet var PatientPhone: UITextField!
    
    @IBOutlet var PatientEmail: UITextField!
    
    
    
    
   
    
    @IBOutlet var sendProgress: UIButton!
    
    @IBOutlet var viewProgress: UIButton!
    

   
    
    
    let db = Firestore.firestore()
    
    //let PatientIfo: [Patient]
    
    //let patientInfo = [Patient].self
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
          return .portrait
      }
      override var shouldAutorotate: Bool {
          return true
      }
        
        override func viewDidLoad() {
    //        super.viewDidLoad()
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

            Utilities.styleSecondaryButton(button: viewProgress)
            Utilities.styleTextField(textfield: PatientName)
            Utilities.styleTextField(textfield: PatientEmail)
            Utilities.styleTextField(textfield: PatientPhone)
            Utilities.styleTextField(textfield: PatientGender)
            Utilities.styleTextField(textfield: NID)

        loadData()
       
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        
    }
    
    @IBAction func toHome(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func viewProgressPressed(_ sender: UIViewController) {
        
               db.collection("patients").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid ).getDocuments { (snapshot, error) in
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
                                 self.performSegue(withIdentifier: "toViewProgress", sender: nil)
                             }
                             
                            
                           }
                           
                     
                           
                           
                       }
                   }
               }
    }
    
    
    
    func loadPatientInfo(){

        let docRef = db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid)

        docRef.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else if querySnapshot!.documents.count != 1 {
                print("More than one documents or none")
            } else {
                let document = querySnapshot!.documents.first
                let dataDescription = document?.data()
                guard let firstname = dataDescription?["FirstName"] else { return }
                print(firstname)
            }
        }
    }
    
    func loadData() {
      /*  let docRef = db.collection("patients").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
               
               docRef.getDocuments { (querySnapshot, error) in
                   
                   if let error = error {
                       print(error.localizedDescription)
                       return
                   } //else if querySnapshot!.documents.count != 1 {
                      // print("More than one documents or none")
                  // }
        else {
                       let document = querySnapshot!.documents.first
                       let dataDescription = document?.data()
                       guard let firstname = dataDescription?["FirstName"] else { return }
                       print(firstname)
                   }
        
        */
        
//         db.collection("patients")
            db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {

                    for document in snapshot.documents {

                        let data = document.data()
                        
                        //self.pEmail = data["Email"] as? String ?? ""
                        self.pEmail = data["Email"] as! String
                        self.fName = data["FirstName"] as! String
                        self.lName = data["LastName"] as! String
                        
                        let name = self.fName+" "+self.lName
                        self.pGender = data["Gender"] as! String
                        self.pnID = data["NID"] as! String
                        self.phoneNumber = data["PhoneNumber"] as! String
                        
                        self.PatientName.text = name
                        self.NID.text=self.pnID
                        self.PatientGender.text = self.pGender
                        self.PatientPhone.text = self.phoneNumber
                        self.PatientEmail.text = self.pEmail
                        

                        self.newPatient = ["NID": self.pnID, "FirstName": self.fName, "LastName": self.lName, "Gender": self.pGender, "PhoneNumber": self.phoneNumber, "Email":self.pEmail]
                        
                        //self.patientArray.append(self.newPatient)
                        print(self.newPatient)
                    }
                    
                }
            }
        }
    }
    
    func loadPatient() {
        if let userId = Auth.auth().currentUser?.uid {
            let collectionRef = self.db.collection("patients")
            let thisUserDoc = collectionRef.document(userId)
            thisUserDoc.getDocument(completion: { document, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if let doc = document {
                    let Name = doc.get("FirstName") ?? ""
                    print(Name)
                }
            })
        }
    }
    
    
   // these for trail
    func getForCategory(category : String){
        db.collection("trials").whereField("Category", isEqualTo: category)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
    }
    
    func getForExType(exType : String){
        db.collection("trials").whereField("ExerciseType", isEqualTo: exType)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
    }
    
    func cues(){
        db.collection("trials").getDocuments { (snapshot, error) in
                      if let error = error {
                          print(error.localizedDescription)
                      } else {
                          if let snapshot = snapshot {

                              for document in snapshot.documents {

                                let data = document.data()["Cues"]! as! [Any]
                                print(data)
                                 
                                for (index, element) in data.enumerated() {
                                    print(element)
                                }

                              }
                              
                          }
                      }
        }
    }
// ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
//       
//       override open var shouldAutorotate: Bool {
//           return false
//       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome"{
            let destnationVC = segue.destination as! BaseViewController
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
}
