Swift CRUD Walkthrough
- written using a Table View Controller
? how do I get the colors to display in this file as if they appear in xCode
? what is the general thought process when developing an app. It seems as if it
goes storyboard layout, hook up segues and generate the necessary file templates,
then write the code that bring it to life

Storyboard Setup (the Read)
- Setup the Table View Controller.
    - Delete the standard view controller and replace it with a Table View Controller
    from the object library.
    - if this is the first page, set it to be the initial view Controller
    - change the file name for easy reference. In this case "BucketListViewController.swift"
    - update the class information to reflect it. Since we're using a TableViewController
    let's make sure that it's reflected in the class information as below

  class BucketListViewController: UITableViewController {
  }

- Select the BucketListViewController storyboard and change the "class" to the BucketListViewController file
- select the storyboard. Select the editor -> Embed In -> Navigation Controller.

  var missions = ["Sky diving", "Live in Hawaii"]

- we create an array of strings to serve as our model object

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
     let cell = tableView.dequeueReusableCellWithIdentifier("MyCell")!
        // All UITableViewCell objects have a build in textLabel so set it to the model that is corresponding to the row in array
        cell.textLabel?.text = missions[indexPath.row]
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count

- Make sure that the identifier for "MissionCell" is set to "MyCell" that way
the data in the missions array can be displayed in the "MyCell" table
- go to the object library and select an item button. Place it on the top right
of the BucketList Navigation Controller. Make sure you set its identifier to "add".
Validate explanation and difference between view and navigation controller.
- drag a new Table View Controller onto the storyboard
- hook the add button up to the table view controller by control-click and dragging
from the + sign. Select show
- at this point you shoud be able to run the program and see the items in the array.
When you click on the + sign, you should be able to go to the table view controller and come back
- create a new swift file called "MissionDetailsViewController"

  import UIKit

  class MissionDetailsViewController: UITableViewController {
  }

- the class name should match the name of the file, hence "MissionDetailsViewController.swift"
contains this class.
- next we're going to connect the Mission Details View Controller to the storyboard
by going to the Custom Class section on the right and setting it's class to MissionDetailsViewController.
- select the table view in this controller and set the content to Static Cells(verify that this is
because the content won't change). Set the style to grouped (ask why).
- go to the table view section and reduce it from 3 rows to 1 (ask why).
- drag and drop a text field from the object library into the Table View Section
- create constraints on the top, right, bottom, and left with constraints of 0.
Should be a total of 4 constraints
- get rid of the show segue you created between the Mission Details View Controller and
replace it with a model segue. This is done by deleting the show segue, and control-clicking
from the + sign to the Mission Details View Controller and selecting "present modally"
- select the Missions Detail View Controller and click "editor". From there click "Embed In"
and select "Navigation Controller". (ask why)
- from there ,grab an item button from the object library and place it on the left side
of the Navigation Controller. Change it's identifier to "cancel". Repeat using the same
process on the right side and change it's identifier to "done".

Implementing the CancelButtonDelegate Protocol

- intent behind this is to make the presenting View Controller (MissionsDetailViewController //ask if correct)
to get dismissed when the user presses the "cancel" button.
- create a new swift file called "CancelButtonDelegate.swift"

  import UIKit
  protocol CancelButtonDelegate: class {
      func cancelButtonPressedFrom(controller: UIViewController)
  }

- this is the code that should be inside of it. It says that any class that conforms
to the CancelButtonDelegate must implement the "cancelButtonPressedFrom(controller: UIViewController)" method
- go to the BucketListViewController and ensure that this is the delegate. Since we are
segueing into the MissionsDetailViewController from the BucketListViewController, BucketListViewController
will be the delegate and we have to mod it's class in the BucketListViewController as such:

  class BucketListViewController: UITableViewController, CancelButtonDelegate {
      // ...
      func cancelButtonPressedFrom(controller: UIViewController) {
          dismissViewControllerAnimated(true, completion: nil)
      }
      // ...
  }

- now that the BucketListViewController conforms to the CancelButtonDelegate, we need to
go to our MissionDetailsViewController and add a property there so the BucketListViewController
can set itself as the cancelButtonDelegate

  import UIKit
  class MissionDetailsViewController: UITableViewController {
      weak var cancelButtonDelegate: CancelButtonDelegate?
      @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
          cancelButtonDelegate?.cancelButtonPressedFrom(self)
      }
  }

- now we'll have to make sure that when we segue to the MissionDetailsViewController
we set the property to point to the BucketListViewController. We do this by selecting the modal
segue in the BucketList scene and changing the identifier in the top right to "AddNewMission"
- once this is done we set ourselves as it's cancelButtonDelegate

  class BucketListViewController: UITableViewController, CancelButtonDelegate {
      // ...
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
          if segue.identifier == "AddNewMission" {
              //let navigationController = segue.destinationViewController as! UINavigationController
              //let controller = navigationController.topViewController as! MissionDetailsViewController
              //controller.cancelButtonDelegate = self
          }
      }
      // ...
  }
