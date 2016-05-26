//
//  ContatosViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/29/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit


class ContatosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func Cancelar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var tvContatos: UITableView!
    
    var contatos: NSMutableArray! = []
    
    var indicator:UIActivityIndicatorView! = nil
    
    var IdUsuario:String = ""
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var parent:ConversaViewController!
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contatos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell:UITableViewCell = self.tvContatos.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let usuario:Usuario = contatos![indexPath.row] as! Usuario
        cell.textLabel?.text = usuario.Nome
        
        return cell
    }
    
    func iniciarTableView(){
        
        IdUsuario = defaults.stringForKey("IdUsuario")!
        
        self.tvContatos.tableFooterView = UIView()
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        carregarContatos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvContatos.dataSource = self
        self.tvContatos.delegate = self
        
        iniciarTableView()
        
    }
    
    func carregarContatos(){
        self.contatos = []
        let url: String = Constantes.API_GETCONTATOSESCOLA + IdUsuario
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do{
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                
                for item in jsonResult {
                    let obj = item as! NSDictionary
                    let contato:Usuario = Usuario(Id: obj["Id"] as! String, Nome: obj["NomeProfessor"] as! String, Email:"", Senha:"", Tipo:"")
                        self.contatos.addObject(contato)
                }
                
                dispatch_async(dispatch_get_main_queue(), {self.tvContatos.reloadData()})
                dispatch_async(dispatch_get_main_queue(), {self.indicator.stopAnimating()})
                
            }catch{
                dispatch_async(dispatch_get_main_queue(), {self.indicator.stopAnimating()})
                print(error)
            }
        });
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let usuario = self.contatos[indexPath.row] as? Usuario
        self.dismissViewControllerAnimated(false, completion: {() -> Void in
            self.parent.performSegueWithIdentifier("mensagemSegue", sender: usuario)
            
        })
    }
}