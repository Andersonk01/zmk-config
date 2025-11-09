# Guia de Configuração - Sofle ZMK com OLED

Baseado no repositório: [tupinikeebs/sofle-zmk_oled](https://github.com/tupinikeebs/sofle-zmk_oled)

## 📚 Introdução

Este guia é específico para o teclado **Sofle** usando **ZMK** com suporte a **OLED**. 

**Importante:** Para entender melhor a plataforma ZMK e todas as suas funcionalidades, leia a [documentação completa do ZMK](https://zmk.dev/docs).

---

## ✅ Pré-requisitos

1. **Fazer Fork do Repositório**
   - Acesse: https://github.com/tupinikeebs/sofle-zmk_oled
   - Clique em "Fork" para criar sua própria cópia
   - Isso permite personalizar sem afetar o repositório original

---

## 🎨 Métodos de Configuração

Existem **3 formas principais** de configurar seu teclado:

### 1. KeymapEditor (⭐ RECOMENDADO para Iniciantes)

**Vantagens:**
- Interface gráfica visual (GUI)
- Sem limitações de funcionalidades
- Aprenda enquanto configura
- Acesso a todas as funções avançadas:
  - Tap dance
  - Behaviors
  - Conditional layers
  - Macros
  - Combos
  - Layers infinitas
  - E muito mais!

**Como usar:**
1. Acesse o [KeymapEditor](https://keymap-editor.com) (ou similar)
2. Faça login com sua conta GitHub
3. Vincule o fork do repositório que você criou
4. Configure seu keymap visualmente
5. Clique em **"Save"** no canto superior esquerdo
6. As alterações serão enviadas automaticamente para o GitHub
7. Uma pipeline será acionada para compilar o projeto
8. Após o build, um artefato chamado **`firmware.zip`** ficará disponível para download

**Por que é recomendado:**
- Automatiza alterações de volta para o GitHub
- Builda automaticamente via GitHub Actions
- Não precisa mexer em código manualmente
- Ideal para quem está começando

---

### 2. ZMK Studio (Beta)

**Características:**
- GUI mais nova do ZMK
- Ainda está em Beta
- **Limitações:**
  - Não salva configs direto no GitHub
  - Não tem algumas configurações de tap dance e behaviors
  - Funcionalidades mais limitadas

**Vantagem:**
- Quase nunca precisa mexer em código
- Não precisa compilar manualmente
- Atualizações mais rápidas durante desenvolvimento

**Desvantagem:**
- Menos recomendado para aprendizado
- Funcionalidades limitadas comparado ao KeymapEditor

---

### 3. Configuração Manual (Para Avançados)

**Quando usar:**
- Quando você já conhece bem o ZMK
- Quando precisa de configurações muito específicas
- Quando quer controle total sobre o código

**Passos:**

1. **Forkar a config setup do ZMK**
   - Use o setup oficial do ZMK ou este repositório

2. **Escolher a Board**
   - Na maioria dos casos: **Board: Nice!nano V2**
   - Se for versão antiga: **Nice!nano V1**

3. **Copiar o layout base/default**
   - Copie o keymap padrão para o GitHub
   - Isso garante uma base sólida para começar

4. **Editar o arquivo `[teclado].keymap`**
   - Edite diretamente no GitHub ou localmente
   - Adicione regras e comportamentos conforme necessário
   - **Atenção:** Só faça isso se já leu a documentação do ZMK e sabe o que está fazendo!

**Vantagens da configuração manual:**
- Sem limitações de GUI
- Controle total
- Apenas limitado pelo seu próprio conhecimento de código

---

## 💾 Instalação do Firmware

### Passo 1: Preparar o nice!nano

1. **Conectar o cabo USB** ao nice!nano
2. **Pressionar o botão RST duas vezes rapidamente** (em menos de 1 segundo)
   - Isso coloca o nice!nano no modo bootloader

### Passo 2: Flashear o Firmware

1. Uma pasta aparecerá como um pendrive com o nome **"NICENANO"** (ou "NICENANO_BOOT")

2. **Para teclados split (como Sofle):**
   - Copie o arquivo **LEFT** (esquerdo) para o nice!nano do lado esquerdo
   - Copie o arquivo **RIGHT** (direito) para o nice!nano do lado direito

3. **Para teclados não-split:**
   - Copie apenas um arquivo `.uf2` para o nice!nano

### Passo 3: Atualizações Futuras

- **Nunca é preciso apagar** arquivos dentro do NICENANO
- Sempre que atualizar, **apenas copie o novo arquivo** sobre o anterior
- O bootloader gerencia tudo automaticamente

### ⚠️ Nota Importante

É comum aparecer um erro após passar o novo firmware para o teclado. **Não se preocupe!** Não é um bug, é uma feature do ZMK. O teclado deve funcionar normalmente após isso.

---

## 📁 Estrutura do Repositório

O repositório contém:

```
sofle-zmk_oled/
├── .github/
│   └── workflows/          # GitHub Actions para build automático
├── boards/
│   └── shields/            # Definições do shield Sofle
├── config/                 # Arquivos de configuração
│   └── [teclado].keymap   # Mapeamento de teclas
├── zephyr/                 # Configurações do Zephyr RTOS
├── build.yaml              # Configuração de build
└── README.md               # Documentação
```

---

## 🔧 Dicas Importantes

1. **Sempre faça fork** antes de personalizar
2. **Use KeymapEditor** se estiver começando
3. **Leia a documentação do ZMK** para entender comportamentos avançados
4. **Teste o firmware** antes de soldar tudo definitivamente
5. **Use soquetes** no nice!nano para facilitar atualizações
6. **Mantenha backups** das configurações que funcionam

---

## 🆘 Troubleshooting

### nice!nano não aparece como drive
- Pressione o botão RESET **duas vezes rapidamente**
- Certifique-se de que o cabo USB está conectado corretamente

### Firmware não funciona após flash
- Verifique se compilou para o shield correto (Sofle)
- Certifique-se de usar nice!nano v2 (ou v1 se for a versão antiga)

### Erro após flash
- É normal! O ZMK mostra erros que são features, não bugs
- Teste o teclado mesmo assim

### Teclas não respondem
- Verifique a fiação
- Confirme que o keymap está correto
- Verifique se ambos os lados (left/right) foram flashados corretamente

---

## 📚 Recursos Adicionais

- **Documentação ZMK**: https://zmk.dev/docs
- **KeymapEditor**: https://keymap-editor.com (ou similar)
- **ZMK Studio**: https://zmk.studio (Beta)
- **Repositório Original**: https://github.com/tupinikeebs/sofle-zmk_oled

---

## 🎯 Próximos Passos

1. Faça fork do repositório
2. Escolha seu método de configuração (recomendado: KeymapEditor)
3. Configure seu keymap
4. Compile o firmware (automático via GitHub Actions ou manual)
5. Flashe no nice!nano
6. Teste e ajuste conforme necessário

