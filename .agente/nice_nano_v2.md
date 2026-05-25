# Hardware e Especificações: nice!nano v2

O **nice!nano v2** é um microcontrolador projetado para ser um substituto direto (*drop-in replacement*) do Pro Micro, com foco em conectividade sem fio (Bluetooth Low Energy) e alta eficiência energética. Ele utiliza o chip Nordic nRF52840 e inclui um circuito de gerenciamento de carga de bateria Li-Po integrado.

---

## ⚡ Especificações Técnicas Principais

* **Microcontrolador:** Nordic nRF52840 (Processador de 32 bits ARM Cortex-M4F rodando a 64 MHz).
* **Memória:** 1 MB de Flash e 256 KB de RAM.
* **Conectividade:** Bluetooth Low Energy 5.0 (BLE) com antena integrada na placa.
* **Alimentação:** Conector USB-C integrado para dados e carregamento de bateria.
* **Gerenciador de Carga:** Chip BQ24072 da Texas Instruments.
* **Tensão de Operação (Lógica):** 3.3V.
* **Corrente de Corte de Energia Externa:** Pino de controle `P0.13` para cortar a energia do pino VCC.
* **Dimensões:** Compatível com a pinagem e o formato físico do Arduino Pro Micro de 24 pinos.

---

## 📌 Tabela de Pinagem e Mapeamento GPIO

Como o nice!nano v2 segue a pinagem física do Pro Micro, ele mapeia as portas nativas do chip nRF52840 (identificadas como `P0.xx` e `P1.xx`) para os nomes serigrafados tradicionais do Pro Micro.

No ZMK Firmware, você pode se referir a estes pinos utilizando as macros de compatibilidade do Pro Micro ou os endereços físicos dos controladores GPIO `&gpio0` (para a porta P0) e `&gpio1` (para a porta P1).

| Pino Pro Micro | GPIO nRF52840 | Tipo de Pino / Funções Possíveis | Descrição / Uso Recomendado |
| :--- | :--- | :--- | :--- |
| **RAW** | VBUS | Entrada de Alimentação USB | Entrada direta de ~5V do USB. |
| **VCC** | 3.3V Out | Saída de Tensão Regulada | Alimentação controlada via software (pino `P0.13`). |
| **GND** | GND | Terra | Terra comum do circuito. |
| **RST** | Reset (P0.18)| Reset do Hardware | Curto-circuitar com GND para resetar ou duplo clique para UF2. |
| **TX0 (D1)** | `P0.08` | GPIO / UART TX | default UART TX. |
| **RX1 (D0)** | `P0.06` | GPIO / UART RX | default UART RX. |
| **GND** | GND | Terra | Terra comum do circuito. |
| **GND** | GND | Terra | Terra comum do circuito. |
| **D2** | `P0.17` | GPIO / I2C SDA / SPI MOSI | Usado frequentemente para displays (MOSI) ou I2C (SDA). |
| **D3** | `P0.20` | GPIO / I2C SCL / SPI SCK | Usado frequentemente para displays (SCK) ou I2C (SCL). |
| **D4** | `P0.22` | GPIO | Entrada/Saída digital de uso geral. |
| **D5** | `P0.24` | GPIO | Entrada/Saída digital de uso geral. |
| **D6** | `P1.00` | GPIO | Entrada/Saída digital de uso geral (Porta 1). |
| **D7** | `P0.11` | GPIO | Entrada/Saída digital de uso geral. |
| **D8** | `P0.10` | GPIO | Entrada/Saída digital de uso geral. |
| **D9** | `P0.09` | GPIO | Entrada/Saída digital de uso geral. |
| **D10** | `P0.31` | GPIO | Entrada/Saída digital de uso geral. |
| **A0 (D14)** | `P0.02` | GPIO / ADC | Entrada Analógica ou digital de uso geral. |
| **A1 (D15)** | `P0.29` | GPIO / ADC | Entrada Analógica ou digital de uso geral. |
| **A2 (D18)** | `P0.04` | GPIO / ADC (AIN2) | **Nota Importante:** Reservado na v1 para divisor de tensão. |
| **A3 (D19)** | `P0.05` | GPIO / ADC (AIN5) | Entrada Analógica ou digital de uso geral. |

### 🔒 Pinos Especiais / Reservados do Sistema

Há pinos nativos do nRF52840 que não são expostos nas laterais no layout Pro Micro ou possuem funções fixas internas na placa:

