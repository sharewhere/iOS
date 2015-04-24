//
//  addItem.swift
//  ShareWhere
//
//  Created by Dale Driggs on 4/14/15.
//  Copyright (c) 2015 ShareWhere. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AssetsLibrary
import MobileCoreServices

class addItem: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet var titleConstraint: NSLayoutConstraint!

    @IBOutlet var itemTitle: UITextField!
    @IBOutlet var itemDescription: UITextField!
    @IBOutlet var itemImage: UIImageView!
    var imagePicker: UIImagePickerController!
    var server = networkService().servername() + "/makeshareableoffer";
    var hasPic = false;
    var img: UIImage!
    var imgURL: NSURL!
    var success: Bool = false;
    
    @IBAction func pictureButton(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func submitButton(sender: UIButton) {
        if(itemTitle == "") {
            var alertView: UIAlertView = UIAlertView()
            alertView.title = "Add item failed!"
            alertView.message = "Please add an item Title!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if(itemDescription == "") {
            var alertView: UIAlertView = UIAlertView()
            alertView.title = "Add item failed!"
            alertView.message = "Please add an item description!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if(imgURL == nil) {
            var alertView: UIAlertView = UIAlertView()
            alertView.title = "No picture!"
            alertView.message = "Please include a picture!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            
            println("going to upload");
            var request: NSURLRequest = createRequest(itemTitle.text, description: itemDescription.text);
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
                data, response, error in
                
                if error != nil {
                    // handle error here
                    println("Stupid errors");
                    return
                }
                
                
                var parseError: NSError?
                let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
                
                if let responseDictionary = responseObject as? NSDictionary {
                    // handle the parsed dictionary here
                    println("addItem responseDictionary\n \(responseDictionary)");
                    let wasSuccess: Int = responseDictionary["success"] as! Int;
                    if(wasSuccess == 1) {
                        self.success = true;
                        println("success \(self.success)");
                        self.performSegueWithIdentifier("addSuccess", sender: self)
                    }
                    
                } else {
                    // handle parsing error here
                    println("addItem:  Item not added!");
                }
            })
            task.resume()
            
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        itemImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        img = info[UIImagePickerControllerOriginalImage] as! UIImage


        ALAssetsLibrary().writeImageToSavedPhotosAlbum(img.CGImage, orientation: ALAssetOrientation(rawValue: img.imageOrientation.rawValue)!,
            completionBlock:{ (path:NSURL!, error:NSError!) -> Void in
                println("\(path)")
                self.imgURL = path;
        })
        
        hasPic = true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemDescription.delegate = self
        self.itemTitle.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    /// Create request
    ///
    /// :param: userid   The userid to be passed to web service
    /// :param: password The password to be passed to web service
    /// :param: email    The email address to be passed to web service
    ///
    /// :returns:         The NSURLRequest that was created
    
    func createRequest (shar_name: String, description: String) -> NSURLRequest {
        let param = [
            "shar_name"  : shar_name,
            "description"    : description]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: server)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", path: imgURL.absoluteString!, boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// :param: parameters   The optional dictionary containing keys and values to be passed to web service
    /// :param: filePathKey  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// :param: paths        The optional array of file paths of the files to be uploaded
    /// :param: boundary     The multipart/form-data boundary
    ///
    /// :returns:            The NSData of the body of the request
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, path: String, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                var boundaryAppend = "--\(boundary)\r\n"
                body.appendData(boundaryAppend.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
                var content = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                body.appendData(content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
                var value = "\(value)\r\n";
                body.appendData(value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
            }
        }
        
        if !(path.isEmpty) {
            var filename = path.lastPathComponent
            var splitMe = split(filename) {$0 == "."}
            filename = splitMe[0];
            //let data = NSData(contentsOfFile: path)
            var data = UIImageJPEGRepresentation(img, 0.2);
            let mimetype = mimeTypeForPath(path)
            var boundaryAppend = "--\(boundary)\r\n";
            println(filename);
            body.appendData(boundaryAppend.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
            var content = "Content-Disposition: form-data; name=\"picture\"; filename=\"\(filename)\"\r\n";
            body.appendData(content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
            var mime = "Content-Type: \(mimetype)\r\n\r\n";
            body.appendData(mime.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
            body.appendData(data)
            var end = "\r\n"
            body.appendData(end.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
        }
        var boundary = "--\(boundary)--\r\n";
        body.appendData(boundary.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!);
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// :returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// :param: path         The path of the file for which we are going to determine the mime type.
    ///
    /// :returns:            Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    
}
    
