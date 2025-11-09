# 🔨 Guias de Compilação ZMK - Todas as Opções

Existem várias formas de compilar o firmware ZMK para seu Corne. Aqui estão todas as opções:

---

## 1. GitHub Actions (Mais Fácil) ⭐ RECOMENDADO

### Vantagens:
- ✅ Não precisa instalar nada no seu computador
- ✅ Funciona em qualquer sistema operacional
- ✅ Compilação automática quando você faz push
- ✅ Gratuito e ilimitado para repositórios públicos

### Como usar:
1. Crie um repositório no GitHub
2. Faça push dos arquivos
3. Ative GitHub Actions
4. Baixe o firmware compilado

**Detalhes completos:** Veja `INICIO_RAPIDO.md`

---

## 2. Compilação Local (Mais Controle)

### Vantagens:
- ✅ Compilação mais rápida (após setup inicial)
- ✅ Não depende de internet
- ✅ Mais controle sobre o processo
- ✅ Pode debugar melhor

### Desvantagens:
- ❌ Requer instalação de ferramentas
- ❌ Mais complexo de configurar
- ❌ Depende do sistema operacional

### Pré-requisitos:

#### Windows:
1. **WSL2 (Windows Subsystem for Linux)** - Recomendado
   - Instale WSL2: `wsl --install`
   - Ou use Git Bash (mais limitado)

2. **Ferramentas necessárias:**
   - Python 3.8+
   - Git
   - West (ferramenta de build do Zephyr)
   - Toolchain ARM (gcc-arm-none-eabi)

#### Linux/Mac:
- Python 3.8+
- Git
- West
- Toolchain ARM

### Instalação Local (Passo a Passo):

#### Passo 1: Instalar West

```bash
pip3 install west
```

#### Passo 2: Clonar ZMK

```bash
west init -l https://github.com/zmkfirmware/zmk-config-split-template
cd zmk-config-split-template
west update
```

#### Passo 3: Copiar sua configuração

```bash
# Copie seus arquivos config/ para o diretório do ZMK
cp -r /caminho/para/sua/config/* config/
```

#### Passo 4: Compilar

```bash
# Para o lado esquerdo
west build -p -b nice_nano_v2 -- -DSHIELD=corne_left

# Para o lado direito
west build -p -b nice_nano_v2 -- -DSHIELD=corne_right
```

#### Passo 5: Encontrar o firmware

Os arquivos `.uf2` estarão em:
```
build/zephyr/zmk.uf2
```

Renomeie para `corne_left.uf2` e `corne_right.uf2` conforme necessário.

---

## 3. Docker (Alternativa Fácil para Local)

### Vantagens:
- ✅ Não precisa instalar todas as ferramentas
- ✅ Funciona igual em qualquer sistema
- ✅ Isolado do seu sistema

### Como usar:

#### Passo 1: Instalar Docker
- Windows: https://www.docker.com/products/docker-desktop
- Linux: `sudo apt install docker.io`
- Mac: https://www.docker.com/products/docker-desktop

#### Passo 2: Usar container ZMK

```bash
# Navegue até o diretório com sua config
cd /caminho/para/sua/config

# Compile usando Docker
docker run --rm -v $PWD:/zmk-config -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  west build -p -b nice_nano_v2 -- -DSHIELD=corne_left

docker run --rm -v $PWD:/zmk-config -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  west build -p -b nice_nano_v2 -- -DSHIELD=corne_right
```

**Nota:** No Windows, use `%cd%` ao invés de `$PWD`:
```cmd
docker run --rm -v %cd%:/zmk-config -w /zmk-config zmkfirmware/zmk-build-arm:2.5 west build -p -b nice_nano_v2 -- -DSHIELD=corne_left
```

---

## 4. ZMK Studio (Beta - GUI Visual)

### Vantagens:
- ✅ Interface gráfica
- ✅ Não precisa mexer em código
- ✅ Compila automaticamente

### Desvantagens:
- ❌ Ainda em Beta
- ❌ Funcionalidades limitadas
- ❌ Não salva direto no GitHub

### Como usar:
1. Acesse: https://zmk.studio
2. Conecte seu repositório
3. Configure visualmente
4. Compile e baixe

---

## 5. KeymapEditor (Recomendado para Iniciantes)

### Vantagens:
- ✅ Interface visual completa
- ✅ Salva no GitHub automaticamente
- ✅ Compila via GitHub Actions automaticamente
- ✅ Todas as funcionalidades do ZMK

### Como usar:
1. Acesse: https://keymap-editor.com
2. Login com GitHub
3. Vincule seu repositório
4. Configure visualmente
5. Salve → Compila automaticamente!

---

## 📊 Comparação Rápida

| Método | Dificuldade | Velocidade | Requer Instalação |
|--------|-------------|------------|-------------------|
| GitHub Actions | ⭐ Fácil | 🐌 Lento (5-10 min) | ❌ Não |
| KeymapEditor | ⭐ Fácil | 🐌 Lento (5-10 min) | ❌ Não |
| Docker | ⭐⭐ Médio | 🚀 Rápido (1-2 min) | ✅ Docker |
| Local | ⭐⭐⭐ Difícil | 🚀 Rápido (1-2 min) | ✅ Muitas |
| ZMK Studio | ⭐⭐ Médio | 🚀 Rápido | ❌ Não |

---

## 🎯 Recomendação

### Para Iniciantes:
1. **GitHub Actions** ou **KeymapEditor** (mais fácil)
2. Depois que estiver confortável, tente **Docker**

### Para Avançados:
1. **Compilação Local** (mais controle)
2. **Docker** (mais fácil que local, mas ainda rápido)

---

## 🆘 Troubleshooting

### GitHub Actions não compila:
- Verifique se ativou Actions em Settings
- Verifique se o arquivo `build.yaml` está correto
- Veja os logs em Actions para erros

### Compilação local falha:
- Verifique se todas as ferramentas estão instaladas
- Tente usar Docker como alternativa
- Verifique se está no diretório correto

### Docker não funciona:
- Certifique-se de que Docker está rodando
- Verifique permissões de volume
- No Windows, use caminhos absolutos

---

## 📚 Recursos

- **Documentação ZMK**: https://zmk.dev/docs
- **ZMK GitHub**: https://github.com/zmkfirmware/zmk
- **Docker Hub ZMK**: https://hub.docker.com/r/zmkfirmware/zmk-build-arm

---

**Escolha o método que funciona melhor para você!** 🚀

