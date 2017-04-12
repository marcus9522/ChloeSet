
import UIKit

class InsertOutfitViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var TopWearCollectionView: UICollectionView!
    @IBOutlet weak var BottomWearCollectionView: UICollectionView!
    @IBOutlet weak var ShoesCollectionView: UICollectionView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!

    var retDresses = [String:NSSet]()
    var toShow1: [Dress] = []
    var toShow2: [Dress] = []
    var toShow3: [Dress] = []
    var imagestore: ImageStore!
    var top: String!
    var selectedCell: UICollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retDresses = loadDresses()
        top = ""
        var tmp1 = retDresses["TopWear"]?.allObjects
        toShow1 = tmp1 as! [Dress]
        var tmp2 = retDresses["BottomWear"]?.allObjects
        toShow2 = tmp2 as! [Dress]
        var tmp3 = retDresses["Shoe"]?.allObjects
        toShow3 = tmp3 as! [Dress]
        
        TopWearCollectionView.reloadData()
        BottomWearCollectionView.reloadData()
        ShoesCollectionView.reloadData()
        
        TopWearCollectionView.delegate = self
        BottomWearCollectionView.delegate = self
        ShoesCollectionView.delegate = self
       
        TopWearCollectionView.dataSource = self
        BottomWearCollectionView.dataSource = self
        ShoesCollectionView.dataSource = self
        
        //self.view.addSubview(TopWearCollectionView)
        //self.view.addSubview(BottomWearCollectionView)
        //self.view.addSubview(ShoesCollectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Insert"
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
        return toShow1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.TopWearCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topwear_cell", for: indexPath as IndexPath) as! TopWearCell
            let dtShow1 = toShow1[indexPath.row] as Dress
            let image1 = UIImage(contentsOfFile: dtShow1.image!)
            cell.updateWithImage(image1)
            return cell
        }
            
        else {
            if collectionView == self.BottomWearCollectionView {
                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomwear_cell", for: indexPath as IndexPath) as! BottomWearCell
                let dtShow2 = toShow2[indexPath.row] as Dress
                let image2 = UIImage(contentsOfFile: dtShow2.image!)
                cell2.updateWithImage(image2)
                return cell2
            }
            else {
                if collectionView == self.ShoesCollectionView {
                    let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "shoes_cell", for: indexPath as IndexPath) as! ShoesCell
                    let dtShow3 = toShow3[indexPath.row] as Dress
                    let image3 = UIImage(contentsOfFile: dtShow3.image!)
                    cell3.updateWithImage(image3)
                    return cell3
                }
            }
        }
    return selectedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedCell = TopWearCollectionView.cellForItem(at: indexPath)
        //selectedCell?.backgroundColor = UIColor.red
        //TopWearCollectionView.reloadData()
        top = self.toShow1[indexPath.row].image!
        img1.image = UIImage(contentsOfFile: top)
        print(top)
        
        top = self.toShow2[indexPath.row].image!
        img2.image = UIImage(contentsOfFile: top)
        print(top)
        
        top = self.toShow3[indexPath.row].image!
        img2.image = UIImage(contentsOfFile: top)
        print(top)
    }
    
}
