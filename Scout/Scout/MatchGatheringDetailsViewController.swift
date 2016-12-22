//
//  MatchGatheringDetailsViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


class MatchGatheringDetailsViewController: BaseViewController, CenterViewControllerDelegate{

    @IBOutlet weak var scoutNameTextField: UITextField!
    @IBOutlet weak var teamAssociatedTextField: UITextField!
    @IBOutlet weak var tournamentTextField: UITextField!
    var TournamentPickerSource:TournamentPicker!
    var ScoutPickerSource:ScoutPicker!
    var TournamentPickerDelegator:UIPickerTextFieldDelegator!
    var ScoutPickerDelegator:UIPickerTextFieldDelegator!
    
    @IBOutlet weak var tournamentsPickerView: UIPickerView!
    @IBOutlet weak var scoutPickerView: UIPickerView!
    var CurrentScout:Scout!
    var CurrentTournament:Tournament!
    var busyIndicator:BusyIndicator!
    var loadsTobeDone = 2
    var isNewScout:Bool = false
    var isNewTournament:Bool = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.loadSettingsFromUserStore()
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoadTournamentSuccess", name: NSNotificationCenterKeys().successfullyLoadedTournaments, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "onLoadScoutsSuccess", name: NSNotificationCenterKeys().successfullyLoadedScouts, object: nil)

        
       // self.tournamentsPickerView.hidden = true
       // self.scoutPickerView.hidden = true
        self.TournamentPickerDelegator = UIPickerTextFieldDelegator(pickerView:self.tournamentsPickerView, parent:self.view, movement: 160)
        self.ScoutPickerDelegator = UIPickerTextFieldDelegator(pickerView:self.scoutPickerView,parent:self.view, movement: 80)
        self.tournamentTextField.delegate = self.TournamentPickerDelegator
        self.scoutNameTextField.delegate = self.ScoutPickerDelegator
        
