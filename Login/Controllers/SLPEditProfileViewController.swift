//
//  SLPEditProfileViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 17/07/1441 AH.
//  Copyright © 1441 Talaqah. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SLPEditProfileViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var slpFname: UITextField!
    @IBOutlet weak var slpLname: UITextField!
    @IBOutlet weak var slpHospital: UITextField!
    @IBOutlet weak var slpPhone: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let db = Firestore.firestore()
    var validation = Validation()
    var isNewEmail1 = false
    var isNewEmail2 = false
 
    
    @IBOutlet weak var gender: UIImageView!
    
    
    var  fName = String(), lName = String(), phoneNumber = String(), sHospital=String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gend = UserDefaults.standard.string(forKey: Constants.sGender)
        if gend == "female"{
            self.gender.image = #imageLiteral(resourceName: "fdoctor")
        }else {
            self.gender.image = #imageLiteral(resourceName: "mdoctor")
        }
        
        SetUpElements()
        
        // Do any additional setup after loading the view.
        loadProfileData()
        
        slpLname.delegate = self
        slpFname.delegate = self
        slpPhone.delegate = self
        slpHospital.delegate = self
        
    }
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    func SetUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        
        Utilities.styleErrorLabel(label: errorLabel)
        
        slpPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        slpPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    
    func validateFields()  -> Bool?  {
        
        
        
        // Get text input from TextField
        
        
        // Check that all fields are filled in
        if slpLname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpFname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpHospital.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            
            showError("الرجاء التحقق من تعبئة جميع الحقول")
            //                return ""
           return false
        }
        
        
        let isValidName=self.validation.validateName(name: slpFname.text!) &&  self.validation.validateName(name: slpLname.text!)
        
        if isValidName==false {
            showError("الرجاء التحقق من إدخال اسم")
              return false
        }
        
        let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: slpPhone.text!)
        
        if isValidPhone==false {
            showError("الرجاء التحقق من إدخال رقم صحيح : ********05")
             return false}
        
        return true
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if(validateFields()!){
            editUsersProfile()
        }
    }
    
    
    
    func loadProfileData(){
        
        
        
        self.slpFname.text =  UserDefaults.standard.string( forKey: Constants.slpfName)
        self.slpLname.text =  UserDefaults.standard.string( forKey: Constants.slplName)
        self.slpPhone.text =  UserDefaults.standard.string( forKey: Constants.slpphone)
        self.slpHospital.text = UserDefaults.standard.string( forKey: Constants.slpHospital)
    }// end of load
    
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func editUsersProfile(){
        
        
        
        
        
        
        
        
        
        self.errorLabel.alpha = 0
        
        
        let alertView = SCLAlertView()
        
        alertView.addButton("نعم") {
            
            guard let newfname  = self.slpFname.text else {return}
            guard let newlname  = self.slpLname.text else {return}
            //   guard let newemail = self.slpEmail.text else {return}
            guard let newmobile  = self.slpPhone.text else {return}
            
            
            guard let newhospital  = self.slpHospital.text else {return}
            
            self.db.collection("slps")
                .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if querySnapshot!.documents.count != 1 {
                        print("More than one documents or none")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "fname": newfname,
                            "lname": newlname,
                            //"email":newemail,
                            "phone":newmobile,
                            "hospital":newhospital
                        ])
                        
                        
                        
                        
                    }
            }
            
            SCLAlertView().showCustom("تم الحفظ", subTitle: "تم حفظ تغييراتك بنجاح!", color: UIColor(named: "Done")! , icon: UIImage(named: "saved")!, closeButtonTitle: "حسنًا")
            
            
            
        }
        alertView.showWarning( "حفظ التغييرات", subTitle: "هل أنت متأكد من أنك تريد حفظ التغييرات؟", closeButtonTitle: "لا")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        slpPhone.resignFirstResponder()
        
    }
    
}


