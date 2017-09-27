//
//  ViewController.swift
//  FireFun
//
//  Created by AlexanderYakovenko on 9/25/17.
//  Copyright © 2017 AlexanderYakovenko. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var myTextField: UITextField!
  @IBOutlet weak var myTableView: UITableView!
  
  var myList:[String] = []
  
  var ref: DatabaseReference?
  
  var handle: DatabaseHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    
    
    
    
    handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
      if let item = snapshot.value as? String {
        self.myList.append(item)
        self.myTableView.reloadData()
      }
      })
    
    // MARK: query
    query()
    
    
  }
  
  // setting up our table view
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    cell.textLabel?.text = myList[indexPath.row]
    return cell
  }

  
  @IBAction func saveButton(_ sender: Any) {
    
    
    // saving item to database
    if myTextField.text != "" {
      ref?.child("list").childByAutoId().setValue(myTextField.text)
      myTextField.text = ""
    }
    
  }
  // delete item
  @IBAction func delButton(_ sender: Any) {
    
    ref?.child("Name").child("Alex").child("age").removeValue(completionBlock: { (error, ref) in
      if error != nil {
        print("error")
      }
      })
    
  }
  
  // query to base
  @IBAction func queryButton(_ sender: Any) {
    
    let db = ref?.child("userArray")
    let ref2 = db?.observe(.value, with: { (snapShot) in
      guard snapShot.value != nil else {
        return
      }
      let user = snapShot.value as! [String: Any]
      print(user)
      
      let componentArray = [String](user.keys)
      for item in componentArray {
        print(item)
        let subUser = snapShot.childSnapshot(forPath: item)
        print(subUser.childSnapshot(forPath: "age").value!)
        
      }
      
      print(componentArray)
      print("*****************************")
      
      
      
    }) {(error) in
      print("error")
      
    }
    
    
    
    /*
    let searchRef = ref?.child("Name")  //.queryOrdered(byChild: "age").queryEqual(toValue: 25)
    searchRef?.observeSingleEvent(of: .value, with: { (snapshot) in
      guard snapshot.value is NSNull else {
        let user = snapshot.value as!  [String: Any]
        print("\(user) is exists")
        return
      }
      print("not exists")
    }) {(error) in
      print("error")
      
    }
    */
    
  }
  
  func query() {
    
    let usersRef = self.ref?.child("userArray")
    
    usersRef?.queryOrdered(byChild: "age").queryStarting(atValue: 15)
      .queryEnding(atValue: 27).observe(.childAdded, with: { (snapShot) in
        print(snapShot.value)
      })
    
    /*
    usersRef?.queryOrderedByChild("age").queryStartingAtValue(20)
      .queryEndingAtValue(25).observeEventType(.ChildAdded, withBlock: { snapshot in
        
        let distance = snapshot.value["distance"] as! Int
        
        if distance < 100 {
          let age = snapshot.value["age"] as! Int
          let fbKey = snapshot.key!
          
          print("array: \(fbKey)  \(age)  \(distance)")
        }
      })
    */
    
  }
  
  
  
  
}

