# Layer 6: Macros de Desenvolvimento - Documentação Completa

## Visão Geral

A Layer 6 é dedicada exclusivamente a macros de desenvolvimento, organizadas por categoria para facilitar o acesso durante o trabalho de programação.

**Acesso:** Toggle na Layer 4 (F12) ou diretamente via `&tog 6`

**Total de Macros:** 36 macros ativas

---

## Layout Visual

```
┌─────────── React ───────────┐ ┌──────── JS/TS ─────────┐
│ useState  │ useEffect │ export_const │ export_fn │ useMemo │ useCallback │
│ async_fn  │ try_catch │ arrow_fn     │ return    │ ifBlock │ ternary     │
└──────────────────────────────┘ └────────────────────────┘

┌─────────── Git ─────────────┐ ┌──────── Docker ────────┐
│ git_status │ git_commit │ git_add_all │ git_push │ git_pull │ git_checkout_b │
│ dc_up      │ dc_down    │ dc_build    │ dc_logs  │ docker_ps│ docker_exec    │
└──────────────────────────────┘ └────────────────────────┘

┌────────── Terminal ─────────┐ ┌─────── Utilidades ─────┐
│ pnpm_dev │ pnpm_build │ pnpm_test │ npm_dev │ npm_build │ clear │
│ cons_log │ todo       │ comment_blk│ fixme   │ console_err│ throw_err│
└──────────────────────────────┘ └────────────────────────┘
```

---

## Macros React (Linha Superior - Esquerda)

### 1. useState
**Posição:** 0 (Q)  
**Expansão:** `const [state, setState] = useState();`  
**Uso:** Criar estado local em componentes React  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
const [count, setCount] = useState();
```

### 2. useEffect
**Posição:** 1 (W)  
**Expansão:** `useEffect(() => {}, []);`  
**Uso:** Side effects e lifecycle em componentes React  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
useEffect(() => {
  // seu código aqui
}, []);
```

### 3. export_const
**Posição:** 2 (E)  
**Expansão:** `export const Component = () => {}`  
**Uso:** Criar componentes React funcionais modernos  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
export const Button = () => {
  return <button>Click me</button>;
};
```

### 4. export_fn
**Posição:** 3 (R)  
**Expansão:** `export default function Component() {}`  
**Uso:** Criar componentes React com export default  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
export default function App() {
  return <div>Hello</div>;
}
```

### 5. useMemo
**Posição:** 4 (T)  
**Expansão:** `useMemo(() => {}, []);`  
**Uso:** Otimização de valores computados  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
const memoizedValue = useMemo(() => {
  return expensiveCalculation();
}, [deps]);
```

### 6. useCallback
**Posição:** 5 (Y)  
**Expansão:** `useCallback(() => {}, []);`  
**Uso:** Otimização de callbacks  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

---

## Macros JavaScript/TypeScript (Linha Superior - Direita)

### 7. async_fn
**Posição:** 6 (U)  
**Expansão:** `async () => {}`  
**Uso:** Funções assíncronas  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
const fetchData = async () => {
  const response = await fetch(url);
};
```

### 8. try_catch
**Posição:** 7 (I)  
**Expansão:** `try {} catch (e) {}`  
**Uso:** Tratamento de erros  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
try {
  riskyOperation();
} catch (e) {
  console.error(e);
}
```

### 9. arrow_fn
**Posição:** 8 (O)  
**Expansão:** `() => {}`  
**Uso:** Arrow functions  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
const handleClick = () => {
  console.log('clicked');
};
```

### 10. return_macro
**Posição:** 9 (P)  
**Expansão:** `return`  
**Uso:** Retorno em funções  
**Exemplo de uso:**
```javascript
function calculate() {
  return 42;
}
```

