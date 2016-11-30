//
//  TableViewController.swift
//  CPics
//
//  Created by Justin Moore on 11/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let Server = ParseServer.sharedInstance
    var searchQuery = PFQuery(className: "Member")
    var arrayOfAllMembers: [PFObject]? = nil
    var arrayOfFilteredMembers: [PFObject]? = nil
    var memberToOpen: PFObject? = nil
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)
        
        refreshServer()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // do stuff
        search()
        return true
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func refreshServer() {
        arrayOfAllMembers?.removeAll()
        let query = PFQuery(className: "Member")
        query.limit = 1000
        query.findObjectsInBackground { (members: [PFObject]?, err: Error?) in
            if members != nil {
                self.arrayOfAllMembers = members!
                self.arrayOfFilteredMembers = members!
                self.tableView.reloadData()
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image = fixOrientation(img: image!)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        
        //let imageData = UIImagePNGRepresentation(image!)
        //create a parse file to store in cloud
        let parseImageFile = PFFile(name: "picture.png", data: imageData!)
        
        parseImageFile?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                self.memberToOpen?["picture"] = parseImageFile
                self.memberToOpen?.saveEventually({ (done: Bool, err: Error?) in
                    self.tableView.reloadData()
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

    @IBAction func setNumber(_ sender: Any) {
        //1. Create the alert controller.
        
        let alert = UIAlertController(title: memberToOpen?["name"] as? String, message: "Set number:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            //textField.text = "Some default text."
             textField.keyboardType = UIKeyboardType.numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = alert.textFields![0] // Force unwrapping because we know it exists.
            self.memberToOpen?.setObject(Int(textField.text!)!, forKey: "number")
            self.memberToOpen?.saveEventually()
            self.tableView.reloadData()
            textField.resignFirstResponder()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFilteredMembers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        memberToOpen = arrayOfFilteredMembers?[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMember", for: indexPath)
        
        let lblNumber = cell.viewWithTag(1) as! UILabel
        let lblName = cell.viewWithTag(2) as! UILabel
        let lblSections = cell.viewWithTag(3) as! UILabel
        let imgCorps = cell.viewWithTag(4) as! UIImageView
        let imgPicture = cell.viewWithTag(5) as! UIImageView
        
        
        if let member = arrayOfFilteredMembers?[indexPath.row] {
            
            if (member["picture"] as? PFFile) != nil {
                imgPicture.isHidden = false
            } else {
                imgPicture.isHidden = true
            }
            
            let num = member["number"] as? Int ?? 0
            if num != 0 {
                lblNumber.text = "\(num)"
            } else {
                lblNumber.text = ""
            }
            lblName.text = member["name"] as? String ?? "Error"
            
            if let arrayOfInstruments = member["sections"] as! [String]? {
                var strInstruments = ""
                if arrayOfInstruments.count > 1 {
                    for instrument in arrayOfInstruments {
                        strInstruments += instrument + "    "
                    }
                } else if arrayOfInstruments.count == 1 {
                    strInstruments = arrayOfInstruments.first!
                }
                lblSections.text = strInstruments
            }
            
            let cadets = member["cadets"] as! Bool
            let cadets2 = member["cadets2"] as! Bool
            if cadets && !cadets2 {
                imgCorps.image = UIImage(named: "Cadets")
            } else if !cadets && cadets2 {
                imgCorps.image = UIImage(named: "Cadets2")
            } else if cadets && cadets2 {
                imgCorps.image = UIImage(named: "CadetsCadets2")
            }
            
        } else {
            lblNumber.text = "Err"
            lblName.text = ""
            lblSections.text = ""
            imgCorps.image = nil
        }
        

        return cell
    }
 


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addMemberToFilteredArray(member: PFObject) {
        //make sure they don't exist in filtered array, then add
        if !(arrayOfFilteredMembers?.contains(member))! {
            arrayOfFilteredMembers?.append(member)
        }
        tableView.reloadData()
    }
    
    func search() {
        arrayOfFilteredMembers?.removeAll()
        if txtSearch.text?.characters.count == 0 {
            arrayOfFilteredMembers = arrayOfAllMembers
            tableView.reloadData()
            return
        }
        
        for member in arrayOfAllMembers! {
            if let num = Int(txtSearch.text!) {
                if let memnum = member["number"] as? Int {
                    if memnum == num {
                        addMemberToFilteredArray(member: member)
                    }
                }
            } else {
                if let name = member["name"] as? String {
                    let nameLower = name.lowercased()
                    let textLower = txtSearch.text?.lowercased()
                    if nameLower.range(of: textLower!) != nil {
                        addMemberToFilteredArray(member: member)
                    }
                }
            }
            tableView.reloadData()
        }
    }
}
