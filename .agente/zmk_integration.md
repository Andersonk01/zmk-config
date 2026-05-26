# Configuração e Integração com o ZMK Firmware

O ZMK Firmware possui suporte nativo ao **nice!nano** (definido como `nice_nano` ou `nice_nano_v2` dependendo da versão do ZMK). Esta documentação detalha as configurações de DeviceTree (`.overlay`, `.keymap`) e de Kconfig (`.conf`) específicas para tirar o máximo proveito do hardware, otimizando o consumo de energia da bateria.

---

## 🔋 1. Sensor de Nível de Bateria (DeviceTree)

O mapeamento da bateria varia conforme a versão do nice!nano. É essencial configurar o driver correto para evitar leituras erráticas ou travamento no envio dos relatórios de energia ao sistema operacional.

### ◽ nice!nano v2 (Recomendado)
A versão v2 mede a voltagem da bateria internamente através do pino de alta tensão (`VDDH`) do nRF52840, eliminando a necessidade de usar pinos de ADC externos ou divisores de tensão físicos na matriz.

O driver compatível no ZMK é o `zmk,battery-nrf-vddh`. Adicione a seguinte estrutura ao seu arquivo `.dts` ou `.overlay` da placa se precisar defini-lo manualmente (embora o ZMK já inclua isso por padrão ao selecionar o target do board):

```devicetree
/ {
    chosen {
        zmk,battery = &vbatt;
    };

    vbatt: vbatt {
        compatible = "zmk,battery-nrf-vddh";
        status = "okay";
    };
};
```

### ◽ nice!nano v1
A versão v1 do nice!nano utilizava um divisor de tensão de resistor físico de 2MΩ/1MΩ conectado ao pino analógico **`P0.04` (AIN2)**.

Se estiver compilando para uma placa v1 antiga, a definição de bateria deve utilizar o driver de divisor de tensão:

```devicetree
/ {
    chosen {
        zmk,battery = &vbatt;
    };

    vbatt: vbatt {
        compatible = "zmk,battery-voltage-divider";
        label = "BATTERY";
        io-channels = <&adc 2>; // canal ADC 2 mapeia para P0.04 (AIN2)
        output-ohms = <2000000>; // Resistor R2 (2M Ohm)
        full-ohms = <3000000>;   // R1 + R2 (1M + 2M Ohm)
    };
};
```

---

## 🔌 2. Controle de Energia Externa (External Power Switch)

O pino **`P0.13`** do nice!nano v2 está fisicamente conectado à linha de habilitação do regulador de tensão do pino **VCC** (que alimenta displays OLED/nice!view e LEDs RGB Underglow/Backlight).

O ZMK configura automaticamente esse pino como um nó de energia externa sob o label `&ext_power`.

### ◽ Como Habilitar no Kconfig
Para que o suporte ao gerenciamento de energia externa seja compilado no firmware, garanta a seguinte flag no seu arquivo `config/corne.conf` (ou arquivo correspondente de conf da metade):

```kconfig
CONFIG_ZMK_EXT_POWER=y
```

### ◽ Controle no Keymap (Atalhos)
Você pode adicionar comportamentos de teclado para ligar, desligar ou alternar a energia do pino VCC diretamente de uma das camadas do seu mapa de teclas:

* `&ext_power EP_TOG` — Alterna o estado da energia externa (Liga / Desliga).
* `&ext_power EP_ON` — Liga a energia externa.
* `&ext_power EP_OFF` — Desliga a energia externa (útil para economizar bateria instantaneamente se os LEDs estiverem ativos).

**Exemplo de uso no Keymap:**
```devicetree
bindings = <
    &kp TAB    &kp Q         &kp W         &ext_power EP_TOG   &kp R   &kp T
    &kp LCTRL  &bt BT_SEL 0  &bt BT_SEL 1  &ext_power EP_OFF   &kp F   &kp G
    &kp LSHFT  &kp Z         &kp X         &kp C               &kp V   &kp B
                             &kp LGUI      &to 1               &kp SPACE
>;
```

---