### 11. ifBlock
**Posição:** 10 (Backspace)  
**Expansão:** `if () {}`  
**Uso:** Estruturas condicionais  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
if (condition) {
  // código
}
```

### 12. ternary
**Posição:** 11 (Backspace direito)  
**Expansão:** `condition ? true : false`  
**Uso:** Operador ternário  
**Exemplo de uso:**
```javascript
const result = condition ? true : false;
```

---

## Macros Git (Linha do Meio - Esquerda)

### 13. git_status
**Posição:** 12 (A)  
**Expansão:** `git status` + Enter  
**Uso:** Verificar status do repositório  
**Quando usar:** Antes de commits, para ver mudanças

### 14. git_commit
**Posição:** 13 (S)  
**Expansão:** `git commit -m ""` (cursor entre aspas)  
**Uso:** Criar commit com mensagem  
**Quando usar:** Após fazer `git add`, para commitar mudanças

### 15. git_add_all
**Posição:** 14 (D)  
**Expansão:** `git add .` + Enter  
**Uso:** Adicionar todos os arquivos ao stage  
**Quando usar:** Antes de commitar, para preparar mudanças

### 16. git_push
**Posição:** 15 (F)  
**Expansão:** `git push` + Enter  
**Uso:** Enviar commits para o repositório remoto  
**Quando usar:** Após commitar, para sincronizar com remoto

### 17. git_pull
**Posição:** 16 (G)  
**Expansão:** `git pull` + Enter  
**Uso:** Atualizar repositório local  
**Quando usar:** Para obter mudanças do remoto

### 18. git_checkout_b
**Posição:** 17 (H)  
**Expansão:** `git checkout -b ` (cursor após espaço)  
**Uso:** Criar e mudar para nova branch  
**Quando usar:** Para iniciar nova feature/fix

---

## Macros Docker (Linha do Meio - Direita)

### 19. dc_up
**Posição:** 18 (J)  
**Expansão:** `docker compose up -d` + Enter  
**Uso:** Subir serviços em background  
**Quando usar:** Para iniciar ambiente de desenvolvimento

### 20. dc_down
**Posição:** 19 (K)  
**Expansão:** `docker compose down` + Enter  
**Uso:** Parar e remover containers  
**Quando usar:** Para parar serviços Docker

### 21. dc_build
**Posição:** 20 (L)  
**Expansão:** `docker compose build` + Enter  
**Uso:** Construir imagens Docker  
**Quando usar:** Após mudanças no Dockerfile

### 22. dc_logs
**Posição:** 21 (;)  
**Expansão:** `docker compose logs -f` + Enter  
**Uso:** Ver logs em tempo real  
**Quando usar:** Para debugar serviços Docker

### 23. docker_ps
**Posição:** 22 (')  
**Expansão:** `docker ps` + Enter  
**Uso:** Listar containers em execução  
**Quando usar:** Para verificar status dos containers

### 24. docker_exec
**Posição:** 23 (Enter esquerdo)  
**Expansão:** `docker exec -it ` (cursor após espaço)  
**Uso:** Acessar container interativamente  
**Quando usar:** Para executar comandos dentro do container

---

## Macros Terminal / Package Managers (Linha Inferior - Esquerda)

### 25. pnpm_dev
**Posição:** 24 (Z)  
**Expansão:** `pnpm dev` + Enter  
**Uso:** Iniciar servidor de desenvolvimento  
**Quando usar:** Para rodar projeto em modo desenvolvimento

### 26. pnpm_build
**Posição:** 25 (X)  
**Expansão:** `pnpm build` + Enter  
**Uso:** Compilar projeto para produção  
**Quando usar:** Para gerar build de produção

### 27. pnpm_test
**Posição:** 26 (C)  
**Expansão:** `pnpm test` + Enter  
**Uso:** Executar testes  
**Quando usar:** Para rodar suite de testes

### 28. npm_dev
**Posição:** 27 (V)  
**Expansão:** `npm run dev` + Enter  
**Uso:** Iniciar servidor de desenvolvimento (npm)  
**Quando usar:** Projetos que usam npm ao invés de pnpm

### 29. npm_build
**Posição:** 28 (B)  
**Expansão:** `npm run build` + Enter  
**Uso:** Compilar projeto (npm)  
**Quando usar:** Build com npm

### 30. clear_term
**Posição:** 29 (N)  
**Expansão:** `clear` + Enter  
**Uso:** Limpar terminal  
**Quando usar:** Para limpar a tela do terminal

---

## Macros Utilidades / Debug (Linha Inferior - Direita)

### 31. cons_log
**Posição:** 30 (M)  
**Expansão:** `console.log()`  
**Uso:** Debug rápido  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
console.log(variable);
```

