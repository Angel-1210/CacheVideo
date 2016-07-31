//
//	RootClass.swift
//
//	Create by Dharmesh Avaiya on 27/7/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MessageMediaModel : NSObject, NSCoding {

	var data : [MediaModel]!
	var message : String!
	var status : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		data = [MediaModel]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = MediaModel(fromDictionary: dic)
				data.append(value)
			}
		}
		message = dictionary["message"] as? String
		status = dictionary["status"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
        
		if data != nil{
			var dictionaryElements = [NSDictionary]()
			for dataElement in data {
				dictionaryElements.append(dataElement.toDictionary())
			}
			dictionary["data"] = dictionaryElements
		}
		if message != nil{
			dictionary["message"] = message
		}
		if status != nil{
			dictionary["status"] = status
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObjectForKey("data") as? [MediaModel]
         message = aDecoder.decodeObjectForKey("message") as? String
         status = aDecoder.decodeObjectForKey("status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encodeObject(data, forKey: "data")
		}
		if message != nil{
			aCoder.encodeObject(message, forKey: "message")
		}
		if status != nil{
			aCoder.encodeObject(status, forKey: "status")
		}

	}

}