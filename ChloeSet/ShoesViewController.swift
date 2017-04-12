

import UIKit

class ShoesViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var ShoesCollectionView: UICollectionView!
    var retDresses = [String:NSSet]()
    var toShow: [Dress] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retDresses = loadDresses()
        var tmp = retDresses["Shoe"]?.allObjects
        toShow = tmp as! [Dress]
        ShoesCollectionView.reloadData()
        
        ShoesCollectionView.delegate = self
        ShoesCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Choose a Shoes"
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoes_cell", for: indexPath) as! ShoesCell
        
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
        
        //myImageViewPage.self.img3 = UIImage(contentsOfFile: self.toShow[indexPath.row].image!)
        //myImageViewPage.imageStore.setImage(UIImage(contentsOfFile: self.toShow[indexPath.row].image!)!, forKey: "shoe")
         self.navigationController?.popViewController(animated: true)
    }
    
    
}