- get explanation for code that starts with //
- the prepareForSegue method is used because now from within the method we can reference
both the ViewController that we are segueing from and the ViewController that we are segueing to.
- at this point you can now navigate backwards when pressing the Cancel button

Implementing the MissionDetailsViewControllerDelegate Protocol

- create the functionality to add a new mission. First, create a new protocol by creating the
protocol when the Done button is pressed. Create a new swift file called
"MissionDetailsViewControllerDelegate.swift" and input the following:

  import Foundation
  protocol MissionDetailsViewControllerDelegate: class {
      func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
  }

Create

- once the initial setup is done we'll go ahead and get functionality working.
- let's modify the MissionDetailsViewController to have a property called "missionDetailsViewControllerDelegate"
so that it can be later set similar to the cancelButtonDelegate. This is done so after the user presses
"done", everything that was entered into the text field will be passed.

  class MissionDetailsViewController: UITableViewController {
      @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
          cancelButtonDelegate?.cancelButtonPressedFrom(self)
      }
      @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
          delegate?.missionDetailsViewController(self, didFinishAddingMission: newMissionTextField.text)
      }
      @IBOutlet weak var newMissionTextField: UITextField!
      weak var delegate: MissionDetailsViewControllerDelegate?
      weak var cancelButtonDelegate: CancelButtonDelegate?
  }

- (verify correct). In the MissionDetailsViewController we created variables for the two delegates:
MissionDetailsViewControllerDelegate, and CancelButtonDelegate.
- (verify correct). When the "done" button is pressed, the function "func doneBarButtonPressed"
runs adding whatever is in the newMissionTextField as text. Written as "newMissionTextField.text"

import UIKit
class BucketListViewController: UITableViewController, CancelButtonDelegate, MissionDetailslViewControllerDelegate {

- now we have to declare that our BucketListViewController conforms to the new protocol.
So above, we added the delegate "MissionDetailsViewControllerDelegate" as an object(verify correct).

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
          if segue.identifier == "AddNewMission" {
              let navigationController = segue.destinationViewController as! UINavigationController
              let controller = navigationController.topViewController as! MissionDetailsViewController
              controller.cancelButtonDelegate = self
              controller.delegate = self
          }

- we added "controller.delegate" = self" to show that we're calling the MissionDetailsViewControllerDelegate
on itself (BucketListViewController) because it's the delegate. (verify correct)

  func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String) {
          dismissViewControllerAnimated(true, completion: nil)
          missions.append(mission)
          tableView.reloadData()
      }

- this function is in the BucketListViewController as well. It passes the mission parameter from the
MissionDetailsViewController as a String.

  dismissViewControllerAnimated(true, completion: nil)

- makes sure that the animation is run once "done" is clicked

    missions.append(mission)
    tableView.reloadData()
  }

- it appends to the missions array whatever was entered into the text field (mission)
and reloads the data in the array so it shows the new entry.

Update

- rename the cell type in Bucket List scene to "MissionCell" and change the table view
cell type under accessory to "detail disclosure". It should appear as an "i" inside a circle
like an information button.
- now when this button is clicked, we want to segue into a scene where we can edit
the mission that was clicked. Control-click and drag a connector from the BucketListViewController
to the Navigation Controller. Show it modally. There should be two segues now between the BucketListViewController
and the Navigation Controller; one should be the prior segue for "AddMission". We will go to the
storyboard segue identifier and name it "EditMission"

  class MissionDetailsViewController: UITableViewController {
      // ...
      var missionToEdit: String?
      var missionToEditIndexPath: Int?
      // ...
  }

- we add a few more properties to our MissionDetailsViewController to determine whether
we have a mission to edit or not. We have the missionToEdit which is a string, and the
missionToEditIndexPath which is an integer to designate what index we are updating.

  class BucketListViewController: UITableViewController, CancelButtonDelegate, MissionDetailslViewControllerDelegate {
      // ...
      override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
          performSegueWithIdentifier("EditMission", sender: tableView.cellForRowAtIndexPath(indexPath))
      }

