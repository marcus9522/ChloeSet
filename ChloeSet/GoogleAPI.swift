

import Foundation
import SwiftyJSON
class GoogleAPI {
    
    private let session = URLSession.shared
    private let ImageAnalyzeQueue = DispatchQueue(label: "com.imagedetection.googlevisionapi.q") //
    
    private let googleAPIKey = "AIzaSyB2I59wU56px9pABn0REUFTw8NCZXL2f7o"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    
    /** Function that take in input the Image and next function for parse the result **/
    func analyzePicture(image:UIImage, nextFunction: @escaping (_ ParseResult:[String]) -> (Void) ){
        
        // Encode image in base64
        let imageEncoded = encode(image: image)
        
        // http response
        self.annotate( content: imageEncoded!, nextFunction )
        
    }
    
    
    private func analyze(dataToParse: Data)->[String]?{
        
        // Use SwiftyJSON to parse results
        let json = JSON(data: dataToParse)
        let errorObj: JSON = json["error"]
        
        // Check for errors -> return nil
        if errorObj.dictionaryValue != [:] { return nil }
        
        //parse response
        let responses: JSON = json["responses"][0]
        let labelAnnotations: JSON = responses["labelAnnotations"]
        
        // num of label
        let numLabels: Int = labelAnnotations.count
        
        var labels: Array<String> = []
        var labelAndScore = [Double:String]()
        
        if numLabels > 0 {
            
            // For each label
            for index in 0..<numLabels {
                
                //Create label and append to the labels
                let label = labelAnnotations[index]["description"].stringValue
                labels.append(label)
                //Create labe with score
                labelAndScore[labelAnnotations[index]["score"].double!] = labelAnnotations[index]["description"].stringValue
            }//./ End for
            
            //If the request is a Dress OK
            if (isDress(label: labelAndScore)) {
                print("i'm here")
                return labels
            }
            
        }//./ End if
        
        //The request isn't a Dress
        return Array<String>()
    }
    
    
    private func isDress(label: [Double:String]) -> Bool{
        print("E' un vestito?")
        /** Check if a word in label is contained in the accepted label **/
        for l in label { //for each in label
            
            //check if the score is > 0.75 and check if the label is permitted
            if l.key >= 0.60 && (l.value.contains("wear") ||
                l.value.contains("cloth") ||
                l.value.contains("shirt") ||
                l.value.contains("jeans") ||
                l.value.contains("shoe")  ||
                l.value.contains("jacket")) {
                print("E' un dress")
                return true
            }
        }
        return false
        
    }
    
    //Create the HTTP POST request and getting data to analyze
    fileprivate func annotate( content: String, _ nextFunction: @escaping (_ ParseResult:[String]) -> (Void) ) -> URLSessionDataTask?{
        
        if let url = URL(string: "\(googleURL)") {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonRequest: [String: Any] = [
                "requests": [
                    "image": ["content": content],
                    "features": [
                        ["type": "LABEL_DETECTION", "maxResults": 7],
                    ]
                ]]
            
            do {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: { (data, response, error)  in
                    
                    if error != nil {
                    } else{
                        DispatchQueue.main.async(execute: {
                            nextFunction(self.analyze(dataToParse: data!)!)
                        })
                        
                        
                    }
                })
                
                task.resume()
                
            } catch _ {} //./End do
        }
        return nil
    }//./End function
    
    //Econde image in base64 or resize it if too large
    private func encode(image: UIImage) -> String? {
        
        if let imagedata = UIImagePNGRepresentation(image)  {
            
            
            if imagedata.count > 2097152 {
                
                let oldsize = image.size
                let newsize = CGSize(width: 800, height: oldsize.height / oldsize.width * 800)
                
                // IF
                if let newimagedata = resize(image: image, to: newsize) {
                    
                    return newimagedata.base64EncodedString(options: .endLineWithCarriageReturn)
                    
                } else { return nil } // End if
                
            } else {
                
                return imagedata.base64EncodedString(options: .endLineWithCarriageReturn)
                
            }//./ End if imagedata.count
            
        } //End if imagedata...
        
        return nil
        
    } //./ End function
    
    //Resize Image and get the data of the image taking image and new size (800x800) [√]
    fileprivate func resize(image: UIImage, to size: CGSize) -> Data? {
        
        UIGraphicsBeginImageContext(size)
        var resizedImage: Data? = nil
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            resizedImage = UIImagePNGRepresentation(newImage)
        }
        
        UIGraphicsEndImageContext()
        return resizedImage
        
    }//./ End function
    
    
}
