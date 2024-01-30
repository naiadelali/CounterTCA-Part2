# README: Estudos da Arquitetura Componível - Parte 2
Parte 1: https://github.com/naiadelali/CounterTCA
## Imagem 
![](https://github.com/naiadelali/CounterTCA-Part2/blob/main/Diagram.png?raw=true)

## Visão Geral

Este README resume os aprendizados da segunda parte do estudo sobre a Arquitetura Componível (The Composable Architecture - TCA) no Swift. Nesta sessão, focamos na composição de funcionalidades e na criação de uma aplicação com múltiplas abas, utilizando uma única `Store` para gerenciar o estado de maneira coesa e modular.

## Composição de Funcionalidades

### ❌ Abordagem Incorreta: Stores Isoladas

Inicialmente, exploramos uma abordagem ingênua para compor funcionalidades, onde cada aba (`TabView`) tinha sua própria `Store` isolada. Isso resultou em:

- Duas stores completamente isoladas (`store1` e `store2`).
- Incapacidade das abas de se comunicarem entre si.
- Dificuldade em gerenciar o estado compartilhado ou interações entre abas.

### ✅ Abordagem Correta: Composição Unificada

A abordagem correta envolveu a composição das funcionalidades no nível do reducer, utilizando uma única `Store` do domínio `AppFeature`. Isso foi alcançado por:

- Criando uma `Store` unificada para o domínio `AppFeature`.
- Derivando child stores para cada aba usando o método `scope`.
- Focando em partes específicas do estado para cada aba (`\.tab1` e `\.tab2`).

## Implementação

### Estrutura do Projeto

- **AppFeature.swift**: Contém a lógica central da aplicação e a composição dos reducers.
- **AppView**: A view principal que utiliza a `TabView` para apresentar as abas.

### Código de Exemplo

```swift
struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    TabView {
      CounterFeatureView(store: store.scope(state: \.tab1, action: \.tab1))
        .tabItem { Text("Counter 1") }
      
      CounterFeatureView(store: store.scope(state: \.tab2, action: \.tab2))
        .tabItem { Text("Counter 2") }
    }
  }
}
```

### Composição de Reducers

Utilizamos o reducer `Scope` para focar em subdomínios específicos do estado e ações, permitindo a composição eficiente dos reducers de `CounterFeature` em `AppFeature`.

## Conclusão

A segunda parte do estudo sobre a Arquitetura Componível destacou a importância da composição correta de funcionalidades em uma aplicação Swift. Aprendemos como gerenciar o estado de forma eficaz em uma aplicação com múltiplas abas, mantendo a modularidade e a clareza do código. Esta abordagem não só facilita a manutenção e expansão do aplicativo, mas também permite testes mais eficientes e uma arquitetura mais robusta.
