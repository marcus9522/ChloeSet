//
//  ZoomImageControllerViewController.swift
//  ChloeSet
//
//  Created by Emanuele Buonincontri on 06/04/17.
//  Copyright © 2017 Emanuele Buonincontri. All rights reserved.
//

import UIKit
class ZoomImageControllerViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    var selectedImage:String!
    var image: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        //myImageView.transform = myImageView.transform.rotated(by: CGFloat(M_PI_2))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let imageUrl = NSURL(string: self.selectedImage)
        //let imageData = NSData(contentsOf: imageUrl! as URL)
        print(image == nil)
        self.myImageView.image  = image!
        
        
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
