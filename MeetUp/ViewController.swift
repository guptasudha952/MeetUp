//
//  ViewController.swift
//  MeetUp
//
//  Created by Student 06 on 01/03/19.
//  Copyright © 2019 Student 06. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , CLLocationManagerDelegate , MKMapViewDelegate{
    
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    @IBOutlet var TableView: UITableView!
    
    @IBOutlet var MapView: MKMapView!
    
    var Members:[Int] = [Int]()
    var Discription:[String] = [String]()
    var Name:[String] = [String]()
    var Latitude:[Float] = [Float]()
    var Longitude:[Float] = [Float]()
    
    var selectedname:String = String()
    var selectedlat:Float = Float()
    var selectedlon:Float = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       parseJson()
        
    }
    func parseJson()
    {
        let urlstring = "https://api.meetup.com/2/groups?lat=51.509980&lon=-0.133700&page=20&key=1f5718c16a7fb3a5452f45193232"
        let url:URL = URL(string: urlstring)!
        let session: URLSession = URLSession(configuration: .default)
        let datatask = session.dataTask(with: url) { (data, response, error) in
            if response != nil
            {
                if data != nil
                {
                    do
                    {
                        let firstDic:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        
                         let resultArray:[[String:Any]] = firstDic["results"] as! [[String:Any]]
                        for item in resultArray
                        {
                            let member:Int = item["members"] as! Int
                            self.Members.append(member)
                            
                            let discrption:String = item["description"] as! String
                            self.Discription.append(discrption)
                            
                            let name:String = item["name"] as! String
                            self.Name.append(name)
                            
                            let latitude:Float = item["lat"] as! Float
                            self.Latitude.append(latitude)
                            
                            let longitude:Float = item["lon"] as! Float
                            self.Longitude.append(longitude)
                        }
                        print("Members Are \(self.Members)")
                        print("Discriptions Are \(self.Discription)")
                        print("Names Are \(self.Name)")
                        print("Latitudes Are \(self.Latitude)")
                        print("Longitudes Are \(self.Longitude)")
                        OperationQueue.main.addOperation
                            {
                                self.TableView.reloadData()
                                //self.InsertData()
                            }
                        }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                else
                {
                    print("data not found ",error?.localizedDescription)
                }
            }
            
        }
        datatask.resume()
    }

    func insertData()
    {
        let context = delegate.persistentContainer.viewContext
        let meetupObj:NSObject = NSEntityDescription.insertNewObject(forEntityName: "MeetUP", into: context)
        
        for item1 in Name
        {
           meetupObj.setValue(item1, forKey: "name")
        }
        for item2 in Discription
        {
            meetupObj.setValue(item2, forKey: "discription")
        }
        for item3 in Members
        {
            meetupObj.setValue(item3, forKey: "member")
        }
        for item4 in Latitude
        {
            meetupObj.setValue(item4, forKey: "lat")
        }
        for item5 in Longitude
        {
            meetupObj.setValue(item5, forKey: "lon")
        }
        do
        {
            try context.save()
            print("Insert Success")
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.namelabel.text = Name[indexPath.row]
        cell.memberslabel.text = String(Members[indexPath.row])
        cell.descriptionlabel.text = Discription[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedlat = Float(Latitude[indexPath.row])
        selectedlon = Float(Longitude[indexPath.row])
        selectedname = Name[indexPath.row]
        
        let firstlocation = CLLocation(latitude: CLLocationDegrees(selectedlat), longitude: CLLocationDegrees(selectedlon))
        let region:CLLocationDistance = 100
        
       func centerMapOnLocation(location:CLLocation)
       {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, region, region)
        MapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = selectedname
        MapView.addAnnotation(annotation)
        }
        centerMapOnLocation(location: firstlocation)
        print(selectedname)
        print(selectedlat)
        print(selectedlon)
        
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            Name.remove(at: indexPath.row)
            Members.remove(at: indexPath.row)
            Discription.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("Data Deleted")
            
            let context = delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeetUp")
            request.returnsObjectsAsFaults = false
            
            do
            {
                let result = try context.fetch(request)
                
                if result.count == 1
                {
                    let data:NSManagedObject = result.first as! NSManagedObject
                    context.delete(data)
                    
                    do
                    {
                        try context.save()
                        
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                
            }
            catch
            {
                print(error.localizedDescription)
            }
        
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

