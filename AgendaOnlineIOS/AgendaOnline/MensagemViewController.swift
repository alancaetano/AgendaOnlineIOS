

import UIKit
import Foundation

class MensagemViewController: DetalheConversaBaseViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tvMensagens: UITableView!
    
    @IBOutlet weak var tecladoBaseConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewDigitarMensagem: UITextField!
    
    @IBOutlet var viewBase: UIView!
    
    var mensagens: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var fezScroll:Bool = false
    
    var tecladoEstaAberto = false
    
    var alturaTeclado = 0.0

	override func viewDidLoad() {
        
		super.viewDidLoad()
        
        self.tvMensagens.tableFooterView = UIView()
        self.tvMensagens.dataSource = self
        self.tvMensagens.delegate = self
        self.tvMensagens.estimatedRowHeight = 78
        self.tvMensagens.rowHeight = UITableViewAutomaticDimension
        
        self.textViewDigitarMensagem.delegate = self;
        
		self.title = self.conversa.NomeProfessor

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        registrarConversaParaReceberNotificacao();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MensagemViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        self.indicadorCarregamento.Iniciar()
        
        carregarMensagens()
    }
    
    func registrarConversaParaReceberNotificacao()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.notificacaoRecebida(_:)), name: self.conversa.Id, object: nil)
    }

    func enviarNovaConversa(){
            
        let idUsuario:String! = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String
            
        let url:String! = "\(Servico.API_ENVIARNOVACONVERSA)?idUsuarioProfessor=\(conversa.IdProfessor)&idUsuarioResponsavel=\(idUsuario)&idAluno=\(conversa.IdAluno)&TipoConversa=\(Conversa.TIPOCONVERSA_CONVERSA)"
            
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: enviarNovaConversaCallback)
    }
    
    func enviarNovaConversaCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil){
            self.indicadorCarregamento.Parar()
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao consultar as mensagens.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            return
        }

        let IdConversa = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        
        self.conversa = Conversa()
        self.conversa.Id = IdConversa
        self.conversa.Tipo = Conversa.TIPOCONVERSA_CONVERSA
        
        registrarConversaParaReceberNotificacao()
        
        self.enviarMensagem()
    }
    
    func enviarMensagem(){
        let idUsuario:String! = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String
        let texto = textViewDigitarMensagem.text
        let json:NSDictionary = [ "IdUsuario":idUsuario!, "IdConversa": self.conversa.Id, "Texto":texto!]
        
        Servico.ChamarServico(Servico.API_ENVIARMENSAGEM, httpMethod: Servico.HTTPMethod_POST, json: json, callback: enviarMensagemCallback)
        
        let msg:Mensagem = Mensagem()
        msg.IdUsuario = idUsuario
        msg.IdConversa = self.conversa.Id
        msg.Texto = texto!
        self.mensagens.addObject(msg)
        self.tvMensagens.reloadData()
        
        fezScroll = false
        
        dispatch_async(dispatch_get_main_queue(), {
            self.textViewDigitarMensagem.text = ""
            self.posicionarNaUltimaMensagem(self.tvMensagens.contentSize.height - self.tvMensagens.frame.size.height)
        })
        
    }
    
    func enviarMensagemCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil){
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao enviar mensagem.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            return
        }
        
        //Verificar para notificar que foi enviado
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == ""){
            return false
        }
        
        if(self.conversa.Id == ""){
            enviarNovaConversa()
        }else{
            enviarMensagem()
        }

        return true
    }
    
    
    func carregarMensagens(){
        
        let url:String = "\(Servico.API_GETMENSAGENS)\(conversa.Id)"
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json: nil, callback: carregarMensagensCallback)
    }

    func carregarMensagensCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        
        let jsonResult: NSArray? = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
        
        //limpar o array de mensagens para nao duplicar abaixo
        self.mensagens = []
        
        if jsonResult != nil && jsonResult!.count > 0{
            for item in jsonResult! {
                let obj = item as! NSDictionary
                let msg:Mensagem = Mensagem()
                msg.Id = obj["id"] as! String
                msg.IdUsuario = obj["id_usuario"] as! String
                msg.Texto = obj["texto"] as! String
                
                if let data = obj["dt_envio"] as? String{
                    msg.DtEnvio = FormatacaoData.StringParaData(data)
                }
                
                self.mensagens.addObject(msg)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tvMensagens.reloadData()
            self.indicadorCarregamento.Parar()
        })
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mensagens.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(mensagens == nil){
            return UITableViewCell()
        }
        
        let cell:UITableViewCell? = self.tvMensagens.dequeueReusableCellWithIdentifier("msgcell") as UITableViewCell?
        
        let msg:Mensagem = mensagens![indexPath.row] as! Mensagem
        
        let idUsuarioLogado:String! = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String
        
        var msgCell:MensagemCell
        
        if(cell == nil){
            msgCell = MensagemCell()
        }else{
            msgCell = cell as! MensagemCell
        }
        
        formatarMensagem(msgCell, msgDoUsuario: idUsuarioLogado == msg.IdUsuario, texto: msg.Texto, data: msg.DtEnvio)
        
        if(!fezScroll){
            posicionarNaUltimaMensagem(tvMensagens.contentSize.height - tvMensagens.frame.size.height)
            
            if(indexPath.row == mensagens.count-1){
                fezScroll = true
            }
        }
        
        return msgCell
    }
    
    func posicionarNaUltimaMensagem(y:CGFloat){
        if(y < 0){
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tvMensagens.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        })
    }
    
    func formatarMensagem(cell:MensagemCell, msgDoUsuario:Bool, texto:String!, data:NSDate!){
        if(msgDoUsuario){
            let imageView:UIImageView = UIImageView(image: UIImage(named: Recursos.IMAGEM_BALAO_USUARIO)!)
            cell.backgroundView = imageView
            cell.TextoUsuario.text = texto
            cell.TextoUsuario.numberOfLines = 0
            cell.TextoUsuario.sizeToFit()
            
            cell.DataUsuario.text = FormatacaoData.Formatar(data)
            cell.DataUsuario.sizeToFit()
            
            cell.DataDestinatario.text = ""
            cell.TextoDestinatario.text = ""
        }else{
            let imageView:UIImageView = UIImageView(image: UIImage(named: Recursos.IMAGEM_BALAO_DESTINATARIO)!)
            cell.backgroundView = imageView
            cell.TextoDestinatario.text = texto
            cell.TextoDestinatario.numberOfLines = 0
            cell.TextoDestinatario.sizeToFit()
            
            cell.DataDestinatario.text = FormatacaoData.Formatar(data)
            cell.DataDestinatario.sizeToFit()
            
            cell.DataUsuario.text = ""
            cell.TextoUsuario.text = ""
        }
        
        cell.sizeToFit()
    }
    
    func keyboardDidShow(sender: NSNotification) {
        let info = sender.userInfo!
        let tamTeclado = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        tecladoBaseConstraint.constant = tecladoBaseConstraint.constant + tamTeclado
    
        self.posicionarNaUltimaMensagem(tvMensagens.contentSize.height - tvMensagens.frame.size.height + tamTeclado)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let tamTeclado = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        tecladoBaseConstraint.constant = tecladoBaseConstraint.constant - tamTeclado

        self.posicionarNaUltimaMensagem(tvMensagens.contentSize.height - tvMensagens.frame.size.height)
    }
    
    func notificacaoRecebida(sender: NSNotification) {
        print("tela de mensagens...notificacao recebida ")
        fezScroll = false
        carregarMensagens()
        
    }
}

