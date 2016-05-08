//
//  LoginViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/27/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var TextLogin: UITextField!
    
    @IBOutlet weak var TextSenha: UITextField!
    
    
    @IBAction func Entrar(sender: AnyObject) {
        do{
            let str = TextLogin.text! + ";" + TextSenha.text!
            let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
            let base64 = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

            let url = NSURL(string: Constantes.API_LOGIN + base64)
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                do{
                    
                let usuario: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(usuario.valueForKey("id") , forKey: "IdUsuario")
                
                dispatch_async(dispatch_get_main_queue(), {self.dismissViewControllerAnimated(true, completion: nil)})
                
                }catch{
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController(title: "AgendaOnline", message: "Login ou senha invalidos.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: {
                            self.TextLogin.text = ""
                            self.TextSenha.text = ""
                        })
                    })
                    print(error)
                }

                })
            
        }catch{
            print(error)
        }
    }
}