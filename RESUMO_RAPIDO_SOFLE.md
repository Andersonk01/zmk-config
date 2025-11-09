# 🚀 Resumo Rápido - Configuração Sofle com ZMK

## ⚡ Início Rápido (3 Passos)

### 1️⃣ Fork do Repositório
```
https://github.com/tupinikeebs/sofle-zmk_oled
→ Clique em "Fork"
```

### 2️⃣ Configurar Keymap
**Opção A - KeymapEditor (Recomendado):**
- Acesse: https://keymap-editor.com
- Login com GitHub
- Vincule seu fork
- Configure visualmente
- Salve → Build automático

**Opção B - Manual:**
- Edite `config/[teclado].keymap`
- Compile via GitHub Actions

### 3️⃣ Instalar Firmware
```
1. Conecte USB ao nice!nano
2. Pressione RST 2x rapidamente
3. Copie LEFT.uf2 → nice!nano esquerdo
4. Copie RIGHT.uf2 → nice!nano direito
```

---

## 📋 Checklist

- [ ] Fork do repositório feito
- [ ] Keymap configurado (KeymapEditor ou manual)
- [ ] Firmware compilado (automático ou manual)
- [ ] Firmware baixado (firmware.zip dos Actions)
- [ ] nice!nano em modo bootloader (RST 2x)
- [ ] LEFT.uf2 copiado para lado esquerdo
- [ ] RIGHT.uf2 copiado para lado direito
- [ ] Teclado testado e funcionando

---

## 🎯 Board Selecionada

**Nice!nano V2** (ou V1 se for versão antiga)

---

## ⚠️ Lembrete

Erro após flash é **NORMAL** - é uma feature do ZMK, não um bug!

---

## 📖 Documentação Completa

Veja `GUIA_SOFLE_ZMK.md` para detalhes completos.

