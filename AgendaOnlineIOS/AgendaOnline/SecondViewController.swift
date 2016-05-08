//
//  SecondViewController.swift
//  AgendaOnline
//
//  Created by João Fabio Lourenço dos Santos on 07/02/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit
import Foundation

class SecondViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var conversa:Conversa!
    
    @IBOutlet var tvMensagens: UITableView!
    
    @IBOutlet weak var tecladoBaseConstraint: NSLayoutConstraint!
    var mensagens: NSMutableArray! = []
    
    @IBOutlet weak var textViewDigitarMensagem: UITextField!
    var IdUsuario: String! = ""
    
    @IBOutlet var viewBase: UIView!
    
    var indicator:UIActivityIndicatorView! = nil
    
    var fezScroll:Bool = false

	override func viewDidLoad() {
        
		super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        IdUsuario = defaults.stringForKey("IdUsuario")!
        
        self.tvMensagens.tableFooterView = UIView()
        
        self.textViewDigitarMensagem.delegate = self;
        self.tvMensagens.dataSource = self
        self.tvMensagens.delegate = self
		self.title = self.conversa.NomeProfessor
        //self.tvMensagens.backgroundColor = UIColor.grayColor()
        self.tvMensagens.estimatedRowHeight = 80
        self.tvMensagens.rowHeight = UITableViewAutomaticDimension
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        carregarMensagens()

    }
    
    func enviarNovaConversa(msg:String){
        do{
            let idAluno = "B5C486CA-9537-4D34-BDC7-8FFFED0DCC2C"
            
            let url = NSURL(string: "\(Constantes.API_ENVIARNOVACONVERSA)?idUsuarioProfessor=\(conversa.IdProfessor)&idUsuarioResponsavel=\(IdUsuario)&idAluno=\(idAluno)&tipo=\(Constantes.TIPOCONVERSA_CONVERSA)")
            
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if(error != nil){
                    print(error!)
                }
                
                let IdConversa = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                
                self.conversa = Conversa(Id: IdConversa, NomeProfessor: "", UltimaMensagem: "", IdProfessor: "", Tipo: Constantes.TIPOCONVERSA_CONVERSA)
                
                self.enviarMensagem(msg)
                
            })
            
        }catch{
            print(error)
        }
    }
    
    func enviarMensagem(msg:String){
        do{
            let url = NSURL(string: Constantes.API_ENVIARMENSAGEM)
        
            let json = [ "IdUsuario":self.IdUsuario, "IdConversa": self.conversa.Id, "Texto":msg ]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            let request = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = jsonData
    
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if(error != nil){
                    print(error!)
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.mensagens.addObject(Mensagem(Id: "", IdUsuario: self.IdUsuario, IdConversa: self.conversa.Id, Texto: msg, DtEnvio: NSDate()))
                    self.tvMensagens.reloadData()
                })
                
            })
            
            tvMensagens.setContentOffset(CGPoint(x: 0, y: CGFloat.max), animated: false)
            
        }catch{
            print(error)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == ""){
            return false
        }
        
        let msg:String = textField.text!
        
        if(self.conversa.Id == ""){
            enviarNovaConversa(msg)
        }else{
            enviarMensagem(msg)
        }
        
        textField.text = ""
        
        return true
    }
    
    func carregarMensagens(){
        let url: String = Constantes.API_GETMENSAGENS + conversa.Id
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do{
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                
                if jsonResult != nil && jsonResult.count > 0{
                    for item in jsonResult {
                        let obj = item as! NSDictionary
                        let msg:Mensagem = Mensagem(Id: obj["id"] as! String, IdUsuario: obj["id_usuario"] as! String, IdConversa: "", Texto: obj["texto"] as! String, DtEnvio: NSDate())
                        self.mensagens.addObject(msg)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {self.tvMensagens.reloadData()})
                dispatch_async(dispatch_get_main_queue(), {self.indicator.stopAnimating()})
                
            }catch{
                print(error)
            }
            
        });
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mensagens.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = self.tvMensagens.dequeueReusableCellWithIdentifier("msgcell") as UITableViewCell?
        
        let msg:Mensagem = mensagens![indexPath.row] as! Mensagem
        
        var msgCell:MensagemCell
        
        if(cell == nil){
            msgCell = MensagemCell()
        }else{
            msgCell = cell as! MensagemCell
        }
        
        msgCell.Texto.text = msg.Texto
        
        let formato:NSDateFormatter = NSDateFormatter()
        formato.dateFormat = "hh:mm"
        //msgCell.Data.text = formato.stringFromDate(msg.DtEnvio)
        
        if(msg.IdUsuario == IdUsuario){
            let imageView:UIImageView = UIImageView(image: UIImage(named: "balaousuario.png")!)
            msgCell.backgroundView = imageView
        }else{
            let imageView:UIImageView = UIImageView(image: UIImage(named: "balaodestinatario.png")!)
            msgCell.backgroundView = imageView
        }
        
        msgCell.Texto.numberOfLines = 0
        msgCell.Texto.sizeToFit()
        msgCell.sizeToFit()
        
        if(!fezScroll){
            tvMensagens.setContentOffset(CGPoint(x: 0, y: CGFloat.max), animated: false)
            fezScroll = true
        }
        
        return msgCell
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
    tecladoBaseConstraint.constant = keyboardSize - bottomLayoutGuide.length + 10
        
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        tecladoBaseConstraint.constant = 10
        
        UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
    }
}

