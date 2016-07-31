//
//	Data.swift
//
//	Create by Dharmesh Avaiya on 27/7/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MediaModel : NSObject, NSCoding{

	var file : String!
	var fileType : String!
	var id : String!
	var insertdate : String!
	var isActive : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		file = dictionary["file"] as? String
		fileType = dictionary["file_type"] as? String
		id = dictionary["id"] as? String
		insertdate = dictionary["insertdate"] as? String
		isActive = dictionary["is_active"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if file != nil{
			dictionary["file"] = file
		}
		if fileType != nil{
			dictionary["file_type"] = fileType
		}
		if id != nil{
			dictionary["id"] = id
		}
		if insertdate != nil{
			dictionary["insertdate"] = insertdate
		}
		if isActive != nil{
			dictionary["is_active"] = isActive
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         file = aDecoder.decodeObjectForKey("file") as? String
         fileType = aDecoder.decodeObjectForKey("file_type") as? String
         id = aDecoder.decodeObjectForKey("id") as? String
         insertdate = aDecoder.decodeObjectForKey("insertdate") as? String
         isActive = aDecoder.decodeObjectForKey("is_active") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if file != nil{
			aCoder.encodeObject(file, forKey: "file")
		}
		if fileType != nil{
			aCoder.encodeObject(fileType, forKey: "file_type")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if insertdate != nil{
			aCoder.encodeObject(insertdate, forKey: "insertdate")
		}
		if isActive != nil{
			aCoder.encodeObject(isActive, forKey: "is_active")
		}

	}

}