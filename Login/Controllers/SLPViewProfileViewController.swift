//
//  SLPViewProfileViewController.swift
//  Talaqah
//
//  Created by Haneen Abdullah on 25/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SLPViewProfileViewController:  UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var slpFnameLabel: UILabel!
    @IBOutlet weak var slpLnameLabel: UILabel!
    @IBOutlet weak var slpHospitalLabel: UILabel!
    @IBOutlet weak var slpPhoneLabel: UILabel!
    @IBOutlet weak var slpEmailLabel: UILabel!
    
    
    @IBOutlet weak var slpFname: UITextField!
    @IBOutlet weak var slpLname: UITextField!
    @IBOutlet weak var slpHospital: UITextField!
    @IBOutlet weak var slpPhone: UITextField!
    @IBOutlet weak var slpEmail: UITextField!
    
    
    
    let db = Firestore.firestore()
    var validation = Validation()
    
    
    var sEmail=String(), fName = String(), lName = String(), phoneNumber = String(), sHospital=String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpElements()
        
        // Do any additional setup after loading the view.
        loadProfileData()
        
        slpLname.delegate = self
        slpFname.delegate = self
        slpPhone.delegate = self
        slpEmail.delegate = self
        slpHospital.delegate = self
        
    }
    
    func SetUpElements() {
        
        
        // Style the elements
        //style labels
        Utilities.styleLabel(label: slpFnameLabel)
        Utilities.styleLabel(label: slpLnameLabel)
        Utilities.styleLabel(label: slpHospitalLabel)
        Utilities.styleLabel(label: slpPhoneLabel)
        Utilities.styleLabel(label: slpEmailLabel)
        
        
        //style textfields
        Utilities.styleSecondaryTextField(textfield: slpLname)
        Utilities.styleSecondaryTextField(textfield: slpFname)
        Utilities.styleSecondaryTextField(textfield: slpPhone)
        Utilities.styleSecondaryTextField(textfield: slpEmail)
        Utilities.styleSecondaryTextField(textfield: slpHospital)
        
        
    }
    
    
    
    
    
    func loadProfileData(){
        
        
        db.collection("slps").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments {(snapshot, error) in
            if let error = error{print(error.localizedDescription)}
            else {
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        let data = document.data()
                        
                        self.sEmail = data["email"] as! String
                        self.fName = data["fname"] as! String
                        self.lName = data["lname"] as!String
                        self.phoneNumber = data["phone"] as! String
                        self.sHospital = data["hospital"] as! String
                        
                        
                        
                        self.slpEmail.text = self.sEmail
                        self.slpFname.text = self.fName
                        self.slpLname.text = self.lName
                        self.slpPhone.text = self.phoneNumber
                        self.slpHospital.text = self.sHospital
                    }}}}
    }// end loadProfileData()
    
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        slpPhone.resignFirstResponder()
    //
    //    }
    
    
}
