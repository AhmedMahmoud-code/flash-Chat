//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGeasturer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGeasturer)
        

        //TODO: Register your MessageCell.xib file here:
       messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        ConfigureTabeView()
        retrieveMessages()
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named : "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email! {
            
            //Set background to blue if message is from logged in user.
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            //Set background to grey if message is from another user.
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped (){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func ConfigureTabeView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint.constant = 350
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        })
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(false)
        messageTextfield.isEnabled = false
      
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error , reffrence) in
            
            if error != nil {
                print(error)
            }
            else{
                print("message saved succesfully!")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                  self.messageTextfield.text = ""
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages(){
        
         let messageDB = Database.database().reference().child("Messages")
         messageDB.observe(.childAdded) { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary< String , String >
            
            let text = snapShotValue["MessageBody"]!
            let sender = snapShotValue["Sender"]!
            
            let message = Message()
            
            message.messageBody = text
            message.sender = sender
            
            
            self.messageArray.append(message)
            
            self.ConfigureTabeView()
            
            self.messageTableView.reloadData()
        }
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        SVProgressHUD.show()
        do{
            try Auth.auth().signOut()
            SVProgressHUD.dismiss()
            navigationController?.popViewController(animated: true)
        }
        catch{
            SVProgressHUD.showError(withStatus: "Try Again!")
        }
        
    }
    


}
