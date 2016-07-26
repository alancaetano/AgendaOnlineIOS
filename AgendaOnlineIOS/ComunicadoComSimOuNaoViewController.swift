
import Foundation
import UIKit

class ComunicadoComSimOuNaoViewController: DetalheConversaBaseViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvMensagens: UITableView!
    
    @IBOutlet weak var labelRespostaEnviada: UILabel!
    
    @IBOutlet weak var botaoSim: UIButton!
    
    @IBOutlet weak var botaoNao: UIButton!
    
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
        
        self.title = self.conversa.NomeProfessor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.notificacaoRecebida(_:)), name: "mensagem", object: nil)
        
        tratarRespostaComunicado()
        
        self.indicadorCarregamento.Iniciar()
        
        carregarMensagens()
    }
    
    
    @IBAction func botaoNaoPressionado(sender: AnyObject) {
        enviarResposta(Conversa.RESPOSTA_COMUNICADO_NAO)
    }
    
    @IBAction func botaoSimPressionado(sender: AnyObject) {
        enviarResposta(Conversa.RESPOSTA_COMUNICADO_SIM)
    }
    
    func enviarResposta(resposta:String!) {
        let url:String! = "\(Servico.API_RESPONDERCOMUNICADO)?IdConversa=\(conversa.Id)&IdAluno=\(conversa.IdAluno)&resposta=\(resposta)"
    
        self.indicadorCarregamento.Iniciar()
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: enviarRespostaCallback)
    }
    
    func enviarRespostaCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
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
        if(conversa.RespostaComunicado != ""){
            self.botaoSim.hidden = true
            self.botaoNao.hidden = true
            self.labelRespostaEnviada.hidden = false
        }else{
            self.botaoSim.hidden = false
            self.botaoNao.hidden = false
            self.labelRespostaEnviada.hidden = true
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