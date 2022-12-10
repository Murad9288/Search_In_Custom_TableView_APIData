//
//  ViewController.swift
//  Custom_TableView_Searching_WebAPI
//
//  Created by Md Murad Hossain on 10/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    var array_Data = [ToDo]()
    var search_Data = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MARK: Private mathode call
        
        setuptableView()
        fetchingAPTData()
        
       
    }
    
//  MARK: Private mathode

    func setuptableView(){
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    
    func fetchingAPTData() {
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data,response,error) in
            guard let data = data, error == nil else {
                print("Error occured while accessing data")
                return
            }
            do {
                self.array_Data = try JSONDecoder().decode([ToDo].self, from: data)
            }
            catch {
                print("Error while Decoding JSON data info Swift structure\(error)")
            }
            DispatchQueue.main.async {
                self.search_Data = self.array_Data
                self.myTableView.reloadData()
            }
            
        })
        task.resume()
        
    }
    
}


// MARK: UITableView Data source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        let apiData = search_Data[indexPath.row]
        let string = "https://api.opendota.com"+(apiData.img)
        let url = URL(string: string)
        cell.myImageView.downloaded(from: url!)
        cell.myLabel.text = apiData.localized_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        myTableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
}

//  MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //        MARK: Table View Cell Animation 
        
        let rotationTransfrom = CATransform3DTranslate(CATransform3DIdentity, 500, 2, 0)
        
        cell.layer.transform = rotationTransfrom
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.4){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search_Data = []
        myTableView.scrollsToTop = true
        for i in array_Data {
            if mySearchBar.text == "" {
                search_Data = array_Data
            } else {
                if i.name.lowercased().contains(mySearchBar.text!.lowercased()) {
                    search_Data.append(i)
                }
            }
        }
        myTableView.reloadData()
        if search_Data.count > 0 {
            scrollToTop()
        }
    }
}




//MARK: Downloaded API Image

extension UIImageView{
    func downloaded(from url: URL){
        
        contentMode = .scaleToFill
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler:{
            (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let minType = response?.mimeType,
                  minType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                print("Error occered while accessing image from link")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        })
        dataTask.resume()
    }
}
        
