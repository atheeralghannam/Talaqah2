//
//  ResetPasswordViewController.swift
//  Talaqah
//
//  Created by Haneen Abdullah on 21/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var resetPasswordLabel: UILabel!
    @IBOutlet weak var resetTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    var validation = Validation()
    
    var mail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpElements()
    }
    
    
    @IBAction func ResetPasswordTapped(_ sender: Any) {
        guard
            //
            let email = resetTextField.text
            else {
                return
        }
        
        if resetTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
                              showError("الرجاء إدخال بريد إلكتروني")
            return
        }
        
        let isValidateEmail = self.validation.validateEmailId(emailID: email)
        if (isValidateEmail == false) {
            print("Incorrect Email")
//            self.showToast(message: "Incorrect Email", font: UIFont(name: "Times New Roman", size: 12.0)!)
//            resetTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                showError("لا يوجد مستخدم بهذا البريد الإلكتروني") 
            return
        }
        Auth.auth().sendPasswordReset(withEmail: self.resetTextField.text!) { error in
            if error != nil {
                print("email is wrong")
//                self.showToast(message: "email is wrong.", font: UIFont(name: "Times New Roman", size: 12.0)!)
                self.showError("تحقق من إدخال بريد إلكتروني صحيح")

            } else {
                print("Password reset email sent.")
//                self.showToast(message: "Password reset email sent.", font: UIFont(name: "Times New Roman", size: 12.0)!)
                self.errorLabel.alpha = 0
                // create the alert
                 let alert = UIAlertController(title: "تم إرسال رابط إعادة تعيين كلمة المرور لبريدك الإلكتروني بنجاح.", message: "فضلًا تحقق من بريدك الإلكتروني", preferredStyle: UIAlertController.Style.alert)
                 
                 // add an action (button)
                 alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
                 
                 // show the alert
                 self.present(alert, animated: true, completion: nil)
                // Password reset email sent.
                
//                //if - else
//                 if (UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) == true){
//                    self.performSegue(withIdentifier: "toPatient", sender: nil)}
//                 if (UserDefaults.standard.bool(forKey: Constants.isSlpLoggedIn) == true){
//                self.performSegue(withIdentifier: "toSLP", sender: nil)
//                }

                

                
                
            }
        }
    }
    
    func SetUpElements () {
        // Hide the error label
         errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleHeaderLabel(label: resetPasswordLabel)
        Utilities.styleTextField(textfield: resetTextField)
        Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleFilledButton(button: resetButton)
        
    }
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
    
    func showError(_ message:String) {
         
         errorLabel.text = message
         errorLabel.alpha = 1
         print(message)
     }
}
