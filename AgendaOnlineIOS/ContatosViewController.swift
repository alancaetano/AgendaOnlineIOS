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
    
    var indicadorCarregamento:IndicadorCarregamento!
    
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
        
        self.tvContatos.tableFooterView = UIView()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        carregarContatos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvContatos.dataSource = self
        self.tvContatos.delegate = self
        
        iniciarTableView()
        
    }
    
    func carregarContatos(){
        self.indicadorCarregamento.Iniciar()
        
        self.contatos = []
        
        let url: String = "\(Servico.API_GETCONTATOSESCOLA)\(Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO))"
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json: nil, callback: carregarContatosCallback)
        
        
    }
    
    func carregarContatosCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil){
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao recuperar os contatos da escola.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
        }
        
        let jsonResult: NSArray? = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
        
        if(jsonResult != nil && jsonResult!.count > 0){
            for item in jsonResult! {
                let obj = item as! NSDictionary
                
                let contato:Usuario = Usuario()
                contato.Id = obj["Id"] as! String
                contato.Nome = obj["NomeProfessor"] as! String
                self.contatos.addObject(contato)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tvContatos.reloadData()
            self.indicadorCarregamento.Parar()
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let usuario = self.contatos[indexPath.row] as? Usuario
        self.dismissViewControllerAnimated(false, completion: {() -> Void in
            self.parent.performSegueWithIdentifier("mensagemSegue", sender: usuario)
            
        })
    }
}