//
//  SlpRegisterViewController.swift
//  Talaqah
//
//  Created by Haneen Abdullah on 03/03/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SlpRegisterViewController: UIViewController, UITextFieldDelegate {
    
    var validation = Validation()
    var gender = "male"
    
 
    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var hospitalNameTextField: UITextField!
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var haveAccount: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpElements()
    }//end viewDidLoad()
    
    
    //may not needed
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        
    }//end awakeFromNib()
    
    
    func SetUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: firstNameTextField)
        Utilities.styleTextField(textfield: lastNameTextField)
        Utilities.styleTextField(textfield: hospitalNameTextField)
        Utilities.styleTextField(textfield: emailTextField)
        Utilities.styleTextField(textfield: phoneNumberTextField)
        Utilities.styleTextField(textfield: passwordTextField)
        Utilities.styleTextField(textfield: confirmPasswordTextField)
        Utilities.styleFilledButton(button: registerButton)
        Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleLabel(label: haveAccount)
        Utilities.styleSecondaryButton(button: loginButton)
        //setup limit inputs length
        
        phoneNumberTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        phoneNumberTextField.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }//end SetUpElements()
    
    
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
   self.performSegue(withIdentifier: "ToLoginSlp", sender: nil)
    }//end loginTapped()
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Get text input from TextField
        guard
            let password=passwordTextField.text
            
            else {
                return nil}
        
        let confirmPassword = confirmPasswordTextField.text
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            //            return "Please fill in all fields."
            return "الرجاء التحقق من تعبئة جميع الحقول"
        } //end if
        
        
        
        
        // Check if the password is secure
        let isValidatePass = self.validation.validatePassword( password: password)
        let isMatchedPass=(password==confirmPassword)
        
        let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!)
        
        
        
        if isValidatePass == false {
            // Password isn't secure enough
            return "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام"
            //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        } //end if
        if isMatchedPass==false{
            return "تأكيد كلمة المرور يجب أن تتطابق مع كلمة المرور المدخلة"
            //            return "Please make sure your password and its confirm are both same."
            
        } //end if
        
        
        if isValidPhone==false {
            return "الرجاء التحقق من إدخال رقم صحيح : ********05"
            //            return "Please enter valid phone: 05********"
        }
        
        return nil
    } //end validateFields()
    
    
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    } //end showError()
    
    
    

    @IBAction func RegisterTapped(_ sender: Any) {
    // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        } //end if
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let hospitalName = hospitalNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    // check if email is already registered
                    Auth.auth().fetchSignInMethods(forEmail: email, completion: {
                        (providers, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.showError("خطأ في تسجيل المستخدم !")
                            //                            self.showError("Error creating user")
                            print("Error creating user")
                        } else if let providers = providers {
                            self.showError("هذا البريد الإلكتروني مسجل مسبقًا")
                            //                            self.showError("Email already exists")
                            print("Email already exists")
                            print(providers)
                        }
                    })
                    // There was an error creating the user
                    //                                        self.showError("Error creating user")
                    //                                        print("Error creating user")
                } //end big if
                else {
                    
                    // store SLP on DB
//                    let db = Firestore.firestore()
//                    db.collection("slps").addDocument(data: [ "FirstName":firstName, "LastName":lastName, "Email":email, "PhoneNumber": phone, "HospitalName": hospitalName, "uid": result!.user.uid ]) { (error) in
//
                        let db = Firestore.firestore()
                        db.collection("slps").addDocument(data: [ "fname":firstName, "lname":lastName, "email":email, "phone": phone, "uid": result!.user.uid ]) { (error) in
                            
                        
                        if error != nil {
                            // Show error message
                            self.showError("خطأ في حفظ بيانات المستخدم !")
                            //                             self.showError("Error saving user data")
                            print("Error saving user data")
                        } //end inner if
                    } //end addDocument
                    
                    // Transition to the home screen
                    //
                    self.performSegue(withIdentifier: "toStartSlp", sender: nil)
                } //end else
                
            } //end createUser
            
            
        } //end big else
    } //end RegisterTapped()
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let maxLength : Int
        
        if textField == phoneNumberTextField {
            maxLength = 10
        }
        else {
            maxLength = 100
        }
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    } //end textField()
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    } //end viewWillAppear()
    
    override open var shouldAutorotate: Bool {
        return false
    } //end shouldAutorotate()
    
    
}//end controller
