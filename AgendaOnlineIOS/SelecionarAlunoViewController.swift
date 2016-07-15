//
//  SelecionarAlunoViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 6/12/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import Foundation
import UIKit

class SelecionarAlunoViewController:UITableViewController{
    
    @IBOutlet var tvAlunos: UITableView!
    
    var alunos:NSArray! = []
    var viewControllerPai: ConversaViewController?
    
    override func viewDidLoad() {
        alunos = Contexto.RecuperarAlunos()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(alunos == nil || alunos.count==0){
            return UITableViewCell()
        }
        
        let aluno:Aluno = alunos[indexPath.row] as! Aluno
        
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell()
        }
        
        cell!.textLabel?.text = aluno.Nome
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.alunos == nil){
            return 0
        }
        
        return self.alunos.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: {
            self.viewControllerPai?.abrirContatosModal(self.alunos[indexPath.row] as! Aluno)
        })
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}