        // show activity indicator
        busyIndicator = BusyIndicator(parent: self.view)
        busyIndicator.start()
    }
    
    @IBAction func onTeamNumberChanged(sender: AnyObject) {
        setScoutDataSource( self.teamAssociatedTextField.text )
    }
    
    func setScoutDataSource( teamNumber:String){
        
        var scoutsForThisTeam = Repository.Instance.getScouts().filter({ (scout)->Bool in
            if scout.AssociatedTeam.description == teamNumber{
                return true
            }
            return false
        })
        
        self.ScoutPickerSource = ScoutPicker(scouts: scoutsForThisTeam , onChangeCallback :{ (row)->Void in
            self.CurrentScout = scoutsForThisTeam[row]
            self.scoutNameTextField.text = scoutsForThisTeam[row].Name
        })
        self.scoutPickerView.delegate = self.ScoutPickerSource
        self.scoutPickerView.dataSource = self.ScoutPickerSource
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)      // dismiss the keyboard.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func onGoButton(sender: AnyObject) {
        
       // self.performSegueWithIdentifier("mainmatchesseague", sender: self)
    }

    func onLoadTournamentSuccess(){
        var tournaments = Repository.Instance.getTournaments()
        if tournaments.count >  0 && self.tournamentTextField.text.isEmpty{
            self.tournamentTextField.text = tournaments[0].Name
            self.CurrentTournament = tournaments[0]
        };
        
        
        self.TournamentPickerSource = TournamentPicker(tournaments: tournaments , onChangeCallback :{ (row)->Void in
            self.CurrentTournament = tournaments[row]
            self.tournamentTextField.text = tournaments[row].Name
        })
        self.tournamentsPickerView.delegate = self.TournamentPickerSource
        self.tournamentsPickerView.dataSource = self.TournamentPickerSource
        self.flagLoadIsDone()
    }
    
    func onLoadScoutsSuccess(){
        var scouts = Repository.Instance.getScouts()
        if scouts.count >  0 && self.scoutNameTextField.text.isEmpty{
            //self.scoutNameTextField.text = scouts[0].Name
            //self.teamAssociatedTextField.text = scouts[0].AssociatedTeam.description
            //self.CurrentScout = scouts[0]
        }
        
        self.setScoutDataSource( self.teamAssociatedTextField.text )
        self.flagLoadIsDone()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        var matchesViewController = segue.destinationViewController as SavedScoutTableViewController
        matchesViewController.CurrentTournament = self.CurrentTournament
        println("Current tournament is: \(self.CurrentTournament)")
        matchesViewController.CurrentScout = self.CurrentScout
        if self.isNewTournament || self.isNewScout{
            matchesViewController.isNew = true
        }
        self.saveSettingsToUserStore()
      }

    
    func validateInputs() -> Bool{
        
        if self.scoutNameTextField.text.trimWhiteSpaces().isEmpty{
            UserAlerts.showMessage(UserMessages().InvalidScoutNameMessage,title:"Input")
            return false
        }
        
        if self.teamAssociatedTextField.text.toInt() == nil{
            UserAlerts.showMessage(UserMessages().InvalidTeamNumberMessage,title:"Input")
            return false
        }
        
        if self.tournamentTextField.text.isEmpty{
            UserAlerts.showMessage(UserMessages().InvalidTournamentMessage,title:"Input")
            return false
        }
        
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if !self.validateInputs(){
            return false
        }
        
        self.isNewScout = self.checkAndAddScout()
        self.isNewTournament = self.checkAndAddTournament()
        
        return true
    }
 
    func checkAndAddTournament()->Bool{
        var tournamentEntered = self.tournamentTextField.text.trimWhiteSpaces()
        var foundExistingTournamentForUserEntered = Repository.Instance.getTournaments().first(
            { (tournament, dummy) -> Bool in
                
                println("name:|\(tournament.Name)| and text field |\(tournamentEntered)|")
                    var ret = tournament.Name == tournamentEntered
                println("ret is:\(ret)")
                return ret
        })
            
        if foundExistingTournamentForUserEntered == nil{
            var tournament = Tournament()
            tournament.Name = tournamentEntered
            tournament.Date = NSDate()
            Repository.Instance.saveTournament( tournament)
            self.CurrentTournament = tournament
            return true
            
        }else{
                self.CurrentTournament = foundExistingTournamentForUserEntered
            return false
        }

    }
    
    func checkAndAddScout()->Bool{
        
        var foundExistingScoutForUserEntered = Repository.Instance.getScouts().first(
            { (scout, dummy) -> Bool in
                return scout.Name == self.scoutNameTextField.text.trimWhiteSpaces() && scout.AssociatedTeam.description == self.teamAssociatedTextField.text
        })
        
        if foundExistingScoutForUserEntered == nil{
            // save scout
                // save only if scout does not exists.
                var scout = Scout()
                scout.Name = self.scoutNameTextField.text
                scout.AssociatedTeam = self.teamAssociatedTextField.text.toInt()!
                Repository.Instance.saveScout( scout)
                self.CurrentScout = scout
                return true
            }
        else{
            self.CurrentScout = foundExistingScoutForUserEntered
            return false
        }
    }
    
    func flagLoadIsDone(){
        self.loadsTobeDone--
        if( self.loadsTobeDone == 0){
            self.busyIndicator.stop()
        }
    }
    
    func saveSettingsToUserStore(){
        Repository.Instance.saveToUserDefaults(["scout": self.CurrentScout.Name,"teamnumber" : self.CurrentScout.AssociatedTeam.description, "tournament" : self.CurrentTournament.Name])
    }
    
    func loadSettingsFromUserStore(){
        var items = Repository.Instance.loadFromUserDefaults(["scout","teamnumber","tournament"])
        
        for (key,val) in items{
            switch(key){
                case "scout":
                    self.scoutNameTextField.text = val
                    break
                case "teamnumber":
                    self.teamAssociatedTextField.text = val
                    break
                case "tournament":
                    self.tournamentTextField.text = val
                    break
                default:
                    break
            }
        }
    }
   
}

class TournamentPicker :  NSObject , UIPickerViewDataSource, UIPickerViewDelegate
{
    var Tournaments:[Tournament]
    var OnChangeCallBack: Int->Void
    
    
    init(tournaments:[Tournament], onChangeCallback: Int->Void){
        self.Tournaments = tournaments
        self.OnChangeCallBack = onChangeCallback
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
   
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.Tournaments.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.Tournaments[row].Name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        OnChangeCallBack(row)
    }
}

class ScoutPicker :  NSObject , UIPickerViewDataSource, UIPickerViewDelegate
{
    var Scouts:[Scout]
    var OnChangeCallBack: Int->Void
    
    
    init(scouts:[Scout], onChangeCallback: Int->Void){
        self.Scouts = scouts
        self.OnChangeCallBack = onChangeCallback
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.Scouts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return self.Scouts[row].Name + "  " + self.Scouts[row].AssociatedTeam.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

        OnChangeCallBack(row)
    }
}

class UIPickerTextFieldDelegator : NSObject,UITextFieldDelegate
{
    var PickerView:UIPickerView
    var Parent:UIView
    var Movement:CGFloat
    
    init(pickerView:UIPickerView, parent:UIView, movement:CGFloat){
        self.PickerView = pickerView
        self.Parent = parent
        self.Movement = movement
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.moveTextAndPicker(textField,editing:true)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.moveTextAndPicker(textField,editing:false)
        return true
    }
    
    func moveTextAndPicker(textField:UITextField,editing:Bool){
        var movementDistance:CGFloat = self.Movement
        var movementDuration = 0.3
        var movement:CGFloat = (editing ? -movementDistance : movementDistance);
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.Parent.frame = CGRectOffset(self.Parent.frame, 0.0, movement)
        UIView.commitAnimations()
 
    }
    
}