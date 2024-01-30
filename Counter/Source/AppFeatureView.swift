//
//  AppFeature.swift
//  Counter
//
//  Created by Lameirão Lima on 30/01/24.
//
import SwiftUI
import ComposableArchitecture

/*
 ❌ Como não fazer
 Isso não é ideal. Agora temos duas stores completamente isoladas que não são capazes de se comunicar entre si. No futuro, podem ocorrer eventos em uma aba que podem afetar a outra aba.
 
 É por isso que na Arquitetura Componível preferimos compor funcionalidades juntas e ter nossas views alimentadas por uma única Store, em vez de ter várias stores isoladas.
 */
/*struct AppView: View {
  let store1: StoreOf<CounterFeature>
  let store2: StoreOf<CounterFeature>
  
  var body: some View {
    TabView {
      CounterFeatureView(store: store1)
        .tabItem {
          Text("Counter 1")
        }
      
        CounterFeatureView(store: store2)
        .tabItem {
          Text("Counter 2")
        }
    }
  }
}*/


/*✅ Em vez de manter stores individuais para cada aba na AppView, agora podemos manter uma única store do domínio AppFeature composto e derivar child stores para cada aba que podem ser entregues às CounterViews.*/
struct AppView: View {
  /*Neste passo, a AppView está sendo configurada para usar uma única Store do domínio AppFeature,
   que gerencia o estado de ambas as abas. Para cada aba, uma child store é derivada usando o método scope.*/
  let store: StoreOf<AppFeature>
  
  var body: some View {
    TabView {
        /*O método scope é usado para criar uma store focada em uma parte específica do estado e das ações. 
         Isso é feito através de key paths que apontam para campos específicos no estado (\.tab1 e \.tab2)
         e casos específicos no enum de ação (AppFeature.Action.tab1 e AppFeature.Action.tab2).*/
        CounterFeatureView(store: store.scope(state: \.tab1, action: \.tab1))
            .tabItem {
              Text("Counter 1")
            }
      
        CounterFeatureView(store: store.scope(state: \.tab2, action: \.tab2))
            .tabItem {
              Text("Counter 2")
            }
    }
  }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
