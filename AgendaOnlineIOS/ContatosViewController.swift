//
//  ContatosViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/29/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit


class ContatosViewController: UIViewController {
    
    @IBAction func Cancelar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var labelContatos: UILabel!
    
    @IBOutlet weak var botaoCancelar: UIButton!
    
    var contatos: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var parent:ConversaViewController!
    
    func configurarEstilo(){
        labelContatos.backgroundColor = Cor.COR_BARRA_DE_TITULO
        
        view.backgroundColor = Cor.COR_BARRA_DE_TITULO
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarEstilo()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        carregarContatos()
        
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
            
            self.indicadorCarregamento.Parar()
        })
    }
    
    func tableView() {
        /*let usuario = self.contatos[] as? Usuario
        self.dismissViewControllerAnimated(false, completion: {() -> Void in
            self.parent.performSegueWithIdentifier("mensagemSegue", sender: usuario)*/
    }
}