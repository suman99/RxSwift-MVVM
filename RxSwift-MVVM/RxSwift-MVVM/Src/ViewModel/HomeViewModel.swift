//
//  HomeViewModel.swift
//  RxSwift-MVVM
//
//  Created by Suman on 02/09/2021.
//

import Foundation
import RxSwift
import RxCocoa

// we have to send 3 things from view model to view
//1. Loading(Bool): Whereas we send a request to the server, we should show a loading. So the user understands, something is    loading now. For this, we need the Observables of Bool. When it was true it would mean that it is loading and when it was false — it has loaded (if you don’t know what are observables read part1).
//2. Error(homeError): The possible errors from the server and any other errors. It could be pop ups, Internet errors, and … this one should be observables of error type, so that if it had a value, we would show it on the screen.
//3. The collection and table views data.


class HomeViewModel {
    
    
    public enum HomeError{
        case internetError(String)
        case serverMessage(String)
    }
    
    // So we have three kinds of Observables that our parent class should be registered to them:

    // lets define the Observables
    
    public let albums: PublishSubject<[Album]> = PublishSubject()
    public let tracks: PublishSubject <[Track]> = PublishSubject()
    public let loading: PublishSubject <Bool> = PublishSubject()
    public let error: PublishSubject<HomeError> = PublishSubject()
    
    
    //These are our view model class variables. All the four of them are observables and without a first value. Now you may ask: what is PublishSubject?
    
    //As we said before, some of the variables are Observer and some of them are Observable. And we have another one that can be both Observer(subscribe) and Observable(publisher) at the same time, these are called Subjects.
    
    //One of the good reason for using PublishSubject is that can be initialized without an initial value.
    
    //*****UI to data binding (RxCocoa)*****
    //Now let’s get into the code and see how can we can feed data to our view:

    //we need to prepare the HomeViewController class for observing the viewModel variables and react views from the view model data:
    
    //In order for our data to bind to UIKit, in favor of RxCocoa, there are so many properties available from different Views that you can access those from rxproperty. These properties are Binders.
    
    //It means whenever we bind an Observable to a binder, the binder reacts to the Observable value.
    
    //For example, imagine you have PublishSubject of a Bool which produces true and false. If you bind this subject to the isHidden property of a view, the view would be hidden if the publishSubject produces true. If the publishSubject produces false, the view isHidden property would become false and then the view would no longer be hidden.
    
    
    //*******Request data from View Model

    public func requestData(){
        
        //we are emitting loading value to true and because we already do the binding in HomeVC class, our viewController now showing the loading animation.
        self.loading.onNext(true)
        
        //Next, we are just sending a request for data to the network layer (Alamofire or any network layer we have).
        APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: {(result) in
            
           
            //After that, we got the response from the server we should end the loading animation by emitting false to loading.
            self.loading.onNext(false)
            
            switch result{
            //If the response was successful, we parse the data and emit values of albums and tracks.
            case .success(let returnJson) :
                let albums = returnJson["Albums"].arrayValue.compactMap { return Album(data: try! $0.rawData())}
                let tracks = returnJson["Tracks"].arrayValue.compactMap { return Track(data: try! $0.rawData())}
                self.albums.onNext(albums)
                self.tracks.onNext(tracks)
                
            case .failure(let failure):
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
                
            }
            
        })
    }
    
}

