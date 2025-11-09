# Guia de Configuração de Teclas - nice!nano

## ⭐ Método Mais Fácil: KeymapEditor (Recomendado para Iniciantes)

O **KeymapEditor** é a forma mais simples e visual de configurar seu teclado ZMK, especialmente recomendado para quem está começando.

### Vantagens:
- ✅ Interface gráfica visual (GUI)
- ✅ Sem limitações de funcionalidades
- ✅ Aprenda enquanto configura
- ✅ Acesso a todas as funções avançadas (tap dance, behaviors, layers, combos, macros, etc.)
- ✅ Salva automaticamente no GitHub
- ✅ Compila automaticamente via GitHub Actions

### Como usar:

1. **Fork um repositório ZMK** (ex: https://github.com/tupinikeebs/sofle-zmk_oled para Sofle)
2. **Acesse o KeymapEditor** (https://keymap-editor.com ou similar)
3. **Faça login com sua conta GitHub**
4. **Vincule o fork do repositório** que você criou
5. **Configure seu keymap visualmente** arrastando e configurando teclas
6. **Clique em "Save"** no canto superior esquerdo
7. As alterações serão enviadas automaticamente para o GitHub
8. Uma pipeline será acionada para compilar o projeto
9. Após o build, um artefato chamado **`firmware.zip`** ficará disponível para download nos GitHub Actions

**Ideal para:** Iniciantes, configuração visual, aprendizado progressivo

---

## Opção 1: ZMK Firmware (Configuração Manual)

O ZMK é o firmware mais recomendado para teclados sem fio com nice!nano.

### Passo 1: Criar Repositório de Configuração no GitHub

1. Acesse https://github.com/new
2. Crie um novo repositório chamado `zmk-config`
3. Pode ser público ou privado
4. **Não adicione** arquivos iniciais (README, .gitignore, etc.)

### Passo 2: Configurar o Ambiente

Execute no terminal (Linux/Mac) ou Git Bash (Windows):

```bash
bash -c "$(curl -fsSL https://zmk.dev/setup.sh)"
```

Durante a configuração:
- Selecione seu modelo de teclado
- Escolha `nice!nano` como microcontrolador
- Quando perguntado sobre copiar o mapa de teclas padrão, responda **"yes"**
- Forneça seu nome de usuário do GitHub
- Informe o nome do repositório: `zmk-config`

### Passo 3: Personalizar o Mapeamento de Teclas

1. Navegue até o diretório `zmk-config` criado
2. Localize o arquivo de keymap (geralmente em):
   ```
   config/boards/shields/seu_teclado/keymap.keymap
   ```
3. Edite o arquivo `keymap.keymap` para definir suas teclas

#### Exemplo de estrutura do keymap:

```dts
#include <behaviors.dtsi>
#include <dt-bindings/zmk/keys.h>

/ {
    keymap {
        compatible = "zmk,keymap";

        default_layer {
            bindings = <
                &kp Q &kp W &kp E &kp R &kp T
                &kp Y &kp U &kp I &kp O &kp P
                // ... mais teclas
            >;
        };
    };
};
```

#### Códigos de teclas comuns:
- `&kp A` = tecla A
- `&kp SPACE` = barra de espaço
- `&kp ENTER` = Enter
- `&kp LSHIFT` = Shift esquerdo
- `&kp TAB` = Tab
- `&mo 1` = ativa layer 1 (quando pressionado)
- `&tog 1` = alterna layer 1 (liga/desliga)

### Passo 4: Compilar o Firmware

Execute o comando de build:

```bash
west build -p -b nice_nano_v2 -- -DSHIELD="seu_teclado"
```

Substitua `"seu_teclado"` pelo nome do shield do seu teclado.

### Passo 5: Flashear no nice!nano

1. Conecte o nice!nano ao computador via USB-C
2. Pressione o botão RESET **duas vezes rapidamente** (modo bootloader)
3. O nice!nano aparecerá como um drive USB chamado **"NICENANO"**
4. Localize o arquivo `.uf2` compilado (geralmente em `build/zephyr/`)
5. **Arraste e solte** o arquivo `.uf2` para o drive "NICENANO"
6. O firmware será instalado automaticamente

**⚠️ Para teclados split (como Sofle, Corne, Lily58, etc.):**
- Você precisará de **dois arquivos**: `LEFT.uf2` e `RIGHT.uf2`
- Copie o **LEFT.uf2** para o nice!nano do lado esquerdo
- Copie o **RIGHT.uf2** para o nice!nano do lado direito
- **Nunca é preciso apagar** arquivos dentro do NICENANO, apenas copie o novo sobre o anterior

### Passo 6: Testar

Após o flash, o teclado deve funcionar com o novo mapeamento de teclas.

---

## Opção 2: BlueMicro Firmware (Alternativa)

O BlueMicro é baseado em Arduino e pode ser mais familiar para alguns usuários.

### Configuração Básica:

1. Instale o Arduino IDE
2. Adicione o repositório do BlueMicro nas preferências do Arduino
3. Instale as bibliotecas necessárias
4. Configure o keymap no código Arduino
5. Compile e faça upload via USB

**Nota:** O BlueMicro requer mais conhecimento técnico e não é tão otimizado para wireless quanto o ZMK.

---

## Recursos Úteis

- **Documentação ZMK**: https://zmk.dev/docs
- **Documentação nice!nano**: https://nicekeyboards.com/docs/nice-nano
- **ZMK Keycodes**: https://zmk.dev/docs/codes
- **ZMK Behaviors**: https://zmk.dev/docs/behaviors

---

## Dicas Importantes

1. **Sempre faça backup** do firmware atual antes de atualizar
2. **Teste o keymap** antes de soldar tudo definitivamente
3. **Use soquetes** para facilitar atualizações futuras
4. O ZMK suporta **layers** (camadas) para funções extras
5. Você pode configurar **combinações de teclas** (combos) no ZMK

---

## Troubleshooting

- **nice!nano não aparece como drive**: Pressione RESET duas vezes rapidamente
- **Firmware não funciona**: Verifique se compilou para o shield correto
- **Teclas não respondem**: Verifique a fiação e o keymap
- **Bateria não carrega**: Verifique a conexão da bateria e se está usando 3.7V LiPO
- **Erro após flash**: ⚠️ É **NORMAL** aparecer um erro após passar o firmware! Não é um bug, é uma feature do ZMK. O teclado deve funcionar normalmente mesmo assim.

