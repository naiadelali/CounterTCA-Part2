//
//  CounterFeatureView.swift
//  Counter
//
//  Created by Lameirão Lima on 29/01/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterFeatureView: View {
    /*O Store representa a execução da sua funcionalidade. Ou seja, é o objeto que pode processar ações para atualizar o estado e pode executar efeitos e alimentar dados desses efeitos de volta para o sistema.*/
    let store: StoreOf<CounterFeature>
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                    store.send(.toggleTimerButtonTapped)
                  }
                  .font(.largeTitle)
                  .padding()
                  .background(Color.black.opacity(0.1))
                  .cornerRadius(10)
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    CounterFeatureView(
        store: Store(initialState: CounterFeature.State()) {
            /*Ao comentar o CounterFeature() no Store, você desativa a lógica do reducer, permitindo que você teste apenas a interface do usuário.*/
            CounterFeature()
        }
    )
}
