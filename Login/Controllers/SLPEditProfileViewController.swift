//
//  SLPEditProfileViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 17/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase


class SLPEditProfileViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var slpFname: UITextField!
    @IBOutlet weak var slpLname: UITextField!
    @IBOutlet weak var slpHospital: UITextField!
    @IBOutlet weak var slpPhone: UITextField!
    @IBOutlet weak var slpEmail: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let db = Firestore.firestore()
    var validation = Validation()
    var isNewEmail1 = false
    var isNewEmail2 = false
//    let myGroup = DispatchGroup()

        
    
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
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    func SetUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: slpLname)
        Utilities.styleTextField(textfield: slpFname)
        Utilities.styleTextField(textfield: slpPhone)
        Utilities.styleTextField(textfield: slpEmail)
        Utilities.styleTextField(textfield: slpHospital)
              Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleFilledButton(button: saveButton)
        
        slpPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        slpPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    
    func validateFields() -> String? {
        
        
        
        // Get text input from TextField
        
        
        // Check that all fields are filled in
        if slpLname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpFname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            slpHospital.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            
            //            return "Please fill in all fields."
                
                showError("الرجاء التحقق من تعبئة جميع الحقول")
//                return ""
            return "الرجاء التحقق من تعبئة جميع الحقول"
        }
        
        
        
        defer {
        
                   db.collection("slps").whereField("email", isEqualTo:slpEmail.text!).getDocuments {
                    (snapshot, error) in
                            if let error = error {
               print(error.localizedDescription)
                                      }

                            else {
                                for document in snapshot!.documents {

                            if(document.data()["uid"] as! String == Auth.auth().currentUser!.uid){
                                UserDefaults.standard.set(true,forKey: Constants.isNewEmail1)
                                self.isNewEmail1=true


                                print("my self")

                            }
                            else{
                                UserDefaults.standard.set(false,forKey: Constants.isNewEmail1)
                                self.isNewEmail1=false
                                print("not unique in slps")
                                return

                                                           }

                                                                                                        }
                        }
                    }
        }
                       
        defer {
        
        db.collection("patients").whereField("Email", isEqualTo:slpEmail.text!).getDocuments {
                            (snapshot, error) in
                                    if let error = error {
                       print(error.localizedDescription)
                                              }
                                    else if snapshot!.documents.count != 0 {

                                        print("not unique in patients")

                                        UserDefaults.standard.set(false,forKey: Constants.isNewEmail2)
                                        self.isNewEmail2=false
                                                              }
                                    else{
                                        UserDefaults.standard.set(true,forKey: Constants.isNewEmail2)
                                        self.isNewEmail2=true


                                        print(" unique in patients")

            }
                            }
            
        }
        
        let isValidName=self.validation.validateName(name: slpFname.text!) &&  self.validation.validateName(name: slpLname.text!)
               
               if isValidName==false {
                showError("الرجاء التحقق من إدخال اسم")
//                             return ""
                   return "الرجاء التحقق من إدخال اسم"
               }
        
        let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: slpPhone.text!)
        
        if isValidPhone==false {
                   showError("الرجاء التحقق من إدخال رقم صحيح : ********05")
            return "الرجاء التحقق من إدخال رقم صحيح : ********05"}

        let isValidEmail=self.validation.validateEmailId(emailID: slpEmail.text!)
        
        if isValidEmail==false {
            showError("الرجاء التحقق من إدخال بريد إلكتروني صحيح")

            return "الرجاء التحقق من إدخال بريد إلكتروني صحيح"
            //            return "Please enter valid phone: 05********"
        }
        
//        if (isNewEmail1() && isNewEmail2()){
//            print("")
//        }
//        else{
//            return "هذا البريد الإلكتروني مستخدم من شخص آخر"
//
//        }
       
        return nil

    }

    
    
    
    
    
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
//    UserDefaults.standard.set(true,forKey: Constants.isNewEmail1)
//          UserDefaults.standard.set(true,forKey: Constants.isNewEmail2)
               defer {
        validateFields()
                }
//        defer {
//             validateFields()
//                     }
        defer {
            editUsersProfile()
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
    }// end of load
    
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func editUsersProfile(){
        
//        myGroup.enter()
// Validate the fields
        
 
        
            print("isNewEmail1")
        print(isNewEmail1)
                                       print(UserDefaults.standard.bool(forKey: Constants.isNewEmail1))
            print("isNewEmail2")
        print(isNewEmail2)


            print(UserDefaults.standard.bool(forKey: Constants.isNewEmail2))

                        if isNewEmail1 == false {
                            showError("هذا البريد الإلكتروني مستخدم من شخص آخر")
                            return

//                                              return "هذا البريد الإلكتروني مستخدم من شخص آخر"
                                  //            return "Please enter valid phone: 05********"
                                          }

            if isNewEmail2 == false {
                showError("هذا البريد الإلكتروني مستخدم من شخص آخر")

                return
//                                  return "هذا البريد الإلكتروني مستخدم من شخص آخر"
                      //            return "Please enter valid phone: 05********"
                              }
            
            
            
           
            

            
            
            
            
        
            self.errorLabel.alpha = 0
                                 
                                 
                                 
                                 let refreshAlert = UIAlertController(title: "حفظ التغييرات", message:"هل أنت متأكد من أنك تريد حفظ التغييرات؟", preferredStyle: UIAlertController.Style.alert)
                                 
                                 refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                                     
                                     
                                     
                                     guard let newfname  = self.slpFname.text else {return}
                                     guard let newlname  = self.slpLname.text else {return}
                                     guard let newemail = self.slpEmail.text else {return}
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
                                                     "email":newemail,
                                                     "phone":newmobile,
                                                     "hospital":newhospital
                                                 ])
                                                 
                                                 
                                                 Auth.auth().currentUser?.updateEmail(to: newemail) { (error) in
                                                     // ...
                                                     print("succusess update email in firebase!!!")
                                                     print(error?.localizedDescription)
                                                 }
                                                 
                                                 
                                                 
                                                 //
                                                 
                                             }
                                     }
                          
                                     var refreshAlert = UIAlertController(title: "تم حفظ التغييرات بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)
                                     
                                     refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                         print("Handle Ok logic here")
                                         
                                     }))
                                     
                                     
                                     
                                     self.present(refreshAlert, animated: true, completion: nil)
                                     
                                     
                                     
                                 }))
                                 
                                 refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
                                     print("Handle Cancel Logic here")
                                 }))
                                 
                                 self.present(refreshAlert, animated: true, completion: nil)
