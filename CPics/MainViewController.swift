//
//  MainViewController.swift
//  CPics
//
//  Created by Justin Moore on 11/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse
import SlideMenuControllerSwift


class MainViewController: SlideMenuController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, filterProtocol {

    let Server = ParseServer.sharedInstance
    var searchQuery = PFQuery(className: "Member")
    var arrayOfAllMembers: [PFObject]? = nil
    var arrayOfFilteredMembers: [PFObject]? = nil
    var memberToOpen: PFObject? = nil
    var imagePicker: UIImagePickerController!
    
    var searchCorps = 0
    var searchTrumpet = false
    var searchMellophone = false
    var searchBaritone = false
    var searchTuba = false
    var searchSnare = false
    var searchTenor = false
    var searchBass = false
    var searchFrontEnsemble = false
    var searchColorGuard = false
    var searchDrumMajor = false
    var searchVets = false
    var searchContracts = false
    var searchAssigned = 0
    
    var searchMusicNone = false
    var searchMusic1 = false
    var searchMusic2 = false
    var searchMusic3 = false
    
    var searchVisualNone = false
    var searchVisual1 = false
    var searchVisual2 = false
    var searchVisual3 = false
    
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(MainViewController.filter))
        txtSearch.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)! - 50, height: 30)
        self.navigationItem.titleView = txtSearch
        
        let imageView = UIImageView(image: UIImage(named: "Search"))
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        txtSearch.leftView = imageView
        txtSearch.leftViewMode = .always
        
        addToolBar(textField: txtSearch)
        
        refreshServer()
        
    }
    
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MainViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
        txtSearch.resignFirstResponder()
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
    }
    
    func filter() {
        self.performSegue(withIdentifier: "filter", sender: self)
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
        self.performSegue(withIdentifier: "profile", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filter" {
            let vc = segue.destination as! FilterTableViewController
            vc.arrayOfAllMembers = arrayOfAllMembers
            vc.arrayOfFilteredMembers = arrayOfAllMembers
            vc.delegate = self
            
            vc.searchCorps = searchCorps
            vc.searchTrumpet = searchTrumpet
            vc.searchMellophone = searchMellophone
            vc.searchBaritone = searchBaritone
            vc.searchTuba = searchTuba
            vc.searchSnare = searchSnare
            vc.searchTenor = searchTenor
            vc.searchBass = searchBass
            vc.searchFrontEnsemble = searchFrontEnsemble
            vc.searchColorGuard = searchColorGuard
            vc.searchDrumMajor = searchDrumMajor
            vc.searchVets = searchVets
            vc.searchContracts = searchContracts
            vc.searchAssigned = searchAssigned
            
            vc.searchMusicNone = searchMusicNone
            vc.searchMusic1 = searchMusic1
            vc.searchMusic2 = searchMusic2
            vc.searchMusic3 = searchMusic3
            
            vc.searchVisualNone = searchVisualNone
            vc.searchVisual1 = searchVisual1
            vc.searchVisual2 = searchVisual2
            vc.searchVisual3 = searchVisual3
        } else if segue.identifier == "profile" {
            Server.member = memberToOpen
        }
    }
 
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
    
    func filterComplete(returnedData: [PFObject], searchCorps: Int, searchTrumpet: Bool, searchMellophone: Bool, searchBaritone: Bool, searchTuba: Bool, searchSnare: Bool, searchTenor: Bool, searchBass: Bool, searchFrontEnsemble: Bool, searchColorGuard: Bool, searchDrumMajor: Bool, searchVets: Bool, searchContracts: Bool, searchAssigned: Int, searchMusNone: Bool, searchMus1: Bool, searchMus2: Bool, searchMus3: Bool, searchVisNone: Bool, searchVis1: Bool, searchVis2: Bool, searchVis3: Bool) {
        
        arrayOfFilteredMembers = returnedData
        self.searchCorps = searchCorps
        self.searchTrumpet = searchTrumpet
        self.searchMellophone = searchMellophone
        self.searchBaritone = searchBaritone
        self.searchTuba = searchTuba
        self.searchSnare = searchSnare
        self.searchTenor = searchTenor
        self.searchBass = searchBass
        self.searchFrontEnsemble = searchFrontEnsemble
        self.searchColorGuard = searchColorGuard
        self.searchDrumMajor = searchDrumMajor
        self.searchVets = searchVets
        self.searchContracts = searchContracts
        
        self.searchMusicNone = searchMusNone
        self.searchMusic1 = searchMus1
        self.searchMusic2 = searchMus2
        self.searchMusic3 = searchMus3
        
        self.searchVisualNone = searchVisNone
        self.searchVisual1 = searchVis1
        self.searchVisual2 = searchVis2
        self.searchVisual3 = searchVis3
        
        tableView.reloadData()
    }

}
