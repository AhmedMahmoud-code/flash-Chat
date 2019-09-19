//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    let restartAction = UIAlertAction(title: "OK", style: .default)
 //   let restartActionWithout = UIAlertAction(title: nil , style: .default)
    let alert = UIAlertController(title: "Error", message: "Email or password invalid.", preferredStyle: .alert)
   // let alertYes = UIAlertController(title: "Login Sucssesful", message: nil, preferredStyle: .alert)

    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "Email or password not valid!")
                //self.alert.addAction(self.restartAction)
                //self.present(self.alert, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    


    
}  
