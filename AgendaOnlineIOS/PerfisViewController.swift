//
//  PerfisViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 7/12/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class PerfisViewController: UIViewController, UITabBarDelegate{
    
    @IBOutlet weak var viewCabecalho: UIView!
    
    @IBOutlet weak var labelTitulo: UILabel!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var textFieldTurma: UITextField!
    
    @IBOutlet weak var textFieldPeriodo: UITextField!
    
    @IBOutlet weak var textViewObservacao: UITextView!
    
    @IBAction func fechar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func salvar(sender: AnyObject) {
        
    }
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var alunos:NSArray! = []
    
    var viewControllerPai: ConversaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarEstilo()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        tabBar.delegate = self
        
        carregarAlunos()
        
        carregarAbas()
    }
    
    func carregarAbas(){
        let itens = NSMutableArray()
        
        for i in 0...(alunos.count-1){
            let aluno:Aluno = alunos[i] as! Aluno
            
            let tabItem = UITabBarItem()
            tabItem.title = String(aluno.Nome.characters.split(" ").first!)
            tabItem.tag = i
            
            itens.addObject(tabItem)
        }
        
        self.tabBar.items = itens as? [UITabBarItem]
    }
    
    func configurarEstiloTab(){
        let titleFontAll : UIFont = UIFont.systemFontOfSize(17.0)
        
        let attributesNormal = [
            NSForegroundColorAttributeName : UIColor.lightGrayColor(),
            NSFontAttributeName : titleFontAll
        ]
        
        let attributesSelected = [
            NSForegroundColorAttributeName : UIColor.blueColor(),
            NSFontAttributeName : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, forState: .Selected)
    }
    
    func preencherCampos(){
        let aluno:Aluno = alunos[(tabBar.selectedItem?.tag)!] as! Aluno
        
        self.textFieldNome.text = aluno.Nome
        self.textFieldPeriodo.text = aluno.Periodo
        self.textFieldTurma.text = aluno.Turma
        self.textViewObservacao.text = aluno.Observacao
    }
    
    func carregarAlunos(){
        alunos = Contexto.RecuperarAlunos()
    }
        
    func configurarEstilo(){
        viewCabecalho.backgroundColor = Cor.COR_BARRA_DE_TITULO
        
        configurarEstiloTab()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}