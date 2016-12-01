//
//  FilterTableViewController.swift
//  CPics
//
//  Created by Justin Moore on 11/30/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Parse

protocol filterProtocol {
    func filterComplete(returnedData: [PFObject],
                        searchCorps: Int,
                        searchTrumpet: Bool,
                        searchMellophone: Bool,
                        searchBaritone: Bool,
                        searchTuba: Bool,
                        searchSnare: Bool,
                        searchTenor: Bool,
                        searchBass: Bool,
                        searchFrontEnsemble: Bool,
                        searchColorGuard: Bool,
                        searchDrumMajor: Bool,
                        searchVets: Bool,
                        searchContracts: Bool,
                        searchAssigned: Int,
                        searchMusNone: Bool,
                        searchMus1: Bool,
                        searchMus2: Bool,
                        searchMus3: Bool,
                        searchVisNone: Bool,
                        searchVis1: Bool,
                        searchVis2: Bool,
                        searchVis3: Bool)
}

class FilterTableViewController: UITableViewController {

    var delegate:filterProtocol! = nil
    
    //var searchQuery = PFQuery(className: "Member")
    var arrayOfAllMembers: [PFObject]? = nil
    var arrayOfFilteredMembers: [PFObject]? = nil
    
    var arrayOfInstrumentsToFilter = [String]()
    var arrayOfVisualRatingsToFilter = [Int]()
    var arrayOfMusicRatingsToFilter = [Int]()
    
    //Search variables
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
    
    @IBOutlet weak var switchCorps: UISegmentedControl!
    @IBOutlet weak var checkAllMembers: UISwitch!
    @IBOutlet weak var checkCadets: UISwitch!
    @IBOutlet weak var checkCadets2: UISwitch!
    @IBOutlet weak var checkCadetsBoth: UISwitch!
    
    //Search checkboxes
    @IBOutlet weak var checkTrumpet: UISwitch!
    @IBOutlet weak var checkMellophone: UISwitch!
    @IBOutlet weak var checkBaritone: UISwitch!
    @IBOutlet weak var checkTuba: UISwitch!
    @IBOutlet weak var checkSnare: UISwitch!
    @IBOutlet weak var checkTenor: UISwitch!
    @IBOutlet weak var checkBass: UISwitch!
    @IBOutlet weak var checkFrontEnsemble: UISwitch!
    @IBOutlet weak var checkAllColorguard: UISwitch!
    @IBOutlet weak var checkAllDrumMajors: UISwitch!
    
    //Rating checkboxes
    @IBOutlet weak var checkVisual_NoRating: UISwitch!
    @IBOutlet weak var checkVisual_1: UISwitch!
    @IBOutlet weak var checkVisual_2: UISwitch!
    @IBOutlet weak var checkVisual_3: UISwitch!
    
    @IBOutlet weak var checkMusic_NoRating: UISwitch!
    @IBOutlet weak var checkMusic_1: UISwitch!
    @IBOutlet weak var checkMusic_2: UISwitch!
    @IBOutlet weak var checkMusic_3: UISwitch!
    
