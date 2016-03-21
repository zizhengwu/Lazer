import UIKit

class SettingsViewController: UITableViewController {
    
    let Items = ["Altitude","Distance","Groundspeed"]
    
    let settingSwitchTableViewCellId = "settingSwitchTableViewCellId"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [3][section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingSwitchTableViewCellId, forIndexPath: indexPath) as! SettingSwitchTableViewCell
            cell.titleLabel?.text = ["Notification", "暗色", "更多字的测试"][indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingSwitchTableViewCellId, forIndexPath: indexPath) as! SettingSwitchTableViewCell
            cell.titleLabel?.text = "ERROR"
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(SettingSwitchTableViewCell.self, forCellReuseIdentifier: settingSwitchTableViewCellId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
