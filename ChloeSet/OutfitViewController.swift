
import UIKit
import SwiftyJSON
class OutfitViewController: UIViewController{

    @IBOutlet weak var WeatherButton: UIBarButtonItem!
    //@IBOutlet weak var AddButton: UIBarButtonItem!
    let loc = GetLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "My Outfit"
    }
    /*
    @IBAction func insertOutfit(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "insertOutfitSegue", sender: self)
    }
    */
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
