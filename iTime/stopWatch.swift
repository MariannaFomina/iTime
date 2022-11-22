//
//  ViewController.swift
//  iTime
//
//  Created by user on 21.11.2022.
//

import UIKit

class StopWatch: UIViewController, UITableViewDelegate, UITableViewDataSource {
           
    @IBOutlet weak var timerOutput: UILabel!
    
    @IBOutlet weak var lapAndResetButton: UIButton!
       
    @IBOutlet weak var table: UITableView!
    
    var stopWatch = Timer()
    var playTimer: Bool = true
    var lapTimer: Bool = true
    var counter: Double = 0.0
    var lapList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }


    @IBAction func startAndPauseTimer(_ sender: UIButton) {
    //запуск и остановка таймера
        if playTimer {
            stopWatch = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            lapAndResetButton.isEnabled = true
            changeStartAndPauseButton(by: sender, "pause.fill", text: "Pause")
            changeLapAndResetButton(by: lapAndResetButton, "plus.rectangle.fill", text: "Lap")
            lapTimer = true
        } else {
            stopWatch.invalidate()
            changeStartAndPauseButton(by: sender, "play.fill", text: "Play")
           changeLapAndResetButton(by: lapAndResetButton, "clear.fill", text: "Reset")
       lapTimer = false
            
        }
    }
    @IBAction func lapAndResetTimer(_ sender: UIButton) {
   //отсекать отрезок времени, отобразить в таблице, обнуление таймера
        if lapTimer {
        changeLapAndResetButton(by: sender, "plus.rectagle.fill", text: "Lap")
        lapList.append(timerOutput.text!)
        table.reloadData()
        } else {
            guard playTimer else { return }
            changeLapAndResetButton(by: sender, "plus.rectagle.fill", text: "Lap")
            lapAndResetButton.isEnabled = false
            lapList.removeAll()
            table.reloadData()
            timerOutput.text = "00:00"
            counter = 0.0
        }
    }

    @objc func updateTimer(){
        counter += 0.035
        
        var minutes: String = "\((Int)(counter / 60))"
        if(Int)(counter / 60) < 10{
            minutes = "0\((Int)(counter / 60))"
        }
        
        //%.2f = 00.00
        var seconds: String = String(format: "%.2f", counter.truncatingRemainder(dividingBy: 60))
        if counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
           }
        timerOutput.text = minutes + ":" + seconds
    }
    
    func changeStartAndPauseButton(by button:UIButton, _ image: String, text title: String) {
        playTimer = !playTimer
        button.setTitle(title, for: UIControl.State())
        button.setImage(UIImage(systemName: image), for: UIControl.State())
          }
    
    func changeLapAndResetButton(by button:UIButton, _ image: String, text title: String) {
        button.setTitle(title, for: UIControl.State())
        button.setImage(UIImage(systemName: image), for: UIControl.State())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath) as! TableCell
        
        cell.TableLabel.text = lapList[indexPath.row]
        return cell
    }
}