### 32. todo_macro
**Posição:** 31 (,)  
**Expansão:** `// TODO: ` (cursor após dois pontos)  
**Uso:** Adicionar comentário TODO  
**Exemplo de uso:**
```javascript
// TODO: Implementar validação
```

### 33. comment_blk
**Posição:** 32 (.)  
**Expansão:** `/*  */` (cursor no meio)  
**Uso:** Comentários de bloco  
**Exemplo de uso:**
```javascript
/* 
 * Comentário de bloco
 * Múltiplas linhas
 */
```

### 34. fixme_macro
**Posição:** 33 (/)  
**Expansão:** `// FIXME: ` (cursor após dois pontos)  
**Uso:** Marcar código que precisa ser corrigido  
**Exemplo de uso:**
```javascript
// FIXME: Corrigir bug de timezone
```

### 35. console_err
**Posição:** 34 (Shift direito)  
**Expansão:** `console.error()`  
**Uso:** Log de erros  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
console.error('Erro:', error);
```

### 36. throw_err
**Posição:** 35 (Esc direito)  
**Expansão:** `throw new Error();`  
**Uso:** Lançar erros  
**Exemplo de uso:**
```javascript
// Pressione a macro e edite:
throw new Error('Mensagem de erro');
```

---

## Fluxo de Trabalho Sugerido

### Desenvolvimento React
1. `export_const` ou `export_fn` - Criar componente
2. `useState` - Adicionar estado
3. `useEffect` - Adicionar side effects
4. `useMemo` / `useCallback` - Otimizar se necessário

### Git Workflow
1. `git_status` - Verificar mudanças
2. `git_add_all` - Adicionar arquivos
3. `git_commit` - Commitar (editar mensagem)
4. `git_push` - Enviar para remoto

### Docker Workflow
1. `dc_build` - Construir imagens
2. `dc_up` - Subir serviços
3. `dc_logs` - Ver logs se necessário
4. `dc_down` - Parar quando terminar

### Debug
1. `cons_log` - Adicionar logs
2. `todo_macro` - Marcar pendências
3. `comment_blk` - Documentar código
4. `fixme_macro` - Marcar problemas

---

## Dicas de Uso

### 1. Macros com Cursor Posicionado
Algumas macros posicionam o cursor em locais estratégicos:
- `git_commit`: Cursor entre aspas para mensagem
- `git_checkout_b`: Cursor após espaço para nome da branch
- `docker_exec`: Cursor após espaço para nome do container
- `todo_macro` / `fixme_macro`: Cursor após dois pontos

### 2. Macros com Enter
Macros de terminal incluem Enter automaticamente:
- Git: `git_status`, `git_add_all`, `git_push`, `git_pull`
- Docker: `dc_up`, `dc_down`, `dc_build`, `dc_logs`, `docker_ps`
- Terminal: `pnpm_dev`, `pnpm_build`, `pnpm_test`, `npm_dev`, `npm_build`, `clear_term`

### 3. Edição Após Macro
A maioria das macros deixa o código pronto para edição:
- React hooks: Edite variáveis e dependências
- Funções: Adicione parâmetros e corpo
- Condicionais: Adicione condições

### 4. Combinações Úteis
- `export_const` + `useState` = Componente com estado
- `async_fn` + `try_catch` = Função assíncrona com tratamento de erro
- `git_add_all` + `git_commit` = Workflow rápido de commit

---

## Adicionando Novas Macros

Para adicionar novas macros à Layer 6:

1. **Defina a macro** na seção `macros` do keymap
2. **Adicione à Layer 6** substituindo um `&trans` ou reorganizando
3. **Documente** neste arquivo

Exemplo:
```c
// Nova macro na seção macros
my_macro: my_macro {
    compatible = "zmk,behavior-macro";
    label = "MY_MACRO";
    #binding-cells = <0>;
    wait-ms = <10>;
    tap-ms = <10>;
    bindings = <&kp M &kp Y &kp SPACE &kp M &kp A &kp C &kp R &kp O>;
};

// Adicionar na Layer 6
&my_macro  // substitui &trans em alguma posição
```

---

## Referências

- [Documentação ZMK - Macros](https://zmk.dev/docs/behaviors/macros)
- [Keycodes ZMK](https://zmk.dev/docs/codes)

---

*Última atualização: Janeiro 2025*

