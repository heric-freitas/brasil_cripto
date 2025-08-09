# 🇧🇷 BrasilCripto App

Um aplicativo Flutter moderno para acompanhar o mercado de criptomoedas, permitindo aos usuários pesquisar, visualizar detalhes, acompanhar o histórico de preços com gráficos interativos e gerenciar uma lista de favoritos de forma persistente.

## 🌟 Funcionalidades

*   **Pesquisa Dinâmica:** Busque criptomoedas por nome ou símbolo em tempo real.
*   **Lista Abrangente:** Visualize as principais informações das criptomoedas, incluindo preço, variação percentual e volume.
*   **Detalhes Aprofundados:** Acesse uma página dedicada para cada criptomoeda com dados detalhados e gráficos de histórico de preço.
*   **Sistema de Favoritos:** Adicione e remova criptomoedas da sua lista de favoritos, persistindo os dados localmente.
*   **Navegação Intuitiva:** Alterne facilmente entre a lista geral e a lista de favoritos através de uma barra de navegação inferior.
*   **Gerenciamento de Estado Otimizado:** Utiliza `Bloc` e `Streams` para uma interface responsiva e reativa.
*   **Cache Inteligente:** Armazena dados localmente com `Hive` para reduzir requisições à API e melhorar o desempenho, especialmente em acessos recorrentes e cenários offline.
*   **Tratamento de Erros:** Feedback claro ao usuário em caso de falhas na comunicação com a API ou no carregamento de dados.

## 🚀 Tecnologias Utilizadas

Este projeto foi construído utilizando as seguintes ferramentas e pacotes:

*   **Flutter:** Framework UI para construir aplicações nativas compiladas de uma única base de código.
*   **Dart:** Linguagem de programação otimizada para Flutter.
*   **CoinCap API:** Fonte de dados para informações em tempo real de criptomoedas (`https://docs.coincap.io/`).
*   **Dio:** Cliente HTTP poderoso para requisições à API, com suporte a interceptors, timeouts, e tratamento de erros.
*   **Bloc (Business Logic Component):** Padrão de gerenciamento de estado baseado em eventos e estados, utilizando Streams para atualização reativa da interface.
*   **Hive:** Banco de dados NoSQL leve e rápido para armazenamento local e persistência de dados (ex: lista de favoritos e cache de ativos).
*   **flutter_getit:** Pacote para injeção de dependências e gerenciamento de rotas, promovendo uma arquitetura limpa e desacoplada.
*   **fl_chart:** Biblioteca robusta para a criação de gráficos interativos e personalizáveis, utilizada para exibir o histórico de preços das criptomoedas.
*   **intl:** Para formatação de números e datas, garantindo a apresentação correta dos dados financeiros.
*   **path_provider:** Auxilia na localização de diretórios para armazenamento de dados no dispositivo.

## ⚙️ Como Começar

Siga estas instruções para configurar e executar o projeto em sua máquina local.

### Pré-requisitos

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
*   Um editor de código como [VS Code](https://code.visualstudio.com/) com as extensões Flutter e Dart.

### Instalação e Execução

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/heric-freitas/brasil_cripto.git
    cd brasil_cripto
    ```

2.  **Obtenha as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Gere os arquivos do Hive (Type Adapters):**
    ```bash
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```
    Este comando cria os arquivos `.g.dart` necessários para o Hive persistir seus modelos.

4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
    O aplicativo será iniciado em um emulador ou dispositivo conectado.

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](https://opensource.org/licenses/MIT).