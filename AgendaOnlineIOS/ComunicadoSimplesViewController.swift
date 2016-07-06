
import Foundation
import UIKit

class ComunicadoSimplesViewController: DetalheConversaBaseViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvMensagens: UITableView!
    
    var comunicado:Conversa!
    
    var mensagens: NSMutableArray! = []
    
    var indicadorCarregamento:IndicadorCarregamento!
    
    var fezScroll:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tvMensagens.delegate = self
        self.tvMensagens.dataSource = self
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        self.title = self.conversa.NomeProfessor
        
        carregarMensagens()
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
        msgCell.sizeToFit()
        
        
        return msgCell
    }
    
    func posicionarNaUltimaMensagem(y:CGFloat){
        tvMensagens.setContentOffset(CGPoint(x: 0, y: y), animated: false)
    }
}