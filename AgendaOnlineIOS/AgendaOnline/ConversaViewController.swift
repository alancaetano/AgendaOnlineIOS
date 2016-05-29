

import UIKit

class ConversaViewController: UITableViewController{

    @IBOutlet var tvConversas: UITableView!
    
    var indicadorCarregamento:IndicadorCarregamento!
    var conversas: NSMutableArray! = []
    
    override func viewDidAppear(animated: Bool) {
        
        if(Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) != nil){
            iniciarTableView()
        }
    }
    
    func configurarEstilo(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Cor.COR_BARRA_DE_TITULO
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarEstilo()
        
        self.indicadorCarregamento = IndicadorCarregamento(view: self.view)
        
        if((Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO)) == nil){
            performSegueWithIdentifier("loginmodal", sender: self)
        }
	}
    
    func iniciarTableView(){
        self.indicadorCarregamento.Iniciar()
        
        carregarConversas()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(conversas == nil || conversas!.count == 0){
            return 0
        }
        
        return self.conversas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        if(conversas == nil || conversas!.count == 0){
            return UITableViewCell()
        }
        
        let cell:ConversaCell = self.tvConversas.dequeueReusableCellWithIdentifier("cell")! as! ConversaCell
        
        let conv:Conversa = conversas![indexPath.row] as! Conversa
        cell.NomeProfessor.text = conv.NomeProfessor
        cell.NomeAluno.text = conv.NomeAluno
        cell.DataUltimaMensagem.text = FormatacaoData.Formatar(conv.DataUltimaMensagem)
        cell.TextoUltimaMensagem.text = conv.TextoUltimaMensagem
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversaSelecionada = conversas![indexPath.row] as! Conversa
        
        switch(conversaSelecionada.Tipo){
            case Conversa.TIPOCONVERSA_CONVERSA:
                performSegueWithIdentifier("mensagemSegue", sender: tableView)
                break
            case Conversa.TIPOCONVERSA_COMUNICADO_SIMPLES:
                performSegueWithIdentifier("comunicadoSimplesSegue", sender: tableView)
                break
            case Conversa.TIPOCONVERSA_COMUNICADO_CONFIRMACAO:
                performSegueWithIdentifier("comunicadoConfirmacaoSegue", sender: tableView)
                break
            case Conversa.TIPOCONVERSA_COMUNICADO_SIMOUNAO:
                performSegueWithIdentifier("comunicadoComSimOuNaoSegue", sender: tableView)
                break
            default: break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //tratando segue para a tela de login
        if(segue.identifier == "loginmodal"){
            return
        }
        //tratando segue para a tela de contatos
        if(segue.identifier == "contatosmodal"){
            let tblViewController = segue.destinationViewController as! ContatosViewController
            tblViewController.parent = self
        }else{
        //tratando segue para a tela de mensagens
            var conversaSelecionada:Conversa! = nil
            
            //se o sender eh um usuario, entao eh uma nova conversa
            //seao eh uma conversa ja criada
            if let usuario = sender as? Usuario
            {
                conversaSelecionada = Conversa()
                conversaSelecionada.NomeProfessor = usuario.Nome
                conversaSelecionada.IdProfessor = usuario.Id
                conversaSelecionada.Tipo = Conversa.TIPOCONVERSA_CONVERSA
            }else{
                let indexPath:NSIndexPath = self.tvConversas.indexPathForSelectedRow!
                conversaSelecionada = conversas![indexPath.row] as! Conversa
            }

            let tblViewController = segue.destinationViewController as! DetalheConversaBaseViewController
            tblViewController.conversa = conversaSelecionada
        }
    }
    
    func carregarConversas(){
        self.conversas = []
        self.tvConversas.allowsSelection = false
        let url: String =  Servico.API_GETCONVERSAS + (Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String)
        
        Servico.ChamarServico(url, httpMethod: Servico.HTTPMethod_GET, json:nil, callback: carregarConversasCallback)
    }
    
    func carregarConversasCallback(response:NSURLResponse?, data: NSData?, error: NSError?){
        if(error != nil){
            self.indicadorCarregamento.Parar()
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao realizar o consultar as conversas.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Tentar novamente", callback: {
                self.carregarConversas()
                }, viewController: self)
            return
        }
        do{
            let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
            
            for item in jsonResult {
                let obj = item as! NSDictionary
                
                let conv:Conversa = Conversa()
                conv.Id = obj["IdConversa"] as! String
                conv.NomeProfessor = obj["NomeProfessor"] as! String
                conv.NomeAluno = obj["NomeAluno"] as! String
                conv.DataUltimaMensagem = FormatacaoData.StringParaData(obj["UltimaMensagemDataEnvio"] as! String)
                conv.TextoUltimaMensagem = obj["UltimaMensagemTexto"] as! String
                conv.Tipo = obj["Tipo"] as! String
                
                self.conversas.addObject(conv)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tvConversas.reloadData()
                self.tvConversas.allowsSelection = true
                self.indicadorCarregamento.Parar()
            })
        }catch{
            self.indicadorCarregamento.Parar()
            Alerta.MostrarAlerta("Erro", mensagem: "Ocorreu um problema ao realizar o consultar as conversas.", estilo: UIAlertControllerStyle.Alert, tituloAcao: "Tentar novamente", callback: {
                    self.carregarConversas()
                }, viewController: self)
        }
    }
}