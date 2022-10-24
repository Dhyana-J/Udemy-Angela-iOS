//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Kaala on 2022/10/24.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    // delegate를 이렇게 늘려나가도 되는건지 의문..
    // editActionsForRowAt에 사용할 변수들
    var categoryDelegate:CategoryViewController?
    var toDoListDelegate:ToDoListViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        print(#function)
        
        
        // placeholder 역할 row는 스와이프 안되도록 설정
        if (categoryDelegate?.categories != nil && categoryDelegate?.categories?.count == 0)
            ||
            (toDoListDelegate != nil &&
            toDoListDelegate?.todoListItems?.count == 0) {
            return nil
        }
        
        
        guard orientation == .right else { return nil } //오른쪽에서부터 왼쪽으로 스와이프
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in // 스와이프시 동작
            
            print("Delete Cell")
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    // 스와이프 끝까지 밀면 delete되게끔 해주는 method
    //    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    //
    //        /* -- 이 메서드 문제
    //         tableView에 유저가 지정한 카테고리 row가 1개남은 경우, 지우면 row 수가 0이 된다.
    //         근데, numberOfRowsInSection에서 row가 0이 되면 placeholder를 세팅해야하므로 row수가 1이 되게끔 리턴한다.
    //         여기서 이 메서드와 충돌이 일어난다.
    //
    //         이 메서드는 row가 0이랑 일치해야한다고 하는데, 기존 메서드에서 1로 세팅해버리니 자기는 모르겠다고 충돌일으킴...
    //
    //         */
    //
    //        print(#function)
    //
    //        var options = SwipeOptions()
    //        options.expansionStyle = .destructive
    //        options.transitionStyle = .border
    //        return options
    //    }
    
    
    func updateModel(at indexPath:IndexPath){
        // Update our data model
        
    }
    
}
