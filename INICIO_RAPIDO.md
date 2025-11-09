# 🚀 Início Rápido - Corne com nice!nano

## ✅ Configuração Criada!

Sua configuração inicial do Corne está pronta! Aqui está o que foi criado:

```
E:\
├── build.yaml              ← Configuração de build
├── config/
│   ├── corne.conf          ← Configurações (OLED, sleep, etc.)
│   └── corne.keymap        ← Mapeamento de teclas
└── README_CORNE.md         ← Documentação completa
```

## 📋 Layout Atual

### Thumb Keys (Layer 0):
- **Esquerda**: MO(1) | ESC | TAB
- **Direita**: SPACE | ENTER | MO(1)

**MO(1)** = Ativa Layer 1 (números/símbolos) enquanto pressionado

### Layers Disponíveis:
- **Layer 0**: QWERTY básico
- **Layer 1**: Números e símbolos (ativado com MO(1))
- **Layer 2**: Funções e navegação
- **Layer 3**: Bluetooth e ajustes

## 🎯 Próximos Passos

### Opção 1: GitHub Actions (Mais Fácil) ⭐

1. **Crie repositório no GitHub:**
   - https://github.com/new
   - Nome: `zmk-config`
   - **NÃO** adicione README

2. **Faça upload:**
   ```bash
   git init
   git add .
   git commit -m "Config inicial Corne"
   git remote add origin https://github.com/SEU_USUARIO/zmk-config.git
   git push -u origin main
   ```

3. **Compile via Actions:**
   - Vá em Settings → Actions → General → Ative "Allow all actions"
   - Vá em Actions → "Run workflow"
   - Aguarde o build
   - Baixe `firmware.zip`

4. **Instale:**
   - Extraia `corne_left-nice_nano_v2-zmk.uf2` e `corne_right-nice_nano_v2-zmk.uf2`
   - Pressione RESET 2x no nice!nano esquerdo → Copie LEFT.uf2
   - Pressione RESET 2x no nice!nano direito → Copie RIGHT.uf2

### Opção 2: KeymapEditor (Visual) 🎨

1. **Fork este repositório** (ou crie um novo)
2. **Acesse:** https://keymap-editor.com
3. **Login com GitHub** e vincule seu repositório
4. **Configure visualmente** seu keymap
5. **Salve** → Build automático!

## ⚡ Instalação Rápida

### Para cada lado (LEFT e RIGHT):

1. **Conecte USB** ao nice!nano
2. **Pressione RESET 2x rapidamente** (< 1 segundo)
3. **Aparece drive "NICENANO"**
4. **Copie o arquivo .uf2** correspondente
5. **Aguarde** alguns segundos

⚠️ **Importante:**
- Use **LEFT.uf2** no lado esquerdo
- Use **RIGHT.uf2** no lado direito
- Não precisa apagar nada, apenas copiar sobre o anterior

## 🔧 Personalização Rápida

### Trocar uma tecla:
Edite `config/corne.keymap` e substitua:
```dts
&kp A    // Por exemplo, trocar A por B:
&kp B
```

### Adicionar Layer aos thumbs:
```dts
&mo 2    // Ativa layer 2
&tog 1   // Alterna layer 1
```

### Desabilitar OLED:
Edite `config/corne.conf` e comente:
```conf
# CONFIG_ZMK_DISPLAY=y
```

## 📚 Documentação

- **Completa**: Veja `README_CORNE.md`
- **ZMK Docs**: https://zmk.dev/docs
- **Keycodes**: https://zmk.dev/docs/codes

## 🆘 Problemas?

- **nice!nano não aparece?** → Pressione RESET **2x rapidamente**
- **Erro após flash?** → É normal! Funciona mesmo assim
- **Teclas não funcionam?** → Verifique se flashou ambos os lados

---

**Boa sorte!** 🎉

