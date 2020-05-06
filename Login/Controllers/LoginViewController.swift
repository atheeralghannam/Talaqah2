//
//  ViewController.swift
//  LoginExample
//
//  Created by Talaqah on 3/10/19.
//  Copyright © 2019 Talaqah. All rights reserved.
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
        isLogin()
        setUpElements()
    }
    
    func isLogin (){
        print(  UserDefaults.standard.bool(forKey: "userLogin"))
        if(UserDefaults.standard.bool(forKey: "userLogin") == true){
            print("Session is saved")
     
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
 }
      
    @IBAction func loginF(_ sender: Any) {
        
        idTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        guard
            //            let name = validateNameTxtFld.text,
            let _ = idTextField.text,
            let _ = passwordTextField.text
        
            else {
                return
        }
    
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        } //end if
        else {
            
            let db = Firestore.firestore()
            
            db.collection("patients").whereField("NID", isEqualTo: idTextField.text!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    } else if querySnapshot!.documents.count != 1 {
                        self.showError("رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة")
                        return
                            print("More than one documents or none")
                    } else {
                        
                        for document in querySnapshot!.documents {
                            self.mail = document.data()["Email"] as! String
                            print( self.mail)
                            
                            Auth.auth().signIn(withEmail: self.mail.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordTextField.text!) { (user, error) in
                                if user != nil {
                                    print("user has signed in")
                                    self.errorLabel.alpha = 0
                                    UserDefaults.standard.set(true, forKey:Constants.isUserLoggedIn)
                                    UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: Constants.userUid)
                                    
                                    //                                        UserDefaults.standard.synchronize()
                                    self.performSegue(withIdentifier: "toHome", sender: nil)
                                }
                                else {
                                
                                }
                                
                            }
             
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

            print(error)

            return "رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة"

        }
        
        
        
        // Check if the password is secure
        let isValidatePass = self.validation.validatePassword( password:  passwordTextField.text!)
        
        
        if isValidatePass == false {
           
            return "رقم الهوية/ الإقامة أو كلمة المرور غير صحيحة"
       
        } //end if
        
        return nil
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            let destnationVC = segue.destination as! BaseViewController
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
}
