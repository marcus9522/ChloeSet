import Foundation
import CoreData
import UIKit
class Persistence{
    
    var context: NSManagedObjectContext?
    
    //constructor
    init(NSManagedContext: NSManagedObjectContext){
        
        self.context = NSManagedContext
        
    }
    
    //Insert Dress into persistence [√]
    //The image type is Data -> UIImagePNGRepresentation(image)
    func insertDress(tag:[String], image:Data){
        
        //Create a new empty dress and set.
        let newDress = Dress(context: context!)
        let tags = NSSet.init()
        
        //iterate over tag string and check if exist, after that add to tags set
        for single in tag{
            var nT = checkTag(tagName: single) as Tag
            //tags.adding(nT)
            newDress.addToTag(nT)
        }
        
        //print(tags.count)
        /**for t in tags{
         //TEST
         newDress.tag?.adding(t as! Tag)
         
         }
         
         //add sets to dress **/
        
        //add category
        newDress.category = self.checkCategory(tag)
        
        //set an unique id
        newDress.id = UUID().uuidString
        
        //Save image in Document
        let filename = getDocumentsDirectory().appendingPathComponent("\(newDress.id!).png")
        try? image.write(to: filename)
        newDress.image = filename.relativePath
        
        
        //save context
        do{
            try context?.save()
            
            //test
            testInsert()
            
        }catch _ as NSError{
            print("Cannot save")
        }
    }//./ End function
    
    // [√]
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Check if a tag exist in persistence [√]
    private func checkTag(tagName:String) -> Tag {
        
        do {
            
            //Get the tag with name equal to function parameter
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tag")
            fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", tagName)
            var result = try context?.fetch(fetchRequest)
            
            
            //If result isn't empty  return the tag otherwise return a new tag
            if !(result?.isEmpty)! {
                
                return (result?.popLast() as? Tag)!
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let tag = Tag(context: context!)
        tag.name = tagName
        return tag
        
        
    }//./End Function
    
    
    //Get Dress by ID [√]
    func getDress(dressID:String) -> Dress?{
        
        do{
            
            //Get dress
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tag")
            fetchRequest.predicate = NSPredicate(format: "id ==[c] %@", dressID)
            var result = try context?.fetch(fetchRequest)
            
            //get the unique result
            let dress = result?.popLast() as! Dress
            
            return dress
            
        }catch _ as NSError {
            print("Cannot fetch")
        }
        
        return nil
    }
    
    //Insert the outfit in Persistence [√]
    func insertOutfit(DressesID:[String]){
        
        do{
            
            //Download from CoreData the dresses as NSSet
            let dresses = getDressesByIDs(IDs: DressesID)
            
            
            //Create a new Outfit and add the dresses
            let newOutfit = Outfit(context: context!)
            newOutfit.addToDress(dresses)
            
            //Add outfit to Persistence
            try context?.save()
            
            
        }catch _ as NSError {
            print("Cannot create outfit")
        }
        
    }
    
    
    //Get a list of Dress by IDs [√]
    private func getDressesByIDs(IDs: [String]) -> NSSet {
        
        let dresses = NSSet()
        
        for id in IDs{
            
            dresses.adding(getDress(dressID: id)! as Dress)
            
        }
        
        return dresses
        
    }
    
    
    
    //getAllOutfit [√]
    func getAllOutfit() -> NSSet{
        
        
        do{
            
            //Get outfits
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Outfit")
            let result = try context?.fetch(fetchRequest)
            
            return NSSet(array: result! as! [Outfit])
            
        }catch _ as NSError{
            print("Cannot fetch all the outfit")
        }
        
        //return empty set
        return NSSet()
        
    }
    
    
    //Return UIImage
    func getImage(imagePath : String) -> UIImage{
        
        
        return UIImage(contentsOfFile: imagePath)!
        
    }
    
    //getAllDresses [√]
    //Return [String:NSSet]
    func getAllDresses() -> [String:NSSet]{
        
        var output = [String:NSSet]()
        
        do{
            
            //Get dresses
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dress")
            
            //Fetch shoes
            fetchRequest.predicate = NSPredicate(format: "category ==[c] %@", "Shoe")
            let shoes = try context?.fetch(fetchRequest)
            
            //Fetch pants
            fetchRequest.predicate = NSPredicate(format: "category ==[c] %@", "BottomWear")
            let pants = try context?.fetch(fetchRequest)
            
            //Fetch shirt
            fetchRequest.predicate = NSPredicate(format: "category ==[c] %@", "TopWear")
            let shirt = try context?.fetch(fetchRequest)
            
            
            //Add the result to dictionary
            output["Shoe"] = NSSet(array: shoes! as! [Dress])
            output["BottomWear"] = NSSet(array: pants! as! [Dress])
            output["TopWear"] = NSSet(array: shirt! as! [Dress])
            
            return output
            
        }catch _ as NSError{
            print("Cannot fetch all the dresses")
        }
        
        return output
    }
    
    //Search outfits [x]
    func searchOutfit() -> NSSet{
        
        do{
            
            //instantiate request
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Outfit")
            
            // ---- Make here the predicate ----
            
            //fetch request
            let result = try context?.fetch(fetchRequest)
            
            //return output
            return NSSet(array: result! as! [Outfit])
            
        }catch _ as NSError{
            print("Cannot search the outfit")
        }
        
        return NSSet()
    }
    
    
    
    //Search Dress [x]
    func searchDress() -> NSSet{
        
        do{
            
            //instantiate request
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dress")
            
            // ---- Make here the predicate ----
            
            
            //fetch request
            let result = try context?.fetch(fetchRequest)
            
            //return outputs
            return NSSet(array: result! as! [Outfit])
            
        }catch _ as NSError{
            print("Cannot search the dresses")
        }
        
        return NSSet()
    }
    
    func testInsert(){
        
        do{
            
            //instantiate request
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dress")
            
            
            //fetch request
            let result = try context?.fetch(fetchRequest)
            
            for r in result!{
                
                var d = r as! Dress
                
                print("Dress: \(d.id)")
                print("Il dress ha \(d.tag?.count) tag")
                print("Imamgine: \(d.image!) ")
                print(d.category!)
                
                print()
                
            }
            
            
        }catch _ as NSError{
            print("Cannot search the dresses")
        }
    }
    
    func checkCategory(_ tags : [String]) -> String?{
        
        let shoe = ["Shoe","footw"]
        let bottomWear = ["pant", "jean", "leggi","trous","den"]
        let topWear = ["shirt", "sweater", "jacket"]
        
        
        //check if is a shoe
        for tag in tags{
            
            for s in shoe {
                if tag.contains(s){
                    return "Shoe"
                }
            }
            
        }
        
        //check if is a bottomWear
        for tag in tags{
            
            for bW in bottomWear {
                if tag.contains(bW){
                    return "BottomWear"
                }
            }
            
        }
        
        //check if is a topWear
        for tag in tags{
            
            for tW in topWear {
                if tag.contains(tW){
                    return "TopWear"
                }
            }
            
        }
        
        return "TopWear"
    }
}