- because we created another segue, we want to make sure that the segue with the
"EditMission" identifier is linked through a tableView function in the BucketListViewController.
(ask how "sender: tableView.cellForRowAtIndexPath(indexPath)" works)

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
          if segue.identifier == "AddNewMission" {
              let navigationController = segue.destinationViewController as! UINavigationController
              let controller = navigationController.topViewController as! MissionDetailsViewController
              controller.cancelButtonDelegate = self
              controller.delegate = self
          } else if segue.identifier == "EditMission" {
              let navigationController = segue.destinationViewController as! UINavigationController
              let controller = navigationController.topViewController as! MissionDetailsViewController
              controller.cancelButtonDelegate = self
              controller.delegate = self
       // Here we set the missionToEdit so that we can have the mission text on the MissionDetailsViewController
              if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                  controller.missionToEdit = missions[indexPath.row]
    controller.missionToEditIndexPath = indexPath.row

- we'll go back to the "prepareForSegue" function and add a segue.identifier for "EditMission".
Since this is an optional, we want to add a conditional that says "if let indexPath = tableView.indexPathForCell"
then the controller will set the variables in the controller for missionToEdit and missionToEditIndexPath to the
values that are in missions[indexPath.row] and indexPath.row respectively.

  protocol MissionDetailsViewControllerDelegate: class {
      func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
      func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int)
  }

- we will also have to modify our MissionDetailsViewControllerDelegate and add another required method.
This would be func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int).
We are designating that this is going to the MissionDetailsViewController, and passing the parameters
didFinishEditingMission as a string and atIndexPath as an integer (verify correct).

  import UIKit
  class MissionDetailsViewController: UITableViewController {
      @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
          cancelButtonDelegate?.cancelButtonPressedFrom(self)
      }
      @IBAction func doneBarButtonPressed(sender: UIBarButtonItem) {
   // if we are editing then run the "didFinishEditingMission" method
          if var mission = missionToEdit {
              mission = newMissionTextField.text!
              delegate?.missionDetailsViewController(self, didFinishEditingMission: mission, atIndexPath: missionToEditIndexPath!)
          } else { // we are adding so run the "didFinishAddingMission" method
              let mission = newMissionTextField.text!
              delegate?.missionDetailsViewController(self, didFinishAddingMission: mission)
          }
      }
      @IBOutlet weak var newMissionTextField: UITextField!
      weak var delegate: MissionDetailsViewControllerDelegate?
      weak var cancelButtonDelegate: CancelButtonDelegate?
      var missionToEdit: String?
      var missionToEditIndexPath: Int?
  }

- the MissionDetailsViewController should look like this now. In the doneBarButtonPressed method,
we want to add logic for the edit function.

  if var mission = missionToEdit {
      mission = newMissionTextField.text!
      delegate?.missionDetailsViewController(self, didFinishEditingMission: mission, atIndexPath: missionToEditIndexPath!)
  }

- if the mission is set to missionToEdit (ask how/where it differentiates the two when the button is pressed)
then we would set mission to newMissionTextField.text! This ensures that the current value
in the array is displayed and passed. The next line (delegate) would then make sure that the
updated String is passed.

  func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: String, atIndexPath indexPath: Int){
      dismissViewControllerAnimated(true, completion: nil)
      missions[indexPath] = mission
      tableView.reloadData()
  }

- we want to create another function for missionDetailsViewController to account for the editing.
We will place this in the BucketListViewController. (ask where we first name didFinishEditingMission
and ask if this is a variable name that we create every time).

    dismissViewControllerAnimated(true, completion: nil)
    missions[indexPath] = mission
    tableView.reloadData()
  }

- again we use dismissViewControllerAnimated to perform the associated animation bring us
back to the BucketListViewController once the done button is hit. We then set
missions[indexPath] to mission. Read it as missions at indexPath will now be the value of the text
enter in mission. Once done is pushed, tableView.reloadData() displays the updated contents of the array.

Delete

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if(editingStyle == UITableViewCellEditingStyle.Delete) {
          missions.removeAtIndex(indexPath.row)
          self.tableView.reloadData()
      }
  }
- we're going to insert this function into our BucketListViewController since
this is the controller we're going to be able to delete rows

  if(editingStyle == UITableViewCellEditingStyle.Delete) {

- this line (ask what it's called) says that if the editing style for this is a delete

    missions.removeAtIndex(indexPath.row)
    self.tableView.reloadData()
  }

- missions.removeAtIndex says that we're going to remove an item from the missions array
using removeAtIndex's method (verify) and since the function takes in
"forRowAtIndexPath indexPath: NSIndexPath", it will know what index in the array we're referring to.
- "self.tableView.reloadData()" then will reload the table once that's done to reflect
the removed data in the array.
