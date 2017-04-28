//
//  FrontViewController.swift
//  slideout
//
//  Created by Kevin on 20/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit
import CoreLocation
import EasyToast
import SwiftSpinner

class FrontViewController: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate{


    
//--------------------------------------------------------------------------------
//a 'Singleton' be initialized here, for only one time; But can be access its property in other VC
    let resultData = ResultData.sharedResultData
//--------------------------------------------------------------------------------
    var keyword: String?
    var fetchOK: Bool = false
    var lati: String?
    var long: String?
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        inputTextField.delegate = self
        inputTextField.resignFirstResponder()
        
        
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            lati = String(currentLocation.coordinate.latitude)
            long = String(currentLocation.coordinate.longitude)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextField.text = textField.text
    }
    
    
    //MARK: Actions
    @IBAction func clearButton(_ sender: UIButton) {
        
        if let keyword = inputTextField.text, !keyword.isEmpty{
            inputTextField.text = ""
        }
        
        resultData.id  = "11081890741"
        
        resultData.detailURL = "http://mingkaicao-env.us-west-1.elasticbeanstalk.com/result.php?detailId=\(resultData.id)"
        
        print("request Detail----")
        resultData.downloadDetailData() {
            print("request Detail----")
            print(self.resultData.albumsNameArr)
            print(self.resultData.albumsURLArr)
            print("------------------")
        }
        
        print(resultData.usersIdArr)
        print("-----------------------")
        print(resultData.usersNameArr)
        print("-----------------------")
        print(resultData.usersThumbImgURLArr)
        print("-----------------------")
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        if let keyword = inputTextField.text, !keyword.isEmpty{
            
            SwiftSpinner.show("fetching data...")  // display waiting screen
            resultData.requestURL = "http://mingkaicao-env.us-west-1.elasticbeanstalk.com/result.php?kw=\(keyword)&lati=\(lati ?? "34.019676 ")&long=\(long ?? "-118.2889166")"
            
            resultData.downloadSearchData() {
                SwiftSpinner.hide()             // hide waiting screen, And go to result screen
                
                self.fetchOK = true;
                self.performSegue(withIdentifier: "searchSegue", sender:self.searchBtn)

            }
        }
    }
    


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "searchSegue" {
            if (inputTextField.text?.isEmpty)! {
                self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: false)
                return false
            }
            if self.fetchOK == false{
                return false
            }
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    
    
//    func passData( resultData : ResultData ){
//        print(resultData.idArr ?? "NO arry")
//        print(resultData.idArr?[0],resultData.idArr?[1],resultData.idArr?[2])
//    }
    
    

}





