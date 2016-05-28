

import UIKit
import Foundation

class MensagemViewController: DetalheConversaBaseViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tvMensagens: UITableView!
    
    @IBOutlet weak var tecladoBaseConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewDigitarMensagem: UITextField!
    
    @IBOutlet var viewBase: UIView!
    
    @IBOutlet weak var alturaTableView: NSLayoutConstraint!
    
    var mensagens: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var fezScroll:Bool = false

	override func viewDidLoad() {
        
		super.viewDidLoad()
        
        self.tvMensagens.tableFooterView = UIView()
        self.tvMensagens.dataSource = self
        self.tvMensagens.delegate = self
        self.tvMensagens.estimatedRowHeight = 80
        self.tvMensagens.rowHeight = UITableViewAutomaticDimension
        
        self.textViewDigitarMensagem.delegate = self;
        
		self.title = self.conversa.NomeProfessor

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        carregarMensagens()
    }
    
    func enviarNovaConversa(){
        
        let idAluno = "B5C486CA-9537-4D34-BDC7-8FFFED0DCC2C"
            
        let idUsuario:String! = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String
            
        let url:String! = "\(Servico.API_ENVIARNOVACONVERSA)?idUsuarioProfessor=\(conversa.IdProfessor)&idUsuarioResponsavel=\(idUsuario)&idAluno=\(idAluno)&TipoConversa=\(Conversa.TIPOCONVERSA_CONVERSA)"
            
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
        
        self.textViewDigitarMensagem.text = ""
        
        self.tvMensagens.reloadData()
        
        self.tvMensagens.setContentOffset(CGPoint(x: 0, y: CGFloat.max), animated: false)
        
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
        
        self.indicadorCarregamento.Iniciar()
        
        let url:String = "\(Servico.API_GETMENSAGENS)\(conversa.Id)"
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json: nil, callback: carregarMensagensCallback)

    }

    func carregarMensagensCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        
        let jsonResult: NSArray? = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
        
        if jsonResult != nil && jsonResult!.count > 0{
            for item in jsonResult! {
                let obj = item as! NSDictionary
                let msg:Mensagem = Mensagem()
                msg.Id = obj["id"] as! String
                msg.IdUsuario = obj["id_usuario"] as! String
                msg.Texto = obj["texto"] as! String
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
        let cell:UITableViewCell? = self.tvMensagens.dequeueReusableCellWithIdentifier("msgcell") as UITableViewCell?
        
        let msg:Mensagem = mensagens![indexPath.row] as! Mensagem
        
        let idUsuarioLogado:String! = Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String
        
        var msgCell:MensagemCell
        
        if(cell == nil){
            msgCell = MensagemCell()
        }else{
            msgCell = cell as! MensagemCell
        }
        
        formatarMensagem(msgCell, msgDoUsuario: idUsuarioLogado == msg.IdUsuario, texto: msg.Texto)

        if(!fezScroll){
            posicionarNaUltimaMensagem()
            fezScroll = true
        }
        
        return msgCell
    }
    
    func posicionarNaUltimaMensagem(){
        tvMensagens.setContentOffset(CGPoint(x: 0, y: CGFloat.max), animated: false)
    }
    
    func formatarMensagem(cell:MensagemCell, msgDoUsuario:Bool, texto:String!){
        if(msgDoUsuario){
            let imageView:UIImageView = UIImageView(image: UIImage(named: "balaousuario.png")!)
            cell.backgroundView = imageView
            cell.TextoUsuario.text = texto
            cell.TextoUsuario.numberOfLines = 0
            cell.TextoUsuario.sizeToFit()
            
            cell.TextoDestinatario.text = ""
        }else{
            let imageView:UIImageView = UIImageView(image: UIImage(named: "balaodestinatario.png")!)
            cell.backgroundView = imageView
            cell.TextoDestinatario.text = texto
            cell.TextoDestinatario.numberOfLines = 0
            cell.TextoDestinatario.sizeToFit()
            
            cell.TextoUsuario.text = ""
        }
        
        cell.sizeToFit()

    }
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let tamTeclado = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        tecladoBaseConstraint.constant = tamTeclado - bottomLayoutGuide.length + 10
        alturaTableView.constant = alturaTableView.constant - tamTeclado
        
        UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let tamTeclado = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        tecladoBaseConstraint.constant = 10
        alturaTableView.constant = alturaTableView.constant + tamTeclado
        
        UIView.animateWithDuration(duration) { self.view.layoutIfNeeded() }
    }
}

