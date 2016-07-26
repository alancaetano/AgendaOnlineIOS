

import UIKit

class ConversaViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

    @IBOutlet var tvConversas: UITableView!
    
    @IBAction func abrirNovaConversa(sender: AnyObject) {
        let alunos:NSArray! = Contexto.RecuperarAlunos()
        
        if(alunos.count == 1){
            performSegueWithIdentifier("contatosmodal", sender: (alunos[0] as! Aluno))
        }else{
            abrirDropdown()
        }
    }

    var dropdown:SelecionarAlunoViewController!
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MensagemViewController.notificacaoRecebida(_:)), name: "mensagem", object: nil)
        
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
        cell.NomeAluno.text = StringUtil.RecuperarPrimeiroNome(conv.NomeAluno)
        cell.DataUltimaMensagem.text = FormatacaoData.Formatar(conv.DataUltimaMensagem)
        cell.TextoUltimaMensagem.text = conv.TextoUltimaMensagem
        
        switch(conv.Tipo){
            case Conversa.TIPOCONVERSA_CONVERSA: cell.Icone.image = UIImage(named: Recursos.IMAGEM_CONVERSA)
            case Conversa.TIPOCONVERSA_COMUNICADO_SIMPLES: cell.Icone.image = UIImage(named: Recursos.IMAGEM_COMUNICADO_SIMPLES)
            case Conversa.TIPOCONVERSA_COMUNICADO_SIMOUNAO: cell.Icone.image = UIImage(named: Recursos.IMAGEM_COMUNICADO_SIM_NAO)
            case Conversa.TIPOCONVERSA_COMUNICADO_CONFIRMACAO: cell.Icone.image = UIImage(named: Recursos.IMAGEM_COMUNICADO_CONFIRMACAO)
            default: break
        }
        
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
        
        if(segue.identifier == "loginmodal"){
            return
        }
        
        if(segue.identifier == "perfissegue"){
            return
        }
        
        if(segue.identifier == "contatosmodal"){
            let tblViewController = segue.destinationViewController as! ContatosViewController
            tblViewController.aluno = sender as! Aluno
            tblViewController.viewControllerPai = self
            
            return
        }
        
        let tblViewController = segue.destinationViewController as! DetalheConversaBaseViewController
        
        if(self.tvConversas.indexPathForSelectedRow == nil){
            let conversaNova = sender as! Conversa!
            tblViewController.conversa = conversaNova
        }else{
            tblViewController.conversa = conversas![self.tvConversas.indexPathForSelectedRow!.row] as! Conversa
        }

    }
    
    func carregarConversas(){
        self.conversas = []
        self.tvConversas.allowsSelection = false
        let url: String =  "\(Servico.API_GETCONVERSAS)\(Contexto.Recuperar(Contexto.CHAVE_ID_USUARIO) as! String)/"
        
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
                conv.IdAluno = obj["IdAluno"] as! String
                conv.NomeProfessor = obj["NomeProfessor"] as! String
                conv.NomeAluno = obj["NomeAluno"] as! String
                
                if let dataUltimaMensagem = obj["UltimaMensagemDataEnvio"] as? String{
                    conv.DataUltimaMensagem = FormatacaoData.StringParaData(dataUltimaMensagem as String)
                }
                
                if let msgTxt = obj["UltimaMensagemTexto"] as? String  {
                    conv.TextoUltimaMensagem = msgTxt
                }else{
                    conv.TextoUltimaMensagem = ""
                }
                
                conv.Tipo = obj["Tipo"] as! String
                if let resp = obj["RespostaComunicado"] as? String?{
                    conv.RespostaComunicado = resp!
                }

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
    
    func abrirDropdown(){
        dropdown = SelecionarAlunoViewController()
        dropdown.modalPresentationStyle = .Popover
        dropdown.viewControllerPai = self
        
        let presentationController = dropdown.presentationController as! UIPopoverPresentationController
        presentationController.barButtonItem = navigationItem.rightBarButtonItem
        presentationController.backgroundColor = UIColor.whiteColor()
        presentationController.delegate = self
        
        presentViewController(dropdown, animated: true, completion: nil)
    }
    
    func abrirContatosModal(alunoSelecionado: Aluno){
        self.performSegueWithIdentifier("contatosmodal", sender: alunoSelecionado)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func notificacaoRecebida(sender: NSNotification) {
        carregarConversas()
    }
}
    