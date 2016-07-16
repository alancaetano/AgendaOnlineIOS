//
//  PerfisViewController.swift
//  AgendaOnline
//
//  Created by Alan Caetano on 7/12/16.
//  Copyright © 2016 Agenda Online. All rights reserved.
//

import UIKit

class PerfilDetalheViewController: UIViewController{
    
    @IBOutlet weak var viewCabecalho: UIView!
    
    @IBOutlet weak var labelTitulo: UILabel!
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var textFieldTurma: UITextField!
    
    @IBOutlet weak var textFieldPeriodo: UITextField!
    
    @IBOutlet weak var textViewObservacao: UITextView!
    
    @IBAction func cancelar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func salvar(sender: AnyObject) {
        enviarObservacaoAluno()
    }
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var aluno:Aluno!
    
    var viewControllerPai: ConversaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarEstilo()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        preencherCampos()
        
    }
    
    func preencherCampos(){
        self.textFieldNome.text = aluno.Nome
        self.textFieldPeriodo.text = aluno.Periodo
        self.textFieldTurma.text = aluno.Turma
        self.textViewObservacao.text = aluno.Observacao
    }
    
    func enviarObservacaoAluno(){
        let json:NSDictionary = [ "IdAluno":aluno.Id, "Observacao": textViewObservacao.text]
        
        Servico.ChamarServico(Servico.API_ALTERAROBSERVACAO, httpMethod: Servico.HTTPMethod_POST, json: json, callback: enviarObservacaoAlunoCallback)
        
        self.indicadorCarregamento.Iniciar()
        
    }
    
    func enviarObservacaoAlunoCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        
        self.indicadorCarregamento.Parar()
        
        if(error != nil){
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao enviar a alteração.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            return
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        aluno.Observacao = textViewObservacao.text
        
        Contexto.AlterarAluno(aluno)
    }
    
    func configurarEstilo(){
        viewCabecalho.backgroundColor = Cor.COR_BARRA_DE_TITULO
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}