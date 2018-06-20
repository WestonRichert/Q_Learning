//
//  main.swift
//  Q_Learning
//
//  Created by Weston Richert on 11/5/17.
//  Copyright © 2017 Weston Richert. All rights reserved.
//

import Foundation


func runProgram()
{
    //Initialize Variables
    let gamma = 0.5
    var qArray: Array<Double> = []
    var rArray: Array<Int> = []
    var currentState = 30
    
    //Initialize R and Q Array
    for _ in 0...279
    {
        qArray.append(0.0)
        rArray.append(-1)
    }
    //These actions from the states put the agent in the goal state
    rArray[227] = 100 //Right from 56
    rArray[269] = 100 //Up from 67
    rArray[188] = 100 //Down from 47
    rArray[234] = 100 //Left from 58
    
    
    for i in 0...100
    {
        var count = 0
        while currentState != 37
        {
            /**if i == 100
            {
                print(currentState)
            }*/
            count += 1
            
            let downValue = qArray[currentState * 4]
            let upValue = qArray[currentState * 4 + 1]
            let leftValue = qArray[currentState * 4 + 2]
            let rightValue = qArray[currentState * 4 + 3]
            let action = getAction(down: downValue, up: upValue, left: leftValue, right: rightValue, state: currentState)
            
            let nextState = assignNextState(currentState: currentState, action: action)
            
            updateQValue(state: &currentState, nextState: nextState, rewardArray: rArray, qArray: &qArray, gamma: gamma, action: action)
        }
        currentState = 30
        print(count)
    }
}

//Assign the next state
func assignNextState(currentState: Int, action: Int) -> Int
{
    let oneWind = [3,13,23,33,43,53,63,4,14,24,34,44,54,64,5,15,25,35,45,55,65,8,18,28,38,48,58,68]
    let twoWind = [6,16,26,36,46,56,66,7,17,27,37,47,57,67]
    var nextState = currentState
    
    if action == 0 && currentState < 60
    {
        if currentState + 10 < 70
        {
        nextState = currentState + 10
        }
    }
    else if action == 1 && currentState > 9
    {
        if currentState - 10 > -1
        {
        nextState = currentState - 10
        }
    }
    else if action == 2 && currentState % 10 != 0
    {
        if currentState - 1 > -1
        {
        nextState = currentState - 1
        }
    }
    else if action == 3 && currentState % 10 != 9
    {
        if currentState + 1 < 70
        {
        nextState = currentState + 1
        }
    }

    if twoWind.contains(nextState)
    {
        if nextState - 20 > -1
        {
            nextState -= 20
        }
        else if nextState - 10 > -1
        {
            nextState -= 10
        }
    }
    if oneWind.contains(nextState)
    {
        if nextState - 10 > -1
        {
            nextState -= 10
        }
    }
    
    return nextState
}

//Use Q Values to find the best action to take
func getAction(down: Double, up: Double, left: Double, right: Double, state: Int) -> Int
{
    
    let rightConstraint = [9,19,29,39,49,59,69]
    let leftConstraint = [0,10,20,30,40,50,60]
    let upConstraint = [0,1,2,3,4,5,6,7,8,9]
    let downConstraint = [60,61,62,63,64,65,66,67,68,69]
    
    var finalDown = -1000.0
    var finalUp = -1000.0
    var finalLeft = -1000.0
    var finalRight = -1000.0
    
    if !downConstraint.contains(state)
    {
        finalDown = down
    }
    if !upConstraint.contains(state)
    {
        finalUp = up
    }
    if !leftConstraint.contains(state)
    {
        finalLeft = left
    }
    if !rightConstraint.contains(state)
    {
        finalRight = right
    }
    
    //let maxValue = max(finalDown,finalUp,finalLeft,finalRight)
    let maxValue = max(finalDown,finalUp,finalLeft,finalRight)
    var answer: Array<Int> = []
    if (maxValue == down)
    {
        answer.append(0)
    }
    if (maxValue == up)
    {
        answer.append(1)
    }
    if (maxValue == left)
    {
        answer.append(2)
    }
    if (maxValue == right)
    {
        answer.append(3)
    }
    
    let rand = Int(arc4random_uniform(10))
    let num = Int(arc4random_uniform(UInt32(answer.count)))
    if rand == 7
    {
        answer[num] = Int(arc4random_uniform(4))
    }
    return answer[num]
}

//Analyze possible actions of next state, get maximum Q Value
func nextStateMax(nextState: Int, qValues: Array<Double>) -> Double
{
    var downValue = -1000.0
    var upValue = -1000.0
    var leftValue = -1000.0
    var rightValue = -1000.0
    let rightConstraint = [9,19,29,39,49,59,69]
    let leftConstraint = [0,10,20,30,40,50,60]
    let upConstraint = [0,1,2,3,4,5,6,7,8,9]
    let downConstraint = [60,61,62,63,64,65,66,67,68,69]
    
    let downPos = (nextState * 4)
    let upPos = (nextState * 4) + 1
    let leftPos = (nextState * 4) + 2
    let rightPos = (nextState * 4) + 3
    
    if (downPos < 280 && !(downConstraint.contains(nextState)))
    {
        downValue = qValues[downPos]
    }
    
    if (rightPos < 280 && !(rightConstraint.contains(nextState)))
    {
        rightValue = qValues[rightPos]
    }
    
    if (upPos < 280 && !(upConstraint.contains(nextState)))
    {
        upValue = qValues[upPos]
    }
    
    if (leftPos < 280 && !(leftConstraint.contains(nextState)))
    {
        leftValue = qValues[leftPos]
    }
    
    return max(downValue, upValue,leftValue,rightValue)
}

//Function to update the current Q Value
func updateQValue(state: inout Int, nextState: Int, rewardArray: Array<Int>, qArray : inout Array<Double>, gamma: Double, action: Int)
{
    let reward = Double(rewardArray[(state * 4) + action])
    qArray[(state * 4) + action] = reward + gamma * nextStateMax(nextState: nextState, qValues: qArray)
    
    state = nextState
}


runProgram()