//let error = validateFields()
        
        
//        myGroup.leave()
//let error2 = !isNewEmail1() || !isNewEmail2()
//
//        if(error2){
//
//
//        }
        
//        myGroup.notify(queue: DispatchQueue.main) {
//            if error != nil {
//
//                      // There's something wrong with the fields, show error message
//                self.showError(error!)
//                  }
//            else if (error2){
//
//                self.showError( "هذا البريد الإلكتروني مستخدم من شخص آخر")
//            }
            //      else {
//                      self.errorLabel.alpha = 0
//
//
//
//                      let refreshAlert = UIAlertController(title: "حفظ التغييرات", message:"هل أنت متأكد من أنك تريد حفظ التغييرات؟", preferredStyle: UIAlertController.Style.alert)
//
//                      refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
//
//
//
//                          guard let newfname  = self.slpFname.text else {return}
//                          guard let newlname  = self.slpLname.text else {return}
//                          guard let newemail = self.slpEmail.text else {return}
//                          guard let newmobile  = self.slpPhone.text else {return}
//
//
//                          guard let newhospital  = self.slpHospital.text else {return}
//
//                          self.db.collection("slps")
//                              .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
//                              .getDocuments() { (querySnapshot, error) in
//                                  if let error = error {
//                                      print(error.localizedDescription)
//                                  } else if querySnapshot!.documents.count != 1 {
//                                      print("More than one documents or none")
//                                  } else {
//                                      let document = querySnapshot!.documents.first
//                                      document!.reference.updateData([
//                                          "fname": newfname,
//                                          "lname": newlname,
//                                          "email":newemail,
//                                          "phone":newmobile,
//                                          "hospital":newhospital
//                                      ])
//
//
//                                      Auth.auth().currentUser?.updateEmail(to: newemail) { (error) in
//                                          // ...
//                                          print("succusess update email in firebase!!!")
//                                          print(error?.localizedDescription)
//                                      }
//
//
//
//                                      //
//
//                                  }
//                          }
//
//                          var refreshAlert = UIAlertController(title: "تم حفظ التغييرات بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)
//
//                          refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
//                              print("Handle Ok logic here")
//
//                          }))
//
//
//
//                          self.present(refreshAlert, animated: true, completion: nil)
//
//
//
//                      }))
//
//                      refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
//                          print("Handle Cancel Logic here")
//                      }))
//
//                      self.present(refreshAlert, animated: true, completion: nil)
//
//                  }
//

        
     //   }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        slpPhone.resignFirstResponder()
        
    }

//    func isNewEmail1() -> Bool {
//        var flag = true
//
//                   db.collection("slps").whereField("email", isEqualTo:slpEmail.text!).getDocuments {
//                    (snapshot, error) in
//                            if let error = error {
//               print(error.localizedDescription)
//                                      }
//
//                            else {
//                                for document in snapshot!.documents {
//
//                            if(document.data()["uid"] as! String == Auth.auth().currentUser!.uid){
//                                UserDefaults.standard.set(true,forKey: Constants.isNewEmail1)
//        flag = true
//
//
//                                print("my self")
//
//                            }
//                            else{
//                                UserDefaults.standard.set(false,forKey: Constants.isNewEmail1)
//                                print("not unique in slps")
//                                flag = false
//
//                                                           }
//
//                                                                                                        }
//                        }
//                    }
//        return flag
//
//    }
//
//    func isNewEmail2() -> Bool {
//        var flag = true
//        db.collection("patients").whereField("Email", isEqualTo:slpEmail.text!).getDocuments {
//                            (snapshot, error) in
//                                    if let error = error {
//                       print(error.localizedDescription)
//                                              }
//                                    else if snapshot!.documents.count != 0 {
//
//                                        print("not unique in patients")
//flag = false
//                                        UserDefaults.standard.set(false,forKey: Constants.isNewEmail2)
//                                                              }
//                                    else{
//                                        UserDefaults.standard.set(true,forKey: Constants.isNewEmail2)
//
//                                        print(" unique in patients")
//                                       flag = true
//
//
//            }
//
//        }
//        return flag
//
//    }

    }
    

