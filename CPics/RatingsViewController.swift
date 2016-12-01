//
//  RatingsViewController.swift
//  CPics
//
//  Created by Justin Moore on 12/1/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

class RatingsViewController: UIViewController {

    let Server = ParseServer.sharedInstance
    var member: PFObject? = nil
    
    @IBOutlet weak var imgAuditioning: UIImageView!
    @IBOutlet weak var imgAssigned: UIImageView!
    @IBOutlet weak var lblMusicRating: UILabel!
    @IBOutlet weak var lblVisualRating: UILabel!
    @IBOutlet weak var lblInstrument: UILabel!
    @IBOutlet weak var switchCadetsVet: UISwitch!
    @IBOutlet weak var switchCadets2Vet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let member = Server.member {
            self.member = member
            
            //auditioning for
            let cadets = member["cadets"] as! Bool
            let cadets2 = member["cadets2"] as! Bool
            if cadets && !cadets2 {
                imgAuditioning.image = UIImage(named: "Cadets")
            } else if !cadets && cadets2 {
                imgAuditioning.image = UIImage(named: "Cadets2")
            } else if cadets && cadets2 {
                imgAuditioning.image = UIImage(named: "CadetsCadets2")
            }
            
            //assigned to
            if let corps = member["corps"] as? Int {
                if corps == 1 {
                    imgAssigned.image = UIImage(named: "Cadets")
                } else if corps == 2 {
                    imgAssigned.image = UIImage(named: "Cadets2")
                }
            } else {
                imgAssigned.image = nil
            }
            
            if let rating = member["musicRating"] as! Int? {
                lblMusicRating.text = "\(rating)"
            } else {
                lblMusicRating.text = ""
            }
            
            if let rating = member["visualRating"] as! Int? {
                lblVisualRating.text = "\(rating)"
            } else {
                lblVisualRating.text = ""
            }

            if let arrayOfInstruments = member["sections"] as! [String]? {
                var strInstruments = ""
                if arrayOfInstruments.count > 1 {
                    for instrument in arrayOfInstruments {
                        strInstruments += instrument + "    "
                    }
                } else if arrayOfInstruments.count == 1 {
                    strInstruments = arrayOfInstruments.first!
                }
                
                lblInstrument.text = strInstruments
            }
            
            let cVet = member["cadetsVet"] as? Bool ?? nil
            let c2Vet = member["cadets2Vet"] as? Bool ?? nil
            
            switchCadetsVet.isOn = cVet ?? false
            switchCadets2Vet.isOn = c2Vet ?? false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.tag == 1 {
            member?["cadetsVet"] = switchCadetsVet.isOn
        } else if sender.tag == 2 {
            member?["cadets2Vet"] = switchCadets2Vet.isOn
        }
        member?.saveEventually()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