    @IBOutlet weak var checkVets: UISwitch!
    @IBOutlet weak var checkContract: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self
        //tableView.dataSource = self
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        setCorpsSwitches()
        checkTrumpet.isOn = searchTrumpet
        checkMellophone.isOn = searchMellophone
        checkBaritone.isOn = searchBaritone
        checkTuba.isOn = searchTuba
        checkSnare.isOn = searchSnare
        checkTenor.isOn = searchTenor
        checkBass.isOn = searchBass
        checkFrontEnsemble.isOn = searchFrontEnsemble
        checkAllColorguard.isOn = searchColorGuard
        checkAllDrumMajors.isOn = searchDrumMajor
        checkVets.isOn = searchVets
        checkContract.isOn = searchContracts
        checkMusic_NoRating.isOn = searchMusicNone
        checkMusic_1.isOn = searchMusic1
        checkMusic_2.isOn = searchMusic2
        checkMusic_3.isOn = searchMusic3
        checkVisual_NoRating.isOn = searchVisualNone
        checkVisual_1.isOn = searchVisual1
        checkVisual_2.isOn = searchVisual2
        checkVisual_3.isOn = searchVisual3
    }

    func setCorpsSwitches() {
        
        switch searchCorps {
        case 1:
            checkAllMembers.isOn = false
            checkCadets2.isOn = false
            checkCadetsBoth.isOn = false
            checkCadets.isOn = true
            break
        case 2:
            checkCadets.isOn = false
            checkAllMembers.isOn = false
            checkCadetsBoth.isOn = false
            checkCadets2.isOn = true
            break
        case 3:
            checkAllMembers.isOn = false
            checkCadets.isOn = false
            checkCadets2.isOn = false
            checkCadetsBoth.isOn = true
            break
        case 4:
            checkCadets.isOn = false
            checkCadets2.isOn = false
            checkCadetsBoth.isOn = false
            checkAllMembers.isOn = true
            break
        default:
            break
        }
        
        switchCorps.selectedSegmentIndex = searchAssigned
        if switchCorps.selectedSegmentIndex == 0 {
            checkCadetsBoth.isEnabled = true
        } else if switchCorps.selectedSegmentIndex == 1 {
            checkCadetsBoth.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: //corps
            return 5
        case 1: //brass
            return 4
        case 2://battery
            return 3
        case 3://front ensemble
            return 1
        case 4://color guard
            return 1
        case 5://drum major
            return 1
        case 6://filter
            return 2
        case 7://music rating
            return 4
        case 8://visual rating
            return 4
        default:
            return 0
        }
    }
