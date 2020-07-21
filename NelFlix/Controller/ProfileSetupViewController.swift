//
//  ProfileSetupViewController.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/17/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
import  Firebase

private let segID = "ProfileToMain"
class ProfileSetupViewController: UIViewController {
    let db = Database.database()
    let storage = Storage.storage()
    @IBOutlet weak var ImageBtn: UIButton!
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var AgeField: UITextField!
    @IBOutlet weak var GenderSeg: UISegmentedControl!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ImageBtn.layer.cornerRadius = ImageBtn.frame.height/2
        ImageBtn.layer.masksToBounds = true
        ImageBtn.layer.borderColor = UIColor.black.cgColor
    }
    

    
    
    
    @IBAction func ImageBtnPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true , completion: nil)
    }
    
    
    @IBAction func FinishBtnPressed(_ sender: Any) {
            print("in finish btn")
            let image = ImageBtn.imageView?.image
            guard let profileImage = image?.jpegData(compressionQuality: 0.1) else {return }
            let filename = NSUUID().uuidString
            let profileRef = self.storage.reference().child("profileImage").child(filename)
            let uploadTask = profileRef.putData(profileImage, metadata: nil) { (metadata, error) in
                if error != nil
                {
                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription , preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    {   (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else
                {
                    print("image Uploaded")
                profileRef.downloadURL
                    { (url, error) in
                        if error != nil
                        {
                            print("Error : Unable to get the download URLb")
                        }
                        else
                        {
                            self.uploadUser(with: url!.absoluteString)
                        }
                    }
                }
            }
        uploadTask.observe(.success) { (snapshot) in
            print("upload Successful!")
            self.performSegue(withIdentifier: segID, sender: self )
        }
    }
    
    

    
    
    
    func uploadUser(with url:String)
    {
        if let username = UsernameField.text ,  let age = Int(AgeField.text!) ,let gender =  GenderSeg.titleForSegment(at: GenderSeg.selectedSegmentIndex)
        {
            let dictionaryValues = ["username":username,
                                    "age":age,
                                    "url":url,
                                    "gender":gender] as [String : Any]
            let values = [Auth.auth().currentUser?.uid : dictionaryValues]
            db.reference().child("users").updateChildValues(values) { (error, dataRef) in
                if let e = error
                {
                    print(e.localizedDescription)
                }
                else
                {
                    print("Successfully created user and saved info to database")
                }
            }
            
           
        }
    }
    
    
    
    
 
    
    
    

}



extension ProfileSetupViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            ImageBtn.setImage(pickedImage, for: .normal)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