## ⚙️ 3. Otimizações de Bateria no Kconfig (`.conf`)

Para estender a duração da bateria (de dias para meses em teclados sem fio), aplique as seguintes flags no seu arquivo `.conf` principal:

```kconfig
# Habilitar o modo Deep Sleep (Suspensão Profunda)
CONFIG_ZMK_SLEEP=y

# Tempo limite de ociosidade antes de entrar em Deep Sleep (em milissegundos)
# Exemplo: 900.000 ms = 15 minutos
CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=900000

# Reduzir ou desligar consumo de LEDs quando ocioso
CONFIG_ZMK_RGB_UNDERGLOW_AUTO_OFF_IDLE=y
```

### ◽ Configuração para Teclados Split Wireless
Se você configurar um teclado split padrão (onde a metade esquerda envia os dados da direita para o computador), o ZMK por padrão apenas reporta o nível de bateria da metade esquerda (Central). Para ver a porcentagem de bateria de ambas as metades nas conexões Bluetooth:

```kconfig
# Habilita a busca de nível de bateria da metade periférica (Right) pela metade central (Left)
CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_FETCHING=y

# Habilita o proxy do nível de bateria periférica para o host USB/BLE
CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_PROXY=y
```

### ◽ Modo Split Real (`CONFIG_ZMK_SPLIT=y`)
Este repositório agora usa split real. O arquivo [corne.conf](file:///c:/Users/Vinicius/Documents/Project/doc-keyboard/config/corne.conf) possui:
```kconfig
CONFIG_ZMK_SPLIT=y
```
Isso significa que a metade **esquerda** (Central) se conecta ao computador via USB ou Bluetooth e recebe os dados da metade **direita** (Periférico) exclusivamente via BLE.
* **Lado Esquerdo (Central):** Conecta ao host, envia todas as teclas.
* **Lado Direito (Periférico):** Comunica apenas com o Central via BLE. USB no lado direito serve apenas para carregar bateria.
* **Potência de Transmissão:** O booster de sinal está ativo para conexões estáveis:
  ```kconfig
  CONFIG_BT_CTLR_TX_PWR_PLUS_8=y
  ```

---

## 💡 4. Indicador LED de Status (Módulo Externo)

O módulo **[zmk-poor-mans-led-indicator](https://github.com/BlueDrink9/zmk-poor-mans-led-indicator)** é usado para transformar o LED azul onboard do nice!nano (pino `P0.15`) em um indicador visual de status de conexão BLE e nível de bateria.

### ◽ Integração via West.yml
O módulo é adicionado como dependência externa no arquivo [west.yml](file:///c:/Users/Vinicius/Documents/Project/doc-keyboard/config/west.yml):
```yaml
- name: zmk-poor-mans-led-indicator
  remote: bluedrink9
  revision: main
```

### ◽ Definição do LED no Overlay
O LED é definido no arquivo [corne.overlay](file:///c:/Users/Vinicius/Documents/Project/doc-keyboard/config/corne.overlay) usando o pino `P0.15` (GPIO0 pin 15):
```devicetree
/ {
    leds {
        compatible = "gpio-leds";
        user_led: user_led {
            gpios = <&gpio0 15 GPIO_ACTIVE_HIGH>;
            label = "User LED";
        };
    };
    aliases {
        indicator-led = &user_led;
    };
};
```

### ◽ Configuração no Kconfig (`.conf`)
```kconfig
CONFIG_INDICATOR_LED_WIDGET=y
CONFIG_INDICATOR_LED_SHOW_BLE=y
CONFIG_INDICATOR_LED_SHOW_BATTERY_ON_BOOT=y
```

### ◽ Comportamento do LED
* **No boot:** Pisca lento = bateria boa, pisca rápido = bateria crítica.
* **Ao conectar BLE:** Pisca N vezes (N = número do perfil BT + 1).
* **BLE desconectado:** Pisca rápido para indicar que não está pareado.

> **Nota para placas Tenstar Robot (clone vermelha):** O pino P0.15 controla o **LED azul** onboard. Nas placas originais nice!nano v2 este também é o LED azul programável.
