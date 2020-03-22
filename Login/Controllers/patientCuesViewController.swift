//
//  patientCuesViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 23/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class patientCuesViewController: UIViewController {
    @IBOutlet var cue1: UISwitch!
    @IBOutlet var cue2: UISwitch!
    @IBOutlet var cue3: UISwitch!
    @IBOutlet var cue4: UISwitch!
    @IBOutlet var cue5: UISwitch!
    @IBOutlet var cue6: UISwitch!
    @IBOutlet var cue7: UISwitch!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitches()

        // Do any additional setup after loading the view.
    }
    
    func setupSwitches(){
        
        db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments {(snapshot, error) in
            if let error = error{print(error.localizedDescription)}
            else {
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        let data = document.data()

                        self.cue1.isOn = data["cue1"] as! Bool
                        self.cue2.isOn = data["cue2"] as! Bool
                        self.cue3.isOn = data["cue3"] as! Bool
                        self.cue4.isOn = data["cue4"] as! Bool
                        self.cue5.isOn = data["cue5"] as! Bool
                        self.cue6.isOn = data["cue6"] as! Bool
                        self.cue7.isOn = data["cue7"] as! Bool
    
                    }}}}
        
    }
    
    @IBAction func cue1pressed(_ sender: Any) {
        if cue1.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue1": true
                                   
                                ])
                            }
                    }


            cue1.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue1": false
                                   
                                ])
                            }
                    }


            cue1.setOn(false, animated:true)
        }
    }
    @IBAction func cue2pressed(_ sender: Any) {        if cue2.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue2": true
                                   
                                ])
                            }
                    }


            cue2.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue2": false
                                   
                                ])
                            }
                    }


            cue2.setOn(false, animated:true)
        }
    }
    
    @IBAction func cue3pressed(_ sender: Any) {
        if cue3.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue3": true
                                   
                                ])
                            }
                    }


            cue3.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue3": false
                                   
                                ])
                            }
                    }


            cue3.setOn(false, animated:true)
        }
    }
    @IBAction func cue4pressed(_ sender: Any) {
        if cue4.isOn {


                 self.db.collection("patients")
                             .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                             .getDocuments() { (querySnapshot, error) in
                                 if let error = error {
                                         print(error.localizedDescription)
                                 } else if querySnapshot!.documents.count != 1 {
                                         print("More than one documents or none")
                                 } else {
                                     let document = querySnapshot!.documents.first
                                     document!.reference.updateData([
                                       "cue4": true
                                        
                                     ])
                                 }
                         }


                 cue4.setOn(true, animated:true)
             } else {
                 
                 self.db.collection("patients")
                             .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                             .getDocuments() { (querySnapshot, error) in
                                 if let error = error {
                                         print(error.localizedDescription)
                                 } else if querySnapshot!.documents.count != 1 {
                                         print("More than one documents or none")
                                 } else {
                                     let document = querySnapshot!.documents.first
                                     document!.reference.updateData([
                                       "cue4": false
                                        
                                     ])
                                 }
                         }


                 cue4.setOn(false, animated:true)
             }

    }
    @IBAction func cue5pressed(_ sender: Any) {
        if cue5.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue5": true
                                   
                                ])
                            }
                    }


            cue5.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue5": false
                                   
                                ])
                            }
                    }


            cue5.setOn(false, animated:true)
        }
    }
    @IBAction func cue6pressed(_ sender: Any) {
        if cue6.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue6": true
                                   
                                ])
                            }
                    }


            cue6.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue6": false
                                   
                                ])
                            }
                    }


            cue6.setOn(false, animated:true)
        }
    }
    @IBAction func cue7pressed(_ sender: Any) {
        if cue7.isOn {


            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue7": true
                                   
                                ])
                            }
                    }


            cue7.setOn(true, animated:true)
        } else {
            
            self.db.collection("patients")
                        .whereField("uid", isEqualTo :UserDefaults.standard.string(forKey: Constants.selectedPatient))
                        .getDocuments() { (querySnapshot, error) in
                            if let error = error {
                                    print(error.localizedDescription)
                            } else if querySnapshot!.documents.count != 1 {
                                    print("More than one documents or none")
                            } else {
                                let document = querySnapshot!.documents.first
                                document!.reference.updateData([
                                  "cue7": false
                                   
                                ])
                            }
                    }


            cue7.setOn(false, animated:true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
