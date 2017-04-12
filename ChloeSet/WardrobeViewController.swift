
import UIKit
import SwiftyJSON
class WardrobeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var navigatorControl: UISegmentedControl!
    @IBOutlet weak var MyCollectionView: UICollectionView!
    let loc = GetLocation()
    var retDresses = [String:NSSet]()
    var toShow: [Dress] = []
    @IBOutlet weak var segueButton: UIBarButtonItem!
    @IBOutlet weak var WeatherButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retDresses = loadDresses()
        var tmp = retDresses["Shoe"]?.allObjects
        toShow = tmp as! [Dress]
        MyCollectionView.reloadData()
        
        MyCollectionView.delegate = self
        MyCollectionView.dataSource = self
        navigatorControl.removeBorders()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "My Wardrobe"
        retDresses = loadDresses()
        MyCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func changeLayout(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        
        switch navigatorControl.selectedSegmentIndex {
            
        case 0: var tmp = retDresses["Shoe"]?.allObjects
        toShow = tmp as! [Dress]
        MyCollectionView.reloadData()
            
        case 1: var tmp = retDresses["BottomWear"]?.allObjects
        toShow = tmp as! [Dress]
        MyCollectionView.reloadData()
        case 2: var tmp = retDresses["TopWear"]?.allObjects
        toShow = tmp as! [Dress]
        MyCollectionView.reloadData()
            
        default: print("nil")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! myCollectionViewCell
        
        var dtShow = toShow[indexPath.row] as Dress
        print(dtShow.image!)
        
        var image = UIImage(contentsOfFile: dtShow.image!)
        cell.updateWithImage(image)
        
        return cell
    }
    
    func getWeather(city: String)  {
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(city),uk&appid=ebbc751dcb199ccedda7bc26dc6d6b5a"
        let url = URL(string: path)
        print(path)
        var dataString = "hvju"
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            let json = JSON(data: data!)
            dataString = String(data: data!, encoding: String.Encoding.utf8)!
            print(">>>> \(dataString)")
            self.changeText(valori: dataString, json: json)
            
        }
        task.resume()
    }
    func changeText(valori:String, json:JSON) {
        DispatchQueue.main.async {
            //self.TextArea.text.append("Meteo: \(valori)")
            print(json)
            let temp:Double = json["main"]["temp"].doubleValue - 273
            let humidity:Double = json["main"]["humidity"].doubleValue
            let name:String = json["name"].stringValue
            let description:String = json["weather"][0]["description"].stringValue
            let icon = json["weather"][0]["icon"].stringValue
            print(icon)
            let s = "http://openweathermap.org/img/w/\(icon).png"
            print(s)
            let final: String = "City: \(name)\nTemperature: \(temp) °C\nHumidity: \(humidity)%\nDescription: \(description)"
            let alert = UIAlertController(title: "Current Weather", message: final, preferredStyle: .alert)
            let imageView = UIImageView(frame: CGRect(x: 220,y: 10,width: 50,height: 50))
            imageView.setImageFromURl(stringImageUrl: s)
            alert.view.addSubview(imageView)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadDresses() -> [String:NSSet]{
        
        //Convert image to Data and save it
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let pers = Persistence(NSManagedContext: managedContext!)
        
        return pers.getAllDresses()
        
        
    }
    
    
    @IBAction func currentWeather(_ sender: Any) {
        loc.getAdress { result in
            let citta = result["City"]!
            print(citta)
            //self.TextArea.text = "Connect to Network to see weather informations"
            let citta2 = (citta as AnyObject).replacingOccurrences(of: " ", with: "%20")
            print(citta2)
            self.getWeather(city: "\(citta2)")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        let myImageViewPage:ZoomImageControllerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImageController") as! ZoomImageControllerViewController
        
        myImageViewPage.selectedImage = self.toShow[indexPath.row].image
        
        myImageViewPage.image = UIImage(contentsOfFile: self.toShow[indexPath.row].image!)
        
        self.navigationController?.pushViewController(myImageViewPage, animated: true)
        
    }
    
    @IBAction func insertDress(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "insertDressSegue", sender: self)
    }
    
}
