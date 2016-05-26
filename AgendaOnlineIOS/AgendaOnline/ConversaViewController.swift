

import UIKit

class ConversaViewController: UITableViewController{

    @IBOutlet var tvConversas: UITableView!
    
    var conversas: NSMutableArray! = []
    
    var indicator:UIActivityIndicatorView! = nil
    
    var IdUsuario:String = ""
    
    override func viewDidAppear(animated: Bool) {
        if(defaults.stringForKey("IdUsuario") != nil){
            iniciarTableView()
        }
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        if(defaults.stringForKey("IdUsuario") == nil){
            performSegueWithIdentifier("loginmodal", sender: self)
        }
	}
    
    func iniciarTableView(){
        
        IdUsuario = defaults.stringForKey("IdUsuario")!
        
        self.tvConversas.tableFooterView = UIView()
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        carregarConversas()
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell:UITableViewCell = self.tvConversas.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let conv:Conversa = conversas![indexPath.row] as! Conversa
        cell.textLabel?.text = conv.NomeProfessor
        cell.detailTextLabel?.text = conv.UltimaMensagem
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversaSelecionada = conversas![indexPath.row] as! Conversa
        
        switch(conversaSelecionada.Tipo){
            case Constantes.TIPOCONVERSA_CONVERSA:
                performSegueWithIdentifier("mensagemSegue", sender: tableView)
                break
            case Constantes.TIPOCONVERSA_COMUNICADO_SIMPLES:
                performSegueWithIdentifier("comunicadoSimplesSegue", sender: tableView)
                break
            case Constantes.TIPOCONVERSA_COMUNICADO_CONFIRMACAO:
                performSegueWithIdentifier("comunicadoConfirmacaoSegue", sender: tableView)
                break
            case Constantes.TIPOCONVERSA_COMUNICADO_SIMOUNAO:
                performSegueWithIdentifier("comunicadoComSimOuNaoSegue", sender: tableView)
                break
            default: break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
                conversaSelecionada = Conversa(Id: "", NomeProfessor: usuario.Nome, UltimaMensagem: "", IdProfessor: usuario.Id, Tipo: Constantes.TIPOCONVERSA_CONVERSA)
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
        let url: String =  Constantes.API_GETCONVERSAS + IdUsuario
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do{
                let jsonResult: NSArray! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSArray
                
                for item in jsonResult {
                    let obj = item as! NSDictionary
                    let conv:Conversa = Conversa(Id: obj["IdConversa"] as! String, NomeProfessor: obj["NomeProfessor"] as! String, UltimaMensagem: obj["UltimaMensagemTexto"] as! String, IdProfessor:"", Tipo: obj["Tipo"] as! String)
                    self.conversas.addObject(conv)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tvConversas.allowsSelection = true
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    
                })
            }catch{
                dispatch_async(dispatch_get_main_queue(), {self.indicator.stopAnimating()})
                print(error)
            }
            
        });
    }
}