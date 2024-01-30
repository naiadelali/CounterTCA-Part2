//
//  CounterFeature.swift
//  Counter
//
//  Created by Lameirão Lima on 29/01/24.
//


import ComposableArchitecture
import Foundation
/*
 Um Reducer é essencialmente onde toda a lógica de negócios e o comportamento de uma funcionalidade específica do seu aplicativo são definidos.
 Isso inclui como o estado é atualizado em resposta a ações e como efeitos (como chamadas de API) são gerenciados.
 */
@Reducer
struct CounterFeature {
    /*A anotação @ObservableState é usada para tornar o estado observável pelo SwiftUI, permitindo que as mudanças de estado atualizem a UI automaticamente.*/
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    /*As ações (Action) são definidas como um enum e representam todas as interações possíveis do usuário com a UI que podem afetar o estado. */
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        
        case timerTick
        case toggleTimerButtonTapped
    }
    
    enum CancelID { case timer }
    /*A implementação do reducer, que determina como o estado muda em resposta às ações.*/
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                //Uso de Effect.run: Este método permite realizar trabalho assíncrono e, em seguida, enviar ações de volta para o sistema.
                //Isso é ideal para efeitos colaterais, como solicitações de rede.
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    //O Effect não consegue manipular o estado atual, é preciso mandar um novo estado, por isso send(.factResponse(fact))
                    await send(.factResponse(fact))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    //Efeito run: O efeito run é usado para executar o timer de forma assíncrona, permitindo que ações sejam enviadas de volta para o sistema.
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    /*Podemos marcar qualquer efeito como cancelável usando o método cancellable(id:cancelInFlight:), fornecendo um ID,
                     e depois, em um momento posterior, podemos cancelar esse efeito usando cancel(id:)*/
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
