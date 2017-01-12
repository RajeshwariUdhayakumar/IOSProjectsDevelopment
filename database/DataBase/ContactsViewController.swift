//
//  ContactsViewController.swift
//  DataBase
//
//  Created by macmini on 06/01/17.
//  Copyright © 2017 nointernetcheck.businessdragan.com. All rights reserved.
//

import UIKit
import  Contacts
import ContactsUI
import CoreData

class ContactsViewController: UIViewController,CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var actIndicator: UIActivityIndicatorView!
    
      @IBOutlet var addBtn: UIBarButtonItem!
    @IBOutlet var contactTblView: UITableView!
    var fullNameArray: [String] = []
    var phoneNumberArray: [String] = []
    var statusArray: [String] = []
    var getstatusArray: [String] = []
    var SARray: [String] = []


    var contacts = [CNContact]()
    func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.actIndicator.isHidden = true
        self.contactTblView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        fetchContacts()
    }
    func fetchContacts() {
        var fullnames:String
        var phoneNum:String
        var status:String

        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "ContactDB", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        var results = [NSManagedObject]()
        do
        {
            // Execute Fetch Request
            let records = try getContext().fetch(fetchRequest)
            if let records = records as? [NSManagedObject]
            {
                results = records
                if results.count == 0
                {
                    print("no result")
                }
                else
                {
                    for res in results
                    {
                        print(res)
                        fullnames = (res.value(forKey: "name")as! String)
                        phoneNum = (res.value(forKey: "phonenumber")as! String)
                        status = (res.value(forKey: "status")as! String)
                        getstatusArray.append(status)
                        fullNameArray.append(fullnames)
                        phoneNumberArray.append(phoneNum)
                        print("\(phoneNumberArray)")
                        print("\(getstatusArray)")
                        self.contactTblView.dataSource = self
                        self.contactTblView.delegate = self
                        self.contactTblView.reloadData()
                    }
                }
                if results.count == 0
                {
                    print("No objects")
                    self.addBtn.isEnabled = true
                }
                else
                {
                    //self.addBtn.isEnabled = false
                     self.navigationItem.rightBarButtonItem = nil
                }
                }
            }
        catch
        {
            print("Unable to fetch managed objects for entity \(entity).")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullNameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath as IndexPath) as! TableViewCell
        cell.contactnameLbl.text = fullNameArray[indexPath.row]
        cell.contactPhoneNum.text = phoneNumberArray[indexPath.row]
        cell.statusLbl.text = getstatusArray[indexPath.row]
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveContact(_ sender: Any)
    {
            self.actIndicator.startAnimating()
            self.actIndicator.isHidden = false
            var fullnames:String = ""
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {
                granted, error in
                guard granted else {
                    let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactBirthdayKey,CNContactFamilyNameKey] as [Any]
                let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor] )
                var cnContacts = [CNContact]()
                do {
                    try store.enumerateContacts(with: request){
                        (contact, cursor) -> Void in
                        cnContacts.append(contact)
                    }
                } catch let error {
                    NSLog("Fetch contact error: \(error)")
                }
                NSLog(">>>> Contact list:")
                for contact in cnContacts {
                    fullnames = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                    let MobNumVar = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
                    print(MobNumVar)
                    self.save(getname: fullnames, getMobnum: MobNumVar)
                }
                
            })
         self.navigationItem.rightBarButtonItem = nil
    }
    func save(getname: String,getMobnum: String)
    {
        statusArray = ["Busy","At Work","In a Meeting","Sleeping","At School","Available"]
        var StatusString:String = ""
        let context = self.getContext()
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "ContactDB", in: context)
        let database = NSManagedObject(entity: entity!, insertInto: context)
        database.setValue(getname, forKey: "name")
        database.setValue(getMobnum, forKey: "phonenumber")
        database.setValue(1, forKey: "condition")
       // database.setValue(StatusString, forKey: "status")
        for i in 0..<statusArray.count
        {
            StatusString = statusArray[i]
            database.setValue(StatusString, forKey: "status")
            getstatusArray.append(StatusString)
        }
       
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
            getstatusArray.append(StatusString)
        
        fullNameArray.append(getname)
        phoneNumberArray.append(getMobnum)
        
        self.contactTblView.dataSource = self
        self.contactTblView.delegate = self
        self.contactTblView.reloadData()
        self.actIndicator.stopAnimating()
        self.actIndicator.isHidden = true
            
    }
    func getDateStringFromComponents(_ dateComponents: DateComponents) -> String! {
        if let date = Calendar.current.date(from: dateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        return nil
    }
//    func askForContactAccess() {
//        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
//        
//        switch authorizationStatus {
//        case .denied, .notDetermined:
//            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
//                if !access {
//                    if authorizationStatus == CNAuthorizationStatus.denied {
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
//                            
//                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
//                                
//                            }
//                            
//                            alertController.addAction(dismissAction)
//                            
//                            self.present(alertController, animated: true, completion: nil)
//                        })
//                    }
//                }
//            })
//            break
//        default:
//            break
//        }
//    }
    func didFetchContacts(_ contacts: [CNContact]) {
        for contact in contacts {
            self.contacts.append(contact)
        }
    }
//
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        let fullnames:String
//        print("\(contact)")
//        didFetchContacts([contact])
//         fullnames = CNContactFormatter.string(from: contact, style: .fullName)!
//        print("\(fullnames)")
//        
//        let context = getContext()
//        let entity =  NSEntityDescription.entity(forEntityName: "ContactDB", in: context)
//        let database = NSManagedObject(entity: entity!, insertInto: context)
//        database.setValue(fullnames, forKey: "name")
//               do
//        {
//            try context.save()
//            print("saved!")
//        }
//        catch let error as NSError
//        {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        fullNameArray.append(fullnames)
//        self.contactTblView.dataSource = self
//        self.contactTblView.delegate = self
//        self.contactTblView.reloadData()
//    }
    
}