//
//    func refreshServer() {
//        searchQuery.cancel()
//        arrayOfAllMembers?.removeAll()
//        arrayOfFilteredMembers?.removeAll()
//        searchQuery.limit = 1000
//        //searchQuery.order(byAscending: "name")
//        searchQuery.order(byAscending: "lastUpdated")
//        searchQuery.findObjectsInBackground { (members: [PFObject]?, err: Error?) in
//            if members != nil {
//                self.arrayOfAllMembers = members!
//                self.arrayOfFilteredMembers = members!
//                self.searchMembers()
//            }
//        }
//    }
    
    // SET FILTERS
    func updateInstrumentFilters() {
        arrayOfInstrumentsToFilter.removeAll()
        if checkTrumpet.isOn { arrayOfInstrumentsToFilter.append("Trumpet") }
        if checkMellophone.isOn { arrayOfInstrumentsToFilter.append("Mellophone") }
        if checkBaritone.isOn { arrayOfInstrumentsToFilter.append("Baritone") }
        if checkTuba.isOn { arrayOfInstrumentsToFilter.append("Tuba") }
        
        if checkSnare.isOn { arrayOfInstrumentsToFilter.append("Snare") }
        if checkTenor.isOn { arrayOfInstrumentsToFilter.append("Tenor") }
        if checkBass.isOn { arrayOfInstrumentsToFilter.append("Bass") }
        if checkFrontEnsemble.isOn { arrayOfInstrumentsToFilter.append("Front Ensemble") }
        
        if checkAllColorguard.isOn { arrayOfInstrumentsToFilter.append("Color Guard") }
        if checkAllDrumMajors.isOn { arrayOfInstrumentsToFilter.append("Drum Major") }
        
        searchMembers()
    }
    
    func updateRatingFilters() {
        arrayOfVisualRatingsToFilter.removeAll()
        arrayOfMusicRatingsToFilter.removeAll()
        
        if checkVisual_NoRating.isOn { arrayOfVisualRatingsToFilter.append(0) }
        if checkVisual_1.isOn { arrayOfVisualRatingsToFilter.append(1) }
        if checkVisual_2.isOn { arrayOfVisualRatingsToFilter.append(2) }
        if checkVisual_3.isOn { arrayOfVisualRatingsToFilter.append(3) }
        
        if checkMusic_NoRating.isOn { arrayOfMusicRatingsToFilter.append(0) }
        if checkMusic_1.isOn { arrayOfMusicRatingsToFilter.append(1) }
        if checkMusic_2.isOn { arrayOfMusicRatingsToFilter.append(2) }
        if checkMusic_3.isOn { arrayOfMusicRatingsToFilter.append(3) }
        
        searchMembers()
    }
    
    // END SET FILTERS
    
    
    // CHECK FILTERS
    func checkForInstrument(member: PFObject) {
        if !arrayOfInstrumentsToFilter.isEmpty {
            if let memberInstruments = member["sections"] as? [String] {
                for instrumentToCheck in arrayOfInstrumentsToFilter {
                    if memberInstruments.contains(instrumentToCheck) {
                        checkForRating(member: member) //We have a match, check the rating filter, then add
                    }
                }
            }
        } else {
            checkForRating(member: member) // no instruments selected, so skip to rating
        }
    }
    
    func checkForRating(member: PFObject) {
        
        
        if arrayOfVisualRatingsToFilter.isEmpty && arrayOfMusicRatingsToFilter.isEmpty {
            //we don't care about ratings, add the member
            addMemberToFilteredArray(member: member)
            
        } else if arrayOfVisualRatingsToFilter.isEmpty && !arrayOfMusicRatingsToFilter.isEmpty {
            //we only care about music ratings
            //MUSIC
            if !arrayOfMusicRatingsToFilter.isEmpty {
                if let memberMusicRating = member["musicRating"] as? Int {
                    for rating in arrayOfMusicRatingsToFilter {
                        if memberMusicRating == rating {
                            addMemberToFilteredArray(member: member)
                        }
                    }
                } else { // member does not have a rating, are we searching for No ratings?
                    if arrayOfMusicRatingsToFilter.contains(0) {
                        addMemberToFilteredArray(member: member)
                    }
                }
            } else {
                addMemberToFilteredArray(member: member)
            }
            
            
        } else if !arrayOfVisualRatingsToFilter.isEmpty && arrayOfMusicRatingsToFilter.isEmpty {
            //we only care about visual ratings
            if !arrayOfVisualRatingsToFilter.isEmpty {
                if let memberVisualRating = member["visualRating"] as? Int {
                    for rating in arrayOfVisualRatingsToFilter {
                        if memberVisualRating == rating {
                            print("match visual \(rating) - \(memberVisualRating)")
                            addMemberToFilteredArray(member: member)
                        }
                    }
                } else { // member does not have a rating, are we searching for No ratings?
                    if arrayOfVisualRatingsToFilter.contains(0) {
                        addMemberToFilteredArray(member: member)
                    }
                }
            } else {
                addMemberToFilteredArray(member: member)
            }
            
            
        } else if !arrayOfVisualRatingsToFilter.isEmpty && !arrayOfMusicRatingsToFilter.isEmpty {
            //we care about both ratings
            let memberVis = member["visualRating"] as? Int ?? nil
            let memberMus = member["musicRating"] as? Int ?? nil
            
            var addMusic = false
            var addVisual = false
            
            if memberVis != nil {
                for rating in arrayOfVisualRatingsToFilter {//check visual rating
                    if memberVis == rating {
                        addVisual = true
                    }
                }
            } else {
                // are we checking for no rating?
                if arrayOfVisualRatingsToFilter.contains(0) {
                    addMemberToFilteredArray(member: member)
                }
            }
            
            
            if memberMus != nil {
                for rating in arrayOfMusicRatingsToFilter {//check music rating
                    if memberMus == rating {
                        addMusic = true
                    }
                }
            } else {
                // are we checking for no rating?
                if arrayOfMusicRatingsToFilter.contains(0) {
                    addMemberToFilteredArray(member: member)
                }
            }
            
            if addMusic && addVisual {
                addMemberToFilteredArray(member: member)
            }
        }
        
        
        //        //VISUAL
        //        if !arrayOfVisualRatingsToFilter.isEmpty {
        //            if let memberVisualRating = member["visualRating"] as? Int {
        //                for rating in arrayOfVisualRatingsToFilter {
        //                    print("checking for rating of visual \(rating)")
        //                    if memberVisualRating == rating {
        //                        print("match visual \(rating) - \(memberVisualRating)")
        //                        addMemberToFilteredArray(member: member)
        //                    }
        //                }
        //            } else { // member does not have a rating, are we searching for No ratings?
        //                if arrayOfVisualRatingsToFilter.contains(0) {
        //                    addMemberToFilteredArray(member: member)
        //                }
        //            }
        //        } else {
        //            addMemberToFilteredArray(member: member)
        //        }
        //
        //        //MUSIC
        //        if !arrayOfMusicRatingsToFilter.isEmpty {
        //            if let memberMusicRating = member["musicRating"] as? Int {
        //                for rating in arrayOfMusicRatingsToFilter {
        //                    if memberMusicRating == rating {
        //                        addMemberToFilteredArray(member: member)
        //                    }
        //                }
        //            } else { // member does not have a rating, are we searching for No ratings?
        //                if arrayOfMusicRatingsToFilter.contains(0) {
        //                    addMemberToFilteredArray(member: member)
        //                }
        //            }
        //        } else {
        //            addMemberToFilteredArray(member: member)
        //        }
    }
    
    func addMemberToFilteredArray(member: PFObject) {
        
        //check veteran rating first
        if checkVets.isOn {
            let cVet = member["cadetsVet"] as? Bool ?? nil
            let c2Vet = member["cadets2Vet"] as? Bool ?? nil
            
            if cVet == true || c2Vet == true {
                //vet
            } else {
                //no vet
                return
            }
        }
        
        checkContractThenAdd(member: member)
    }
    
    func checkContractThenAdd(member: PFObject) {
        
        //check if contact is filtered, then add
        if checkContract.isOn {
            let contract = member["contract"] as? Bool ?? nil
            if contract == true {
                
            } else {
                return
            }
        }
        
        //make sure they don't exist in filtered array, then add
        if !(arrayOfFilteredMembers?.contains(member))! {
            arrayOfFilteredMembers?.append(member)
        }
        //tableMembers.reloadData()
        returnArray()
    }
    
    // END CHECK FILTERS
    
    func searchMembers() {
        arrayOfFilteredMembers?.removeAll()
        
        if arrayOfAllMembers == nil || arrayOfAllMembers?.count == 0 {
            return
        }
        
        for member in arrayOfAllMembers! {
            
            //Corps
            var isCadets: Bool?
            var isCadets2: Bool?
            
            if checkAllMembers.isOn {
                
                checkForInstrument(member: member)
                
            } else if checkCadets.isOn {
                
                if switchCorps.selectedSegmentIndex == 0 { //SEARCHING BY AUDITON
                    
                    isCadets = member["cadets"] as? Bool ?? false
                    isCadets2 = member["cadets2"] as? Bool ?? false
                    if isCadets! && !isCadets2! {
                        
                        //we have a member matching the corps filter
                        
                        //do they match the selected instruments?
                        checkForInstrument(member: member)
                        
                    }
                    
                } else if switchCorps.selectedSegmentIndex == 1 { //SEARCHING BY ASSIGNED
                    let corps = member["corps"] as? Int ?? nil
                    if corps == 1 {
                        checkForInstrument(member: member)
                    }
                }
                
            } else if checkCadets2.isOn {
                
                if switchCorps.selectedSegmentIndex == 0 { //SEARCHING BY AUDITON
                    
                    isCadets = member["cadets"] as? Bool ?? false
                    isCadets2 = member["cadets2"] as? Bool ?? false
                    if isCadets2! && !isCadets! {
                        
                        //we have a member matching the corps filter
                        
                        //do they match the selected instruments?
                        checkForInstrument(member: member)
                        
                    }
                    
                } else if switchCorps.selectedSegmentIndex == 1 { //SEARCHING BY ASSIGNED
                    let corps = member["corps"] as? Int ?? nil
                    if corps == 2 {
                        checkForInstrument(member: member)
                    }
                }
                
                
            } else if checkCadetsBoth.isOn {
                
                // This is disabled if switchCorps == 1.0 ie. searching by Assigned
                // Member cannot be asssigned to BOTH.
                if switchCorps.selectedSegmentIndex == 0 {
                    
                    isCadets = member["cadets"] as? Bool ?? false
                    isCadets2 = member["cadets2"] as? Bool ?? false
                    if isCadets! && isCadets2! {
                        
                        //we have a member matching the corps filter
                        
                        //do they match the selected instruments?
                        checkForInstrument(member: member)
                        
                    }
                    
                }
            }
            
            
            //            //Brass
            //            if checkTrumpet.isOn {
            //                if let instruments = member["sections"] as? [String] {
            //                    if instruments.contains("Trumpet") {
            //                        //make sure they don't exist in filtered array, then add
            //                        if !(arrayOfFilteredMembers?.contains(member))! {
            //                            arrayOfFilteredMembers?.append(member)
            //                        }
            //                    }
            //                }
            //            }
            //
            
            
            
        } // end of for/loop
        
        //
        //
        //        if searchMellophone {
        //            searchQuery.whereKey("sections", contains: "Mellophone")
        //        }
        //
        //        if searchBaritone {
        //            searchQuery.whereKey("sections", contains: "Baritone")
        //        }
        //
        //        if searchTuba {
        //            searchQuery.whereKey("sections", contains: "Tuba")
        //        }
        //
        //        //Percussion
        //        if searchSnare {
        //            searchQuery.whereKey("sections", contains: "Snare")
        //        }
        //
        //        if searchTenor {
        //            searchQuery.whereKey("sections", contains: "Tenor")
        //        }
        //
        //        if searchBass {
        //            searchQuery.whereKey("sections", contains: "Bass")
        //        }
        //
        //        if searchFrontEnsemble {
        //            searchQuery.whereKey("sections", contains: "Front Ensemble")
        //        }
        //
        //        //Color Guard
        //        if searchColorGuard {
        //            searchQuery.whereKey("sections", contains: "Color Guard")
        //        }
        //        
        //        //Drum Major
        //        if searchDrumMajor {
        //            searchQuery.whereKey("sections", contains: "Drum Major")
        //        }
        //        
        //        //Run the query
        //        searchQuery.findObjectsInBackground { (members: [PFObject]?, err: Error?) in
        //            if members != nil {
        //                self.arrayOfMembers = members!
        //                self.lblResults.stringValue = "\(self.arrayOfMembers?.count) found"
        //                self.tableMembers.reloadData()
        //            }
        //        }
        
        //tableMembers.reloadData()
        returnArray()
    }

    //Corps Filter
    @IBAction func checkCorps_click(_ sender: UISwitch) {
        searchCorps = sender.tag
        setCorpsSwitches()
        searchMembers()
    }
    
    @IBAction func switchCorps_click(_ sender: Any) {
        setCorpsSwitches()
        searchMembers()
    }

    //Instrument Filter
    @IBAction func checkInstrument_click(_ sender: UISwitch) {
        updateInstrumentFilters()
    }
    
    //Rating Filter
    @IBAction func checkRating_click(_ sender: UISwitch) {
        updateRatingFilters()
    }
    
    @IBAction func checkVets_click(_ sender: UISwitch) {
        searchMembers()
    }
    
    func returnArray() {
        delegate.filterComplete(returnedData: arrayOfFilteredMembers!,
                                searchCorps: searchCorps,
                                searchTrumpet: checkTrumpet.isOn,
                                searchMellophone: checkMellophone.isOn,
                                searchBaritone: checkBaritone.isOn,
                                searchTuba: checkTuba.isOn,
                                searchSnare: checkSnare.isOn,
                                searchTenor: checkTenor.isOn,
                                searchBass: checkBass.isOn,
                                searchFrontEnsemble: checkFrontEnsemble.isOn,
                                searchColorGuard: checkAllColorguard.isOn,
                                searchDrumMajor: checkAllDrumMajors.isOn,
                                searchVets: checkVets.isOn,
                                searchContracts: checkContract.isOn,
                                searchAssigned: switchCorps.selectedSegmentIndex,
                                searchMusNone: checkMusic_NoRating.isOn,
                                searchMus1: checkMusic_1.isOn,
                                searchMus2: checkMusic_2.isOn,
                                searchMus3: checkMusic_3.isOn,
                                searchVisNone: checkVisual_NoRating.isOn,
                                searchVis1: checkVisual_1.isOn,
                                searchVis2: checkVisual_2.isOn,
                                searchVis3: checkVisual_3.isOn)
    }
}
