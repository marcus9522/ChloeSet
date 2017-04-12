
import Foundation

class Item: NSObject {
    
    var name:String
    var itemdescription: String
    var quantity:Int
    var datecreated: Date
    
    
    init(name:String, itemdescription:String, quantity:Int) {
        
        self.name = name
        self.itemdescription = itemdescription
        self.quantity = quantity
        self.datecreated = Date()
        
    }
    
    
    
}
