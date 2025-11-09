# Como Executar o Setup do ZMK no Windows

## Opção 1: Usar Git Bash (Recomendado)

Você já está usando Git Bash (MINGW64), então siga estes passos:

### Passo 1: Verificar Pré-requisitos

Antes de executar, certifique-se de ter:

1. **Git configurado** com nome e email:
   ```bash
   git config --global user.name "Seu Nome"
   git config --global user.email "seu@email.com"
   ```

2. **Curl instalado** (já vem com Git Bash)

### Passo 2: Executar o Script

No Git Bash, execute:

```bash
bash -c "$(curl -fsSL https://zmk.dev/setup.sh)"
```

### Passo 3: Seguir as Instruções Interativas

O script irá perguntar:

1. **Selecione seu teclado** da lista (use as setas e Enter)
   - Se seu teclado não estiver na lista, escolha um similar ou "Quit" para criar manualmente

2. **Selecione o MCU Board**:
   - Escolha **"nice!nano v2"** (ou "nice!nano v1" se for a versão antiga)

3. **Copiar keymap padrão?**:
   - Digite **"Y"** ou **"y"** para copiar o keymap padrão (recomendado)

4. **GitHub Username**:
   - Digite seu nome de usuário do GitHub (ou deixe vazio para pular)
   - Se informar, será solicitado o nome do repositório (padrão: `zmk-config`)

5. **Confirmar**:
   - Digite **"Y"** para continuar

### Passo 4: Aguardar a Configuração

O script irá:
- Clonar o template do ZMK
- Baixar os arquivos de configuração do seu teclado
- Criar a estrutura de pastas
- Inicializar um repositório Git local
- (Opcional) Fazer push para o GitHub

---

## Opção 2: Baixar e Executar Manualmente

Se o método acima não funcionar:

### Passo 1: Baixar o Script

No Git Bash:
```bash
curl -fsSL https://zmk.dev/setup.sh -o setup_zmk.sh
```

### Passo 2: Dar Permissão de Execução

```bash
chmod +x setup_zmk.sh
```

### Passo 3: Executar

```bash
bash setup_zmk.sh
```

---

## Opção 3: Usar PowerShell (Alternativa)

Se preferir usar PowerShell:

```powershell
Invoke-WebRequest -Uri https://zmk.dev/setup.sh -OutFile setup_zmk.sh
bash setup_zmk.sh
```

---

## Após a Configuração

Depois que o script terminar, você terá:

1. Uma pasta `zmk-config` (ou o nome que você escolheu)
2. Arquivos de configuração dentro de `config/`
3. Um arquivo `build.yaml` com as configurações do build

### Próximos Passos:

1. **Editar o keymap**:
   - Navegue até `config/boards/shields/seu_teclado/keymap.keymap`
   - Ou `config/boards/shields/seu_teclado/seu_teclado.keymap`

2. **Personalizar as teclas** conforme necessário

3. **Compilar o firmware** (via GitHub Actions ou localmente)

---

## Troubleshooting

### Erro: "git is not installed"
- Instale o Git: https://git-scm.com/download/win

### Erro: "Git username not set"
- Execute:
  ```bash
  git config --global user.name "Seu Nome"
  git config --global user.email "seu@email.com"
  ```

### Erro: "curl is not installed"
- No Git Bash, curl já deve estar disponível
- Se não estiver, reinstale o Git for Windows

### Script não executa
- Certifique-se de estar no Git Bash, não no PowerShell ou CMD
- Verifique se tem permissões de escrita no diretório atual

---

## Dica Importante

Se você ainda não criou o repositório no GitHub:
1. Acesse https://github.com/new
2. Crie um repositório chamado `zmk-config` (pode ser público ou privado)
3. **NÃO** adicione README, .gitignore ou licença
4. Depois execute o script e informe seu username quando solicitado

