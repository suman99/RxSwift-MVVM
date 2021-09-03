//
//  LearningStuff.swift
//  RxSwift-MVVM
//
//  Created by Suman on 01/09/2021.
//

import UIKit
import RxSwift
//https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd
//https://medium.com/flawless-app-stories/practical-mvvm-rxswift-a330db6aa693
class LearningStuff: UIViewController {

    let helloObservableString = Observable.just("Hello RX World")
    let observableInt = Observable.of(2,3,4)
    let observableDict = Observable.from([1:"Suman", 2:"Bhaskaran" ])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloObservableString.subscribe({ (event) in
            print(event)
        }).disposed(by: disposeBag)
        
        //Map :
        //For changing signals before it reaches to its subscribers you can use map method , for instance we have observable of Int which emits 3 numbers of 2,3,4 now we want numbers multipled by 10 before reaching its subscriber we can do this with following code:
        
        observableInt.map { value in
            return value * 10
        }.subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        
        //Filter:
        //You may want filter some of values before reaching to subscribers for example you want numbers that are above 25 in above example:
        //Will add later
        
        
        //FlatMap:
        //Imagine you have two observables and you want combine them into one observable:
        
        let sequenceA = Observable<Int>.of(1,2)
        let sequenceB = Observable<Int>.of(1,2)
        let sequenceAB = Observable.of(sequenceA, sequenceB)
        
        sequenceAB.flatMap{
            return $0
        }.subscribe(onNext: {
            print("Suman answer : ", $0)
        }).disposed(by: disposeBag)
        

        // DistinctUntilChanged or Debounce:
        // These two methods are one of the most useful methods in searching. For example, user wants to search a word ,you probably call search api every character when user typed. Well, if the user types quickly, you are calling many unneeded requests to the server. Correct way of achieving this is to call search api when user stops typing . To solve this problem, you can use the Debounce function :
        
        //**compactMap
        //The compactMap() method lets us transform the elements of an array just like map() does, except once the transformation completes an extra step happens: all optionals get unwrapped, and any nil values get discarded.
        
    }


}

