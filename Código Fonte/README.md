# Entrega A3 - Inteligência Artificial: Goblins & Knights

Este repositório contém a entrega final do projeto de Inteligência Artificial, organizado em duas pastas principais: **Código Fonte** (projeto e executável) e **Poster** (banner de apresentação).

## 📍 Localização dos Scripts de IA

A implementação manual do algoritmo A* (A-Star) e sua aplicação prática encontram-se nos seguintes caminhos dentro da pasta `Código Fonte`:

* **Algoritmo A* (Lógica e Grid):**
    * `Código Fonte/TileSets/GradeAStar.gd`
    * *Descrição:* Script responsável pela geração da matriz, leitura de custos (Areia/Grama) e cálculo matemático da rota.

* **Agente Inteligente (Inimigo):**
    * `Código Fonte/Enemy/behaviors/seguir_jogador.gd`
    * *Descrição:* Script que controla o inimigo, solicitando o caminho ao Grid e executando o movimento com tolerância a falhas.

## 🐍 Nota sobre a Linguagem (GDScript vs. Python)

Embora IA seja frequentemente ensinada em **Python**, este projeto utiliza **GDScript**, a linguagem nativa da Godot Engine, para garantir a integração visual e a performance da simulação.

**Para o Avaliador:**
O GDScript possui uma sintaxe **intencionalmente similar ao Python**. A leitura do código segue a mesma lógica:
* **Indentação:** Define os blocos de código (igual ao Python).
* **Tipagem:** Dinâmica e gradual.
* **Estrutura:** O algoritmo A* implementado aqui segue a mesma estrutura lógica que teria em Python, apenas adaptando as chamadas de API para a engine gráfica.

**Exemplo de Leitura:**
* `func` é equivalente a `def`.
* `var` é usado para declarar variáveis.
* `extends Node` é similar a herdar uma classe.

## 🎮 Como Executar o Jogo (Build)

Para testar o projeto sem precisar instalar a engine, acesse a pasta:
`Código Fonte/Executavel/`

**⚠️ Importante:**
Mantenha os arquivos **`EntregaA3.exe`** e **`EntregaA3.pck`** sempre na mesma pasta. O jogo não funcionará se eles forem separados. Basta executar o arquivo `.exe` (Windows).

## 🛠️ Como Visualizar o Código Fonte

### Opção 1: Leitura Rápida (VSCode / Bloco de Notas)
Os arquivos `.gd` são arquivos de texto simples. Você pode abri-los em qualquer editor de texto para conferir a lógica do algoritmo A* e dos custos.

### Opção 2: Visualização Completa e Debug (Godot Engine)
Para visualizar a hierarquia de nós, o TileMap visualmente e rodar a simulação com ferramentas de debug (grid colorido):

1.  É necessário ter a **Godot Engine versão 4.5.1**.
2.  Abra a Godot e clique em "Import".
3.  Selecione o arquivo `project.godot` localizado dentro da pasta `Código Fonte`.
4.  Link para download da engine: [https://godotengine.org/download/archive/4.5.1-stable/](https://godotengine.org/download)

## ⚙️ Arquitetura e Inicialização (Requisito Técnico)

Conforme exigido na especificação do projeto sobre o "script de inicialização":

* **Script de Inicialização:** O arquivo **`project.godot`** (na raiz do código fonte) atua como o configurador de boot do sistema.
* **Execução:** Ao ser interpretado pela Engine, este arquivo direciona o fluxo para a Cena Principal (**`Main.tscn`**), onde os componentes (Inimigo, Grid e Jogador) são instanciados e o loop de jogo é iniciado automaticamente.

---
**Equipe:**
* Helder de Sena Ferreira Meyer
* Mateus Maia Ferreira
* Pedro Vitor Cordeiro Pompeu
* Ruan Diego de Farias Couto da Silva