* **`P0.04` (AIN2):** Conectado ao divisor de tensão de medição de bateria no nice!nano v1. No v2, a medição é feita de forma interna pelo pino `VDDH`, mas evite utilizar `P0.04` para outras funções analógicas se desejar compatibilidade.
* **`P0.13`:** Pino de controle de energia externa (*External Power Switch*). Quando definido como `HIGH` (alto) no ZMK, ele desliga a alimentação do pino **VCC** (cortando energia de LEDs RGB, displays e outros periféricos).
* **`P0.15`:** Conectado diretamente ao **LED Azul** onboard da placa (LED de status programável).
* **`P0.18`:** Pino físico de **Reset** (conectado ao pad RST).
* **`P0.00` e `P0.01`:** Reservados internamente para o cristal oscilador de 32.768 kHz, garantindo clock de alta precisão necessário para o rádio Bluetooth e baixo consumo em modo de suspensão.

---

## 💡 LEDs Indicadores Onboard

O nice!nano v2 possui dois LEDs integrados na parte superior:

1. **LED Laranja (Carregamento):**
   * **Aceso:** Indica que há alimentação USB conectada e a bateria Li-Po está sendo ativamente carregada.
   * **Apagado:** Indica que a bateria está totalmente carregada ou que nenhuma bateria está conectada (ou o switch de energia está em OFF).
2. **LED Azul (Status/Programação):**
   * Conectado ao pino `P0.15`.
   * Pisca lentamente quando a placa entra no modo bootloader UF2 ("drive NICENANO").
   * Pode ser programado no ZMK para sinalizar status de conexão Bluetooth ou atividade.

---

## 🔋 Circuito de Carga e Gerenciamento de Bateria

O chip carregador de bateria BQ24072 gerencia a carga das células de Polímero de Lítio (Li-Po) de 3.7V conectadas aos pinos **B+** (Positivo/Fio Vermelho) e **B-** (Negativo/Fio Preto) localizados abaixo da placa.

### 🔌 Corrente de Carga Ajustável (Jumper de Boost)

* **Taxa Padrão (Default):** **100mA**. Adequado para baterias pequenas típicas de teclados split (geralmente entre 110mAh e 300mAh, como baterias 301230 ou 401230).
* **Taxa Rápida (Boost):** **500mA**. Para ativar, é necessário fazer uma ponte de solda no jumper específico de boost localizado na parte traseira da placa.

> [!CAUTION]
> **Aviso Importante de Segurança sobre o Jumper de 500mA:**
> * **NUNCA** ative o jumper de 500mA se estiver usando baterias com capacidade inferior a **500mAh**.
> * A taxa de carregamento padrão recomendada para baterias Li-Po é de **0.25C a 0.5C** (ex: carregar uma bateria de 110mAh a no máximo 55mA a 110mA). Carregar baterias de baixa capacidade a 500mA causará superaquecimento, inchamento da célula, degradação rápida e **risco iminente de incêndio ou explosão**.
> * Capacidade máxima recomendada de bateria no nice!nano é de **2000mAh** devido a limites de tempo limite de segurança do carregador IC.

---

## ⚠️ AVISOS CRÍTICOS DE SEGURANÇA

### 1. Inversão de Polaridade da Bateria (Sem Proteção Reversa)

O nice!nano v2 **NÃO possui circuito de proteção contra polaridade reversa**. Conectar o positivo e o negativo de forma invertida danificará instantaneamente o chip carregador BQ24072 de maneira irreversível (o controlador não irá mais carregar baterias, e pode apresentar superaquecimento ao ser conectado ao USB).

* **Não há padrão na indústria:** Baterias compradas de fornecedores genéricos com conectores JST-PH podem vir com os fios vermelho e preto invertidos em relação ao conector soldado em sua placa.
* **Procedimento Obrigatório de Verificação:**
  1. Use um multímetro para medir os polos da bateria diretamente no conector.
  2. Identifique os polos positivo e negativo no seu PCB ou nos pads do nice!nano.
  3. Se a polaridade estiver incorreta, **NÃO insira o conector**.
  4. Use uma ferramenta fina (como uma agulha ou chave de fenda de precisão) para levantar a trava plástica da carcaça JST da bateria, retire os terminais de metal e inverta a posição dos fios para corrigir a polaridade.

### 2. Proibição Absoluta do Uso de Cabo TRRS em Teclados Split Wireless

Em teclados split tradicionais com fio (como o Corne, Lily58, Sofle), usa-se um cabo de áudio TRRS (P2 de 4 polos) para interligar as duas metades para troca de dados e energia (VCC, GND, duas linhas de dados).

> [!WARNING]
> * **NUNCA** conecte um cabo TRRS entre as duas metades quando estiver utilizando controladores **nice!nano**.
> * O ato de conectar ou desconectar um cabo TRRS com a placa energizada causa curto-circuito temporário entre os polos devido ao design físico do plugue (as pontas metálicas encostam em múltiplos contatos durante a inserção).
> * Isso causará a queima imediata das portas GPIO expostas no conector TRRS ou até mesmo da controladora inteira.
> * No nice!nano, as duas metades devem se comunicar **exclusivamente via Bluetooth (BLE)** de forma sem fio.
> * Cada metade deve possuir sua própria bateria independente soldada nos pads `B+` e `B-`.
