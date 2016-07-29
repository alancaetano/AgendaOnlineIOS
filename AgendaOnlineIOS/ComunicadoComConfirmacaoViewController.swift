
import Foundation
import UIKit

class ComunicadoComConfirmacaoViewController: DetalheConversaBaseViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvMensagens: UITableView!
    
    @IBOutlet weak var botaoConfirmar: UIButton!
    
    @IBOutlet weak var labelLeituraConfirmada: UILabel!
    
    var mensagens: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var fezScroll:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tvMensagens.delegate = self
        self.tvMensagens.dataSource = self
        self.tvMensagens.estimatedRowHeight = 78
        self.tvMensagens.rowHeight = UITableViewAutomaticDimension
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.notificacaoRecebida(_:)), name: "mensagem", object: nil)
        
        self.title = self.conversa.NomeProfessor
        
        tratarRespostaComunicado()
        
        self.indicadorCarregamento.Iniciar()
        
        carregarMensagens()
    }
    
    @IBAction func confirmarLeitura(sender: AnyObject) {
        let url:String! = "\(Servico.API_RESPONDERCOMUNICADO)?IdConversa=\(conversa.Id)&IdAluno=\(conversa.IdAluno)&resposta=\(Conversa.RESPOSTA_COMUNICADO_LIDO)"
        
        self.indicadorCarregamento.Iniciar()
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: confirmarLeituraCallback)
    }
    
    func confirmarLeituraCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil){
            self.indicadorCarregamento.Parar()
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao enviar a confirmação de leitura.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Ok", callback: {}, viewController: self)
            return
        }
        
        self.conversa.RespostaComunicado = Conversa.RESPOSTA_COMUNICADO_LIDO
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tratarRespostaComunicado()
            self.indicadorCarregamento.Parar()
        })
    }
    
    func tratarRespostaComunicado(){
        if(conversa.RespostaComunicado == Conversa.RESPOSTA_COMUNICADO_LIDO){
            self.botaoConfirmar.hidden = true
            self.labelLeituraConfirmada.hidden = false
        }else{
            self.botaoConfirmar.hidden = false
            self.labelLeituraConfirmada.hidden = true
        }
    }
    
    func carregarMensagens(){        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mensagens.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(mensagens == nil){
            return UITableViewCell()
        }
        
        let cell:UITableViewCell? = self.tvMensagens.dequeueReusableCellWithIdentifier("msgcell") as UITableViewCell?
        
        let msg:Mensagem = mensagens![indexPath.row] as! Mensagem
        
        var msgCell:MensagemCell
        
        if(cell == nil){
            msgCell = MensagemCell()
        }else{
            msgCell = cell as! MensagemCell
        }
        
        let imageView:UIImageView = UIImageView(image: UIImage(named: Recursos.IMAGEM_BALAO_DESTINATARIO)!)
        msgCell.backgroundView = imageView
        msgCell.TextoDestinatario.text = msg.Texto
        msgCell.TextoDestinatario.numberOfLines = 0
        msgCell.TextoDestinatario.sizeToFit()
        
        msgCell.DataDestinatario.text = FormatacaoData.Formatar(msg.DtEnvio)
        msgCell.DataDestinatario.sizeToFit()
        
        msgCell.sizeToFit()
        
        if(!fezScroll){
            posicionarNaUltimaMensagem(tvMensagens.contentSize.height - tvMensagens.frame.size.height)
            
            if(indexPath.row == mensagens.count-1){
                fezScroll = true
            }
        }
        
        return msgCell
    }
    
    func posicionarNaUltimaMensagem(y:CGFloat){
        dispatch_async(dispatch_get_main_queue(), {
            self.tvMensagens.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        })
    }
    
    func notificacaoRecebida(sender: NSNotification) {
        fezScroll = false
        carregarMensagens()
    }
}