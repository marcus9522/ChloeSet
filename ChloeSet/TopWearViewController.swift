
import UIKit

class TopWearViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var TopWearCollectionView: UICollectionView!
    var retDresses = [String:NSSet]()
    var toShow: [Dress] = []
    var imagestore: ImageStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retDresses = loadDresses()
        var tmp = retDresses["TopWear"]?.allObjects
        toShow = tmp as! [Dress]
        TopWearCollectionView.reloadData()

        TopWearCollectionView.delegate = self
        TopWearCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Choose a TopWear"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDresses() -> [String:NSSet]{
        
        //Convert image to Data and save it
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let pers = Persistence(NSManagedContext: managedContext!)
        
        return pers.getAllDresses()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topwear_cell", for: indexPath) as! TopWearCell
        
        var dtShow = toShow[indexPath.row] as Dress
        print(dtShow.image!)
        
        var image = UIImage(contentsOfFile: dtShow.image!)
        cell.updateWithImage(image)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        let myImageViewPage:InsertOutfitViewController = self.storyboard?.instantiateViewController(withIdentifier: "InsertOutfitViewController") as! InsertOutfitViewController
        
        //myImageViewPage.selectedImage = self.toShow[indexPath.row].image
        
       // myImageViewPage.self.img = UIImage(contentsOfFile: self.toShow[indexPath.row].image!)
        //imagestore.setImage(self.toShow[indexPath.row].image!, forKey: "topwear"))
        
        //myImageViewPage.imageStore.setImage(UIImage(contentsOfFile: self.toShow[indexPath.row].image!)!, forKey: "topwear")
        self.navigationController?.popViewController(animated: true)
    }


}
