
import UIKit

class BottomWearViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var BottomWearCollectionView: UICollectionView!
    var retDresses = [String:NSSet]()
    var toShow: [Dress] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retDresses = loadDresses()
        var tmp = retDresses["BottomWear"]?.allObjects
        toShow = tmp as! [Dress]
        BottomWearCollectionView.reloadData()
        
        BottomWearCollectionView.delegate = self
        BottomWearCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Choose a BottomWear"
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottom_cell", for: indexPath) as! BottomWearCell
        
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
        
        //myImageViewPage.self.img2 = UIImage(contentsOfFile: self.toShow[indexPath.row].image!)
        //myImageViewPage.imageStore.setImage(UIImage(contentsOfFile: self.toShow[indexPath.row].image!)!, forKey: "bottomwear")
         self.navigationController?.popViewController(animated: true)
    }
    
    
}
