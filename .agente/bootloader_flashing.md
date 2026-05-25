# Gravação de Firmware e Resolução de Problemas

O **nice!nano v2** vem de fábrica com o bootloader **UF2** da Adafruit, o que permite o upload de novos firmwares de maneira extremamente simples, sem necessidade de ferramentas de gravação dedicadas (como programadores de hardware) no dia a dia. A placa se comporta como um pen drive comum quando colocada no modo bootloader.

---

## 🚀 Como Entrar no Modo Bootloader

Para gravar novos arquivos `.uf2` gerados a partir do ZMK Firmware, você precisa colocar o microcontrolador em modo de gravação:

### ◽ Método 1: Duplo Clique no Botão de Reset
1. Conecte o nice!nano ao computador através de um cabo USB-C.
2. Pressione rapidamente o **botão de Reset físico** duas vezes seguidas (intervalo inferior a 0.5s).

### ◽ Método 2: Curto nos Pinos RST e GND (Tweezers Method)
Se o seu teclado Corne não tiver um botão físico de reset soldado ou se ele estiver inacessível abaixo da carcaça:
1. Conecte o cabo USB-C.
2. Usando uma pinça metálica, clipe de papel ou um fio condutor, feche um curto-circuito rápido entre o pino **RST** e o pino **GND** na lateral da placa **duas vezes seguidas**.

### ◽ Sinais de Sucesso
* Um novo dispositivo de armazenamento USB aparecerá no seu sistema operacional com o nome **`NICENANO`**.
* O **LED Azul** onboard da controladora começará a piscar lentamente (pulsar), indicando que está aguardando o arquivo de firmware.

---

## 💾 Gravando o Firmware (`.uf2`)

1. Localize o arquivo de firmware `.uf2` compilado para a sua metade correspondente do teclado (ex: `corne_left-nice_nano_v2-zmk.uf2`).
2. Copie ou arraste e solte o arquivo diretamente para dentro do drive **`NICENANO`**.
3. O processo de gravação levará cerca de 5 a 10 segundos.
4. **Reinicialização Automática:** Assim que a gravação for concluída, o nice!nano ejetará o drive automaticamente, apagará o LED azul intermitente e reiniciará rodando o ZMK Firmware recém-gravado.

---

## 🛠️ Resolução de Problemas Comuns (Troubleshooting)

### ❌ 1. O drive `NICENANO` não aparece após o duplo clique
* **Cabo USB Apenas de Carga:** Este é o erro mais comum. Muitos cabos USB-C baratos (especialmente os que acompanham powerbanks ou carregadores simples) possuem apenas os fios internos de energia e não possuem os pinos de dados (D+/D-). **Teste com outro cabo de dados USB-C de qualidade** (como os que acompanham celulares ou de dados externos).
* **Conexão USB instável ou portas frontais:** Tente plugar diretamente na porta USB traseira da placa-mãe do computador ou evite hubs USB não alimentados.
* **Intervalo de Duplo Clique Incorreto:** Tente clicar o reset mais rápido ou um pouco mais devagar. O timing precisa ser preciso para que o bootloader detecte a ação.

### ❌ 2. O drive ejeta, mas a controladora volta ao modo bootloader
Se o drive `NICENANO` voltar a aparecer imediatamente após você arrastar o arquivo `.uf2`:
* **Firmware Inválido:** A gravação falhou porque o arquivo enviado não foi gerado especificamente para o nice!nano v2 ou está corrompido. Certifique-se de que o target de compilação no ZMK está como `nice_nano_v2` e não outro microcontrolador (como RP2040 ou Pro Micro baseado em ATmega32U4).

### ❌ 3. O teclado não responde e nenhuma tecla funciona após flash
* **Troca de Metades:** Garanta que você gravou o firmware do lado esquerdo (left) no nice!nano da esquerda, e o do lado direito (right) no nice!nano da direita. Como neste repositório as duas metades funcionam de maneira independente (`CONFIG_ZMK_SPLIT=n`), se você inverter os firmwares, a matriz não funcionará corretamente devido ao mapeamento de colunas invertido.

---

## ⚡ Recuperação Avançada (Bootloader Corrompido)

Caso o controlador tenha travado de forma severa, não responda ao USB e não entre no modo bootloader por duplo clique sob nenhuma circunstância, é possível que o bootloader UF2 tenha sido corrompido.

Neste caso, você precisará de um programador de hardware externo compatível com o protocolo SWD (como um **J-Link**, **ST-Link v2** ou até mesmo uma **Raspberry Pi**):

### ◽ Conexões SWD (Pads na Traseira do nice!nano)
Na parte inferior do nice!nano, existem pequenos pads de teste redondos dourados. As conexões necessárias para regravação são:
* **VDD (3.3V)** — Alimentação lógica.
* **GND** — Terra comum.
* **SWDIO** — Entrada/Saída de dados de depuração.
* **SWCLK** — Clock de depuração.

### ◽ Comandos de Regravação com OpenOCD
Utilizando o programador ST-Link v2 e a ferramenta OpenOCD:

```bash
openocd -f interface/stlink.cfg -f target/nrf52.cfg -c "init; halt; nrf52 mass_erase; program adafruit-nrf52840-bootloader-nice_nano.hex verify reset; shutdown"
```
*(Nota: O arquivo `.hex` do bootloader original do nice!nano pode ser obtido diretamente no repositório da [Adafruit nRF52 Bootloader](https://github.com/adafruit/Adafruit_nRF52_Bootloader)).*
