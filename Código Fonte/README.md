# Entrega A3 - Inteligência Artificial: Goblins & Knights

Este repositório contém a entrega final do projeto de Inteligência Artificial, organizado em duas pastas principais: **Código Fonte** (projeto e executável) e **Poster** (banner de apresentação).

## 📍 Localização dos Scripts de IA

A implementação manual do algoritmo A* (A-Star) e sua aplicação prática encontram-se nos seguintes caminhos dentro da pasta `Código Fonte`:

* **Algoritmo A* (Lógica e Grid):**
    * `Código Fonte/TileSets/AStarGrid.gd`
    * *Descrição:* Script responsável pela geração da matriz, leitura de custos (Areia/Grama) e cálculo matemático da rota.

* **Agente Inteligente (Inimigo):**
    * `Código Fonte/Enemy/behaviors/follow_player.gd`
    * *Descrição:* Script que controla o inimigo, solicitando o caminho ao Grid e executando o movimento.

## 🎮 Como Executar o Jogo (Build)

Para testar o projeto sem abrir a engine, acesse a pasta:
`Código Fonte/Executavel/`

**⚠️ Importante:**
Mantenha os arquivos **`EntregaA3.exe`** e **`EntregaA3.pck`** sempre na mesma pasta. O jogo não funcionará se eles forem separados. Basta executar o arquivo `.exe`.

## 🛠️ Como Visualizar o Código

### Opção 1: Visualização Rápida (VSCode / Bloco de Notas)
Os arquivos `.gd` são arquivos de texto simples escritos em **GDScript**, a linguagem nativa da Godot.
* A sintaxe é extremamente similar à linguagem **Python**.
* Você pode abrir os arquivos listados acima em qualquer editor de texto para conferir a lógica.

### Opção 2: Visualização Completa e Debug (Godot Engine)
Para visualizar a hierarquia de nós, o TileMap visualmente e rodar a simulação com ferramentas de debug:

1.  É necessário ter a **Godot Engine versão 4.5.1**.
2.  Abra a Godot e importe o arquivo `project.godot` localizado dentro da pasta `Código Fonte`.
3.  Link para download: [https://godotengine.org/download/archive/4.5.1-stable/](https://godotengine.org/download)

---
**Equipe:**
* Helder de Sena Ferreira Meyer
* Mateus Maia Ferreira
* Pedro Vitor Cordeiro Pompeu
* Ruan Diego de Farias Couto da Silva