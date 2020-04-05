//
//  ViewController.swift
//  LoginExample
//
//  Created by Gary Tokman on 3/10/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPasswordLabel: UIButton!
    @IBOutlet weak var haveAccount: UILabel!
    @IBOutlet weak var registerButton: UIButton!

     
    @IBOutlet var errorLabel: UILabel!
    
    var validation = Validation()
    
    var mail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("what???")
        isLogin()
        setUpElements()
        
    }
    
    func isLogin (){
        print(  UserDefaults.standard.bool(forKey: "userLogin"))
        //        // Do any additional setup after loading the view, typically from a nib.
        if(UserDefaults.standard.bool(forKey: "userLogin") == true){
            //           self.performSegue(withIdentifier: "toHome", sender: nil)
            print("Session is saved")
            //
            //
        }
        
    }
    
    @IBAction func loginF(_ sender: Any) {
        
        
        
        guard
            //            let name = validateNameTxtFld.text,
            let id = idTextField.text,
            let password = passwordTextField.text
            //,
            //        let phone = validatePhoneTxtFld.text
            else {
                return
        }

//        // how to use
//        do {
//            let resutl = try ValidateSAID.check(id)
//
//            // this will print NationaltyType description
//            print(resutl)
//        } catch {
//            // this will print error description
//            print(error)
//            self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
//            idTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
//        }
//
//
//
//        let isValidatePass = self.validation.validatePassword(password: password)
//        if (isValidatePass == false) {
//            print("Incorrect Pass")
////            self.showToast(message: "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام", font: UIFont(name: "Times New Roman", size: 12.0)!)
//                        self.showToast(message: "كلمة المرور يجب أن تحتوي على الأقل ستة أحرف وأرقام", font: UIFont(name: "Times New Roman", size: 12.0)!)
//            passwordTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
//
//            return
//        }
//
//        if (isValidatePass == true ) {
//            print("All fields are correct")
//        }
        let error = validateFields()
            
            if error != nil {
                
                // There's something wrong with the fields, show error message
                showError(error!)
            } //end if
            else {
        
        let db = Firestore.firestore()
        
        db.collection("patients").whereField("NID", isEqualTo: idTextField.text!)
            .getDocuments() { (querySnapshot, err) in
                //                 if let err = err {
                //                     print("Error getting documents: \(err)")
                //                 } else {
                
                
                if let err = err {
                                        print(err.localizedDescription)
                                    } else if querySnapshot!.documents.count != 1 {
                    self.showError("رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة")
                    return
                                        print("More than one documents or none")
                                    } else {
                    
                for document in querySnapshot!.documents {
                    //                         print("\(document.documentID) => \(document.data())")
                    
                    
                    //                        let data = document.data()
                    self.mail = document.data()["Email"] as! String
                    print( self.mail)
                    
                    Auth.auth().signIn(withEmail: self.mail.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordTextField.text!) { (user, error) in

                        
                        
                        if user != nil {
                            // Couldn't sign in
                            //                self.errorLabel.text = error!.localizedDescription
                            //                self.errorLabel.alpha = 1
                            print("user has signed in")
                            self.errorLabel.alpha = 0
                            UserDefaults.standard.set(true, forKey:Constants.isUserLoggedIn)
                            UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: Constants.userUid)
                            
                            //                                        UserDefaults.standard.synchronize()
                            self.performSegue(withIdentifier: "toHome", sender: nil)
                        }
                        else {
//
//                            if error != nil{
//                                print(error.debugDescription)
//
//                            }
                        }
                        
                    }
                    
                    //}
                }
        }
        
        
        
        }   // Signing in the user
        
    }
    }
    
    

   
    func setUpElements() {
        
        // Hide the error label
                   errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: idTextField)
        Utilities.styleTextField(textfield: passwordTextField)
        Utilities.styleFilledButton(button: loginButton)
        Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleLabel(label: haveAccount)
        Utilities.styleSecondaryButton(button: forgetPasswordLabel)
        Utilities.styleSecondaryButton(button: registerButton)
        
        
        // limit input length of id
        idTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        idTextField.delegate = self
        
    }
    
    //check enter only 10 digits for nId
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let maxLength : Int

        if textField == idTextField {
             maxLength = 10
        }
        else{
             maxLength = 50
        }
        
      let currentString: NSString = textField.text! as NSString
                  
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
}
 // ------------for disable rotate > portrait view only
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func validateFields() -> String? {

        
        if idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            
            //            return "Please fill in all fields."
            return "الرجاء التحقق من تعبئة جميع الحقول"
        }
        
        
        
        // how to use
        do {
            let resutl = try ValidateSAID.check(idTextField.text!)
            
            // this will print NationaltyType description
            print(resutl)
        } catch {
            // this will print error description
            print(error)
//            self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
//            return "رقم الهوية/الإقامة غير صالح"
            return "رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة"
//            idTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
        }

        

                // Check if the password is secure
                let isValidatePass = self.validation.validatePassword( password:  passwordTextField.text!)
                
            
                if isValidatePass == false {
                    // Password isn't secure enough
//                    return "كلمة المرور يجب أن تحتوي على الأقل ستة أحرف وأرقام"
                    return "رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة"

        //            return "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام"
                    //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
                } //end if

        return nil
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    
}
