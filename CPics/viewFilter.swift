//
//  viewFilter.swift
//  CPics
//
//  Created by Justin Moore on 11/30/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

protocol delegateFilter: class {
    func changedFilter()
}

class viewFilter: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableFilter: UITableView!

    func showInParent(parentNav: UINavigationController) {
        
        clipsToBounds = true
        layer.cornerRadius = 8
        
        tableFilter.delegate = self
        tableFilter.dataSource = self
        
        parentNav.view.addSubview(self)
        
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        backgroundColor = UIColor.clear
        frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)

        tableFilter.reloadData()
        
        //1
        UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveLinear, animations: {
            
            //self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8)
            
        }) { (done: Bool) in
            
            //2
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveLinear, animations: {
                self.alpha = 1
                //self.viewContainer.alpha = 1
                //self.viewContainer.transform = CGAffineTransformIdentity
            }) { (done: Bool) in

            }//end 2
            
        }//end 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // corps
            return 3
        case 1: // brass
            return 4
        case 2: // battery
            return 3
        case 3: // front ensemble
            return 1
        case 4: // guard
            return 1
        case 5: // drum major
            return 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        switch indexPath.section {
        case 0: // corps
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "The Cadets"
                break
            case 1:
                cell.textLabel?.text = "Cadets2"
                break
            case 2:
                cell.textLabel?.text = "Both"
                break
            default:
                break
            }
            break
        case 1: // brass
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Trumpet"
                break
            case 1:
                cell.textLabel?.text = "Mellophone"
                break
            case 2:
                cell.textLabel?.text = "Baritone"
                break
            case 3:
                cell.textLabel?.text = "Tuba"
                break
            default:
                break
            }
            break
        case 2: // battery
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Snare"
                break
            case 1:
                cell.textLabel?.text = "Tenor"
                break
            case 2:
                cell.textLabel?.text = "Bass"
                break
            default:
                break
            }
            break
        case 3: // front ensemble
            cell.textLabel?.text = "Front Ensemble"
            break
        case 4: // guard
            cell.textLabel?.text = "Color Guard"
            break
        case 5:
            cell.textLabel?.text = "Drum Major"
            break
        default:

            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}








