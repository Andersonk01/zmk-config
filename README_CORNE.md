# Configuração Corne (CRKBD) com nice!nano

Esta é uma configuração inicial funcional para o teclado **Corne** (também conhecido como CRKBD) usando **nice!nano v2** e firmware **ZMK**.

## 📁 Estrutura de Arquivos

```
E:\
├── build.yaml              # Configuração de build (LEFT e RIGHT)
├── config/
│   ├── corne.conf          # Configurações do teclado (OLED, sleep, etc.)
│   └── corne.keymap        # Mapeamento de teclas
└── README_CORNE.md         # Este arquivo
```

## 🎹 Layout de Teclas

### Layer 0 (Base - QWERTY)
Layout padrão QWERTY. Thumb keys configuradas como:
- **Esquerda**: ESC e TAB
- **Direita**: SPACE e ENTER

### Layer 1 (Números e Símbolos)
Ativado com **MO(1)** (momentary - enquanto pressionado)
- Números na linha superior
- Símbolos nas outras linhas

### Layer 2 (Funções e Navegação)
Ativado com **MO(2)**
- F1-F10 na linha superior
- Setas e navegação na linha do meio

### Layer 3 (Bluetooth e Ajustes)
- Controle de Bluetooth
- Controle de volume
- Modificadores

## ⚙️ Configurações Ativas

- ✅ **OLED habilitado** (se você tiver display)
- ✅ **Deep sleep** após 15 minutos de inatividade
- ✅ **Combos habilitados** (combinações de teclas)
- ✅ **Bluetooth** configurado para 2 conexões

## 🚀 Como Compilar e Instalar

### Opção 1: GitHub Actions (Recomendado)

1. **Crie um repositório no GitHub:**
   - Acesse https://github.com/new
   - Nome: `zmk-config` (ou outro)
   - **NÃO** adicione README, .gitignore ou licença

2. **Faça upload dos arquivos:**
   ```bash
   git init
   git add .
   git commit -m "Configuração inicial Corne"
   git remote add origin https://github.com/SEU_USUARIO/zmk-config.git
   git push -u origin main
   ```

3. **Ative GitHub Actions:**
   - Vá em Settings → Actions → General
   - Ative "Allow all actions and reusable workflows"
   - Vá em Actions e clique em "Run workflow"

4. **Baixe o firmware:**
   - Após o build, baixe o artefato `firmware.zip`
   - Extraia os arquivos `corne_left-nice_nano_v2-zmk.uf2` e `corne_right-nice_nano_v2-zmk.uf2`

### Opção 2: Compilação Local

Se você tem o ambiente ZMK configurado localmente:

```bash
west build -p -b nice_nano_v2 -- -DSHIELD=corne_left
west build -p -b nice_nano_v2 -- -DSHIELD=corne_right
```

Os arquivos `.uf2` estarão em `build/zephyr/`

## 💾 Instalação no nice!nano

### Para o lado ESQUERDO:

1. Conecte o nice!nano esquerdo via USB-C
2. Pressione o botão **RESET duas vezes rapidamente**
3. Aparecerá um drive chamado **"NICENANO"**
4. Copie o arquivo `corne_left-nice_nano_v2-zmk.uf2` para o drive
5. Aguarde alguns segundos

### Para o lado DIREITO:

1. Conecte o nice!nano direito via USB-C
2. Pressione o botão **RESET duas vezes rapidamente**
3. Aparecerá um drive chamado **"NICENANO"**
4. Copie o arquivo `corne_right-nice_nano_v2-zmk.uf2` para o drive
5. Aguarde alguns segundos

### ⚠️ Importante:

- **Nunca é preciso apagar** arquivos dentro do NICENANO
- Sempre que atualizar, apenas copie o novo arquivo sobre o anterior
- É normal aparecer um erro após o flash - não se preocupe!

## 🔧 Personalização

### Modificar o Keymap

Edite o arquivo `config/corne.keymap`:

- **Trocar teclas**: Substitua `&kp A` por outra tecla (ex: `&kp B`)
- **Adicionar layers**: Crie novos layers e adicione em `zmk,keymap`
- **Modificar thumb keys**: Altere as últimas 4 teclas do default_layer

### Exemplos de Códigos de Teclas:

```dts
&kp A              // Tecla A
&kp SPACE          // Barra de espaço
&kp ENTER          // Enter
&mo 1              // Ativa layer 1 (momentary)
&tog 1             // Alterna layer 1 (toggle)
&kp LSHIFT         // Shift esquerdo
&kp LCTRL          // Ctrl esquerdo
&kp LGUI           // Windows/Command
```

### Modificar Configurações

Edite `config/corne.conf`:

- **Desabilitar OLED**: Comente ou remova as linhas `CONFIG_ZMK_DISPLAY=y`
- **Ajustar sleep**: Modifique `CONFIG_ZMK_IDLE_SLEEP_TIMEOUT` (em milissegundos)
- **Habilitar RGB**: Descomente as linhas de RGB

## 📚 Recursos Úteis

- **Documentação ZMK**: https://zmk.dev/docs
- **Keycodes ZMK**: https://zmk.dev/docs/codes
- **Behaviors ZMK**: https://zmk.dev/docs/behaviors
- **Corne Keyboard**: https://github.com/foostan/crkbd

## 🆘 Troubleshooting

### Teclado não funciona após flash
- Verifique se flashou ambos os lados (LEFT e RIGHT)
- Certifique-se de usar os arquivos corretos para cada lado

### nice!nano não aparece como drive
- Pressione RESET **duas vezes rapidamente** (não apenas uma)
- Verifique se o cabo USB está funcionando

### Thumb keys não ativam layers
- Edite o keymap e configure os thumb keys com `&mo 1`, `&mo 2`, etc.
- Verifique se o número do layer corresponde

### OLED não funciona
- Verifique se o display está conectado corretamente
- Confirme que `CONFIG_ZMK_DISPLAY=y` está em `corne.conf`

## ✨ Próximos Passos

1. ✅ Teste o layout básico
2. 🔧 Personalize o keymap conforme suas necessidades
3. 🎨 Adicione mais layers se necessário
4. ⚡ Configure combos para atalhos
5. 📱 Ajuste configurações de bateria e sleep

---

**Boa digitação!** ⌨️✨

