//
//  editprofileViewController.swift
//  Login
//
//  Created by rawan almajed on 22/06/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

//
//  editprofileViewController.swift
//  Talaqah
//
//  Created by rawan almajed on 11/06/1441 AH.
//  Copyright © 1441 Muhailah AlSahali. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class editprofileViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate{
    
    let db = Firestore.firestore()
    
    private var document:[DocumentSnapshot] = []
    
    var pEmail=String(), fName = String(), lName = String(), pGender = String(),pnID = String(), phoneNumber = String()
    
    @IBOutlet weak var errorLabel: UILabel!
    var validation = Validation()
    
    var gender = String()
    var isSave = false
    @IBOutlet weak var PatientImage: UIImageView!
    @IBOutlet var natId: UITextField!
    //    @IBOutlet var uemail: UITextField!
    @IBOutlet var umobile: UITextField!
    @IBOutlet var funame: UITextField!
    @IBOutlet var luname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpElements()

        if UserDefaults.standard.string(forKey: "pGender") == "female"{
            PatientImage.image = #imageLiteral(resourceName: "female")
        }else{
            PatientImage.image = #imageLiteral(resourceName: "male")
        }
        loadProfileData()
        
        
        
        // Do any additional setup after loading the view.
        
        funame.delegate = self
        luname.delegate = self
        // age.delegate = self
        // gender.delegate = self
        natId.delegate = self
        umobile.delegate = self
        //   uemail.delegate = self
        
    }
    
    func SetUpElements() {
            
            // Hide the error label
            errorLabel.alpha = 0
            
            // Style the elements
            Utilities.styleTextField(textfield: funame)
            Utilities.styleTextField(textfield: luname)
            Utilities.styleTextField(textfield: umobile)
         //   Utilities.styleTextField(textfield: slpEmail)
            Utilities.styleTextField(textfield: natId)
                  Utilities.styleErrorLabel(label: errorLabel)
            self.natId.isEnabled=false
            umobile.smartInsertDeleteType = UITextSmartInsertDeleteType.no
            umobile.delegate = self
            
            
            //todo set up genderSegmented Style
            
        }
        
        func showError(_ message:String) {
            
            errorLabel.text = message
            errorLabel.alpha = 1
            print(message)
        }
        
            func validateFields() -> Bool? {
                
                
                
                // Get text input from TextField
                
                
                // Check that all fields are filled in
                if luname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                    funame.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                    umobile.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                    //||
        //            slpEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
    //                slpHospital.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                    {
                    
                    //            return "Please fill in all fields."
                        
                        showError("الرجاء التحقق من تعبئة جميع الحقول")
        //                return ""
                    return false
                }

                let isValidName=self.validation.validateName(name: funame.text!) &&  self.validation.validateName(name: luname.text!)
                       
                       if isValidName==false {
                        showError("الرجاء التحقق من إدخال اسم")
        //                             return ""
                           return false
                       }
                
                let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: umobile.text!)
                
                if isValidPhone==false {
                           showError("الرجاء التحقق من إدخال رقم صحيح : ********05")
                    return false}

        //        let isValidEmail=self.validation.validateEmailId(emailID: slpEmail.text!)
                
        //        if isValidEmail==false {
        //            showError("الرجاء التحقق من إدخال بريد إلكتروني صحيح")
        //
        //            return "الرجاء التحقق من إدخال بريد إلكتروني صحيح"
        //            //            return "Please enter valid phone: 05********"
        //        }
                
        //        if (isNewEmail1() && isNewEmail2()){
        //            print("")
        //        }
        //        else{
        //            return "هذا البريد الإلكتروني مستخدم من شخص آخر"
        //
        //        }
               
                return true

            }
    
    @IBAction func SaveProfileData(_ sender: Any) {  if(validateFields()!){
                  errorLabel.alpha = 0
              editUsersProfile()
          }
    }
    
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            let destnationVC = segue.destination as! AccountViewController
            destnationVC.gender = pGender
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
    
    func editUsersProfile(){
        
        guard let newfname  = self.funame.text else {return}
        guard let newlname  = self.luname.text else {return}
        //            guard let newemail = self.uemail.text else {return}
        guard let newidnum  = self.natId.text else {return}
        guard let newmobile  = self.umobile.text else {return}
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
                        "FirstName": newfname,
                        "LastName": newlname,
                        //                       "Email":newemail,
                        "NID": newidnum,
                        "PhoneNumber":newmobile
                        
                    ])
                    
                }
        }
        SCLAlertView().showCustom("تم الحفظ", subTitle: "تم حفظ تغييراتك بنجاح!", color: UIColor(named: "Done")! , icon: UIImage(named: "saved")!, closeButtonTitle: "حسنًا")
        isSave = true
    }
    

    
    //
    func loadProfileData(){
        //if the user is logged in get the profile data
        
        db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments {(snapshot, error) in
            if let error = error{print(error.localizedDescription)}
            else {
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        let data = document.data()
                        
                        //create a dictionary of users profile data
                        //   let values = snapshot.value as? NSDictionary
                        self.pEmail = data["Email"] as! String
                        self.fName = data["FirstName"] as! String
                        self.lName = data["LastName"] as!String
                        
                        
                        
                        self.pGender = data["Gender"] as! String
                        self.pnID = data["NID"] as! String
                        self.phoneNumber = data["PhoneNumber"] as! String
                        
                        
                        
                        //            self.uemail.text = self.pEmail
                        self.funame.text = self.fName
                        self.luname.text = self.lName
                        //   self.gender.text = self.pGender
                        self.natId.text = self.pnID
                        self.umobile.text = self.phoneNumber
                    }}}}
    }// end of load
    
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
}
