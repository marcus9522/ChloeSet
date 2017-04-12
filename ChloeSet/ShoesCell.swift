

import UIKit
class ShoesCell: UICollectionViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    
    func updateWithImage(_ image: UIImage?) {
        
        if let imageToDisplay = image {
            //spinner.stopAnimating()
            myImageView.image = imageToDisplay
            //myImageView.transform = myImageView.transform.rotated(by: CGFloat(M_PI_2))
        }else{
            //spinner.startAnimating()
            myImageView.image = nil
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        updateWithImage(nil)
        
    }
    
}
