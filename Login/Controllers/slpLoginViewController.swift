//
//  slpLoginViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 07/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
class slpLoginViewController: UIViewController {
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var haveAccount: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var slpregisterButton: UIButton!
    @IBOutlet var slploginButton: UIButton!
    var validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isLogin()
        setUpElements()
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
//
              guard
                  let email = emailTextfield.text,
                  let password = passwordTextfield.text

                  else {
                      return
              }

        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        } //end if
        else {
                        
            
            
            Firestore.firestore().collection("slps").whereField("email", isEqualTo:emailTextfield.text!).getDocuments {
                                         (snapshot, error) in
                                                 if let error = error {
                                    print(error.localizedDescription)
                                                           }
                                                 else if snapshot!.documents.count == 0 {

                                                 self.showError("البريد الإلكتروني أو كلمة المرور غير صحيحة")

                                                                           }
                                                 else{
                                             
                                                    Auth.auth().signIn(withEmail:email , password:password){ (user, error) in

                                                          
                                                          
                                                          if user != nil {
                                                              // Couldn't sign in
                                                              //                self.errorLabel.text = error!.localizedDescription
                                                              //                self.errorLabel.alpha = 1
                                                              print("user has signed in")
                                                              UserDefaults.standard.set(true, forKey:Constants.isSlpLoggedIn)
                                                              UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: Constants.userUid)
                                                            
                                                            self.errorLabel.alpha = 0

                                                              //                                        UserDefaults.standard.synchronize()
                                                              self.performSegue(withIdentifier: "toSLPhome", sender: nil)
                                                          }
                                                          else {
                                                              if error != nil{
                                                                  print(error.debugDescription)
                                                                self.showError("البريد الإلكتروني أو كلمة المرور غير صحيحة")
                                                                  
                                                              }
                                                          }
                                                          
                                                      }


                                                    
                         }
                                         }
            
            
            
            

                          
                          //}
                      }
              
    }
              
              
              // Signing in the user
              
    
    
    func isLogin (){
        print(  UserDefaults.standard.bool(forKey: "slpLogin"))
        //        // Do any additional setup after loading the view, typically from a nib.
        if(UserDefaults.standard.bool(forKey: "slpLogin") == true){
            //           self.performSegue(withIdentifier: "toHome", sender: nil)
            print("Session is saved")
            //
            //
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
    func setUpElements() {
        
        // Hide the error label
        //           errorLabel.alpha = 0
        errorLabel.alpha = 0

        // Style the elements
        Utilities.styleTextField(textfield: emailTextfield)
        Utilities.styleTextField(textfield: passwordTextfield)
        Utilities.styleFilledButton(button: slploginButton)
        Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleLabel(label: haveAccount)
        Utilities.styleSecondaryButton(button: forgetPassword)
        Utilities.styleSecondaryButton(button: slpregisterButton)
        
 
    }
    @IBAction func slploginTapped(_ sender: Any) {
              self.performSegue(withIdentifier: "toRegisterSlp", sender: nil)
    }
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
    
    
    
    func validateFields() -> String? {

        
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            
            //            return "Please fill in all fields."
            return "الرجاء التحقق من تعبئة جميع الحقول"
        }
        
        
        
        let isValidEmail=self.validation.validateEmailId(emailID: emailTextfield.text!)
        

        
        if isValidEmail==false {
//            return "الرجاء التحقق من إدخال بريد إلكتروني صحيح"
            return "البريد الإلكتروني أو كلمة المرور غير صحيحة"
            //            return "Please enter valid phone: 05********"
        }
        
                // Check if the password is secure
                let isValidatePass = self.validation.validatePassword( password:  passwordTextfield.text!)
                
            
                if isValidatePass == false {
                    // Password isn't secure enough
                    return "البريد الإلكتروني أو كلمة المرور غير صحيحة"

//                    return "كلمة المرور يجب أن تحتوي على الأقل ستة أحرف وأرقام"
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
