//
//  AppFeature.swift
//  Counter
//
//  Created by Lameirão Lima on 30/01/24.
//

import ComposableArchitecture
/*o compor reducers, você cria uma estrutura unificada que pode gerenciar várias instâncias de uma funcionalidade menor, permitindo que elas interajam e compartilhem lógica.*/
@Reducer
struct AppFeature {
  struct State: Equatable {
    var tab1 = CounterFeature.State()
    var tab2 = CounterFeature.State()
  }
  enum Action {
    case tab1(CounterFeature.Action)
    case tab2(CounterFeature.Action)
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.tab1, action: \.tab1) {
      CounterFeature()
    }
    Scope(state: \.tab2, action: \.tab2) {
      CounterFeature()
    }
    Reduce { state, action in
      // Lógica central da funcionalidade do aplicativo
      return .none
    }
  }
}


