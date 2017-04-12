
import Foundation

class ItemStore: NSObject {
    
    
    var allItems = [Item]()
    
    
    func createEmptyItem() {
        
        
        let emstr = NSLocalizedString("newEmpty", comment: "empty item")
        
        let item = Item(name: emstr, itemdescription: emstr, quantity: 0)
        
        
        allItems.append(item)
        
        
        
        
    }
    
    func moveItem (from srcidx:Int, to dstidx:Int) {
        
        
        let srcItem = allItems[srcidx]
        
        
        
        allItems.remove(at: srcidx)
        
        allItems.insert(srcItem, at: dstidx)
        
        
    }
    
    
    
    
}
