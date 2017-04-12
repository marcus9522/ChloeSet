
import Foundation
import UIKit

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        print(url)
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
