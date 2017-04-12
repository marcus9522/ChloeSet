
import UIKit
import SwiftyJSON
import TagListView
import CoreData

class InsertDressViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TagListViewDelegate {
    
    @IBOutlet weak var tags: TagListView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelResults:UILabel!
    let imagePicker = UIImagePickerController()
    var array = [String]()
    var api:GoogleAPI = GoogleAPI()
    
    @IBOutlet weak var save: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActionSheet()
        save.isHidden = true
        tags.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker,animated:true,completion:nil)
        }else{
            print("Camera not available")
        }
        
    }
    
    func choiceLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker,animated:true,completion:nil)
        }else{
            print("Library not available")
        }
        
    }
    
    func lastTaken() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            present(imagePicker,animated:true,completion:nil)
        }else{
            print("Last Photos not available")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion:nil)
        
        func nextf (_ ParseResult: [String]) -> (Void){
            
            print("Numero di tag: \(ParseResult.count)")
            if(ParseResult.count > 0){
                self.save.isHidden = false
                }
            else{
                self.showerror()
            }
            
            for tag in ParseResult{
                self.array.append(tag)
                newtag(a: tag)
            }
            if(ParseResult.count > 0){
                addtag()
            }
            
        }
       
        api.analyzePicture(image: image, nextFunction: nextf)
        
    }

    private let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
    
    private func showActionSheet() {
        
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {action in self.choiceLibrary()})
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in self.takePicture()})
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in self.navigationController?.popViewController(animated: true)})
        
        
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancel)
        
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func insertDress() {
        
        //Convert image to Data and save it
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let pers = Persistence(NSManagedContext: managedContext)
        
        var imageToSave = UIImagePNGRepresentation(self.imageView.image!)
        pers.insertDress(tag: self.array, image: imageToSave!)
        self.savealert()
        
        
    }
    func insert(){
        let alert = UIAlertController(title: "New Tag", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Insert Here"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text!)")
            
            self.newtag(a: textField!.text!)
            self.addtag()
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showerror(){
        let errore = "Nessun tag trovato"
        let alert = UIAlertController(title: errore, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            _ = self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func savealert(){
        let messaggio = "Saved"
        let alert = UIAlertController(title: messaggio, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            _ = self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func addtag(){
        
        let addview = self.tags.addTag("+")
        addview.tagBackgroundColor = UIColor.red
        addview.onTap = { addview in
            self.tags.removeTag("+")
            self.insert()
            
        }
    }
    
    func newtag(a: String) {
        if a != "" {
            let tag = self.tags.addTag("\(a)")
            self.array.append("\(a)")
            tag.onTap = { tagView in
                for index in 0...self.array.count - 1{
                    print(self.array[index])
                    if self.array[index] == tag.titleLabel!.text!{
                        self.array.remove(at: index)
                        break
                    }
                }
                self.tags.removeTag(tag.titleLabel!.text!)
            }
        }
    }
    
}
