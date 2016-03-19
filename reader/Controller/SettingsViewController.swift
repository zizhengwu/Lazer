import UIKit

class SecondViewController: UITableViewController {
    
    let Items = ["Altitude","Distance","Groundspeed"]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.Items[indexPath.row]
        
        let customSwitch = UISwitch(frame: CGRectZero)
        cell.accessoryView = customSwitch
        customSwitch.setOn(true, animated: true)
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
