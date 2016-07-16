//
//  PerfisViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 7/15/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class PerfisViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tvAlunos: UITableView!
    
    var alunos:NSArray! = []
    
    @IBOutlet weak var viewCabecalho: UIView!
    
    @IBAction func voltar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvAlunos.delegate = self
        tvAlunos.dataSource = self
        
        configurarEstilo()
        
        carregarAlunos()
    }
    
    func carregarAlunos(){
        alunos = Contexto.RecuperarAlunos()
    }
    
    func configurarEstilo(){
        viewCabecalho.backgroundColor = Cor.COR_BARRA_DE_TITULO
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(alunos == nil || alunos.count==0){
            return UITableViewCell()
        }
        
        let aluno:Aluno = alunos[indexPath.row] as! Aluno
        
        var cell:UITableViewCell? = self.tvAlunos.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell()
        }
        
        cell!.textLabel?.text = aluno.Nome
        cell!.detailTextLabel?.text = aluno.Turma
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.alunos == nil){
            return 0
        }
        
        return self.alunos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alunoSelecionado = alunos[indexPath.row]
        
        performSegueWithIdentifier("perfildetalhesegue", sender: alunoSelecionado)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController: PerfilDetalheViewController = segue.destinationViewController as! PerfilDetalheViewController
        viewController.aluno = sender as! Aluno
    }
}
