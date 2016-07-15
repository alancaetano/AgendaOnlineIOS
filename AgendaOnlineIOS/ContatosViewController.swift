//
//  ContatosViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 3/29/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit


class ContatosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func Cancelar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var labelContatos: UILabel!
    
    @IBOutlet weak var botaoCancelar: UIButton!
    
    @IBOutlet weak var tvContatos: UITableView!
    
    var contatos: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var aluno:Aluno!
    
    var viewControllerPai:ConversaViewController!
    
    func configurarEstilo(){
        labelContatos.backgroundColor = Cor.COR_BARRA_DE_TITULO
        
        view.backgroundColor = Cor.COR_BARRA_DE_TITULO
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvContatos.delegate = self
        self.tvContatos.dataSource = self
        
        configurarEstilo()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        carregarContatos()
    }
    
    func carregarContatos(){
        self.indicadorCarregamento.Iniciar()
        
        self.contatos = []
        
        let url: String = "\(Servico.API_GETCONTATOSESCOLA)\(aluno.Id)"
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(contatos == nil || contatos.count==0){
            return UITableViewCell()
        }
        
        let contato:Usuario = contatos[indexPath.row] as! Usuario
        
        var cell:UITableViewCell? = self.tvContatos.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell()
        }
        
        cell!.textLabel?.text = contato.Nome
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.contatos == nil){
            return 0
        }
        
        return self.contatos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: {
            let conversa = Conversa()
            conversa.IdProfessor = (self.contatos[indexPath.row] as! Usuario).Id
            conversa.IdAluno = (self.aluno.Id)
            conversa.NomeAluno = self.aluno.Nome
            conversa.NomeProfessor = (self.contatos[indexPath.row] as! Usuario).Nome
            conversa.Tipo = Conversa.TIPOCONVERSA_CONVERSA
            
            self.viewControllerPai?.performSegueWithIdentifier("mensagemSegue", sender: conversa)
        })
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
}