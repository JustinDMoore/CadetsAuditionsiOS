//
//  ProfileViewController.swift
//  CPics
//
//  Created by Justin Moore on 12/1/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let Server = ParseServer.sharedInstance
    var imagePicker: UIImagePickerController!
    var memberOpened: PFObject? = nil
    
    @IBOutlet weak var btnNumber: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var progressWheel: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let member = Server.member {
            memberOpened = member
            if let imageFile = member["picture"] as? PFFile {
                imgPicture.image = nil
                progressWheel.isHidden = false
                progressWheel.startAnimating()
                imageFile.getDataInBackground(block: { (data: Data?, err: Error?) in
                    if data != nil {
                        self.progressWheel.stopAnimating()
                        self.progressWheel.isHidden = true
                        self.imgPicture.image = UIImage(data: data!)
                    }
                })
            } else {
                //imgPicture.image = UIImage(named: "Picture")
                progressWheel.stopAnimating()
                progressWheel.isHidden = true
            }
            
            //number
            if let number = member["number"] as? Int {
                btnNumber.setTitle("\(number)", for: .normal)
            } else {
                btnNumber.setTitle("Set Number", for: .normal)
            }
            
            lblName.text = Server.member?["name"] as? String
            
            //age
            let dob = member["dob"] as! Date
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
            let age = ageComponents.year!
            lblAge.text = "\(age) Years Old"
            
            btnPhoneNumber.setTitle(member["phone"] as? String, for: .normal)
            btnEmail.setTitle(member["email"] as? String, for: .normal)
            lblSchool.text = member["school"] as? String
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = fixOrientation(img: image!)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        imgPicture.image = image
        
        //let imageData = UIImagePNGRepresentation(image!)
        //create a parse file to store in cloud
        let parseImageFile = PFFile(name: "picture.png", data: imageData!)
        
        parseImageFile?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                self.memberOpened?["picture"] = parseImageFile
                self.memberOpened?.saveEventually({ (done: Bool, err: Error?) in
                    
                })
            }
        })
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNumber(_ sender: UIButton) {
        //1. Create the alert controller.
        
        let alert = UIAlertController(title: memberOpened?["name"] as? String, message: "Set number:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            //textField.text = "Some default text."
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            if let number = Int(textField.text!) {
                self.memberOpened?.setObject(number, forKey: "number")
                self.memberOpened?.saveEventually()
                self.btnNumber.setTitle("\(number)", for: .normal)
            }
            textField.resignFirstResponder()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func email_click(_ sender: UIButton) {
        let email = "mailto:" + (sender.titleLabel?.text)!
        let url = NSURL(string: email)
        UIApplication.shared.openURL(url as! URL)
    }
    
    @IBAction func call_click(_ sender: UIButton) {
        let phone = btnPhoneNumber.titleLabel?.text
        if let url = NSURL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
}
