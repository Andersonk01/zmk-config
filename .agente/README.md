# Documentação Técnica do nice!nano para o Agente

Esta pasta contém a documentação local completa e detalhada para o microcontrolador **nice!nano** (principalmente a versão v2), servindo como guia de referência técnica para desenvolvimento, mapeamento de hardware, flashing e integração com o ZMK Firmware.

## 🗂️ Estrutura da Documentação

A documentação está dividida nos seguintes arquivos de referência:

1. **[Especificações de Hardware e Cuidados](nice_nano_v2.md)**
   * Detalhes sobre o chip Nordic nRF52840.
   * Pinagem completa e mapeamento físico Pro Micro para GPIO nativo do nRF52840.
   * LEDs onboard (funcionamento do LED de carregamento laranja e do LED programável azul).
   * Gerenciador de carga de bateria (BQ24072) e boost solder jumper de 500mA.
   * ⚠️ **Avisos Críticos:** Polaridade reversa do conector JST e perigos no uso de cabos TRRS.

2. **[Integração e Configuração ZMK](zmk_integration.md)**
   * Configuração de DeviceTree para monitoramento de bateria (VDDH na v2 vs AIN2 na v1).
   * Uso do pino `P0.13` para desligar energia externa (`ext-power`) e poupar bateria.
   * Kconfig flags importantes para status de bateria em teclados split ou standalone.

3. **[Flashing e Resolução de Problemas](bootloader_flashing.md)**
   * Como entrar no modo bootloader UF2 (duplo clique no reset ou curto nos pinos RST/GND).
   * Fluxo de gravação de arquivos `.uf2`.
   * Resolução de problemas comuns (cabos sem suporte a dados, bootloader corrompido, e recuperação com programador externo).

---

## 🛠️ Sobre o nice!nano v2 nesta Configuração

O repositório atual está configurado para um teclado **Corne (Split)** configurado com duas metades independentes (sem fio, sem split master/slave tradicional, com `CONFIG_ZMK_SPLIT=n` no `corne.conf`). Ambas as metades utilizam controladores nice!nano.

* **Recomendação Principal:** Sempre verifique a polaridade de qualquer bateria Li-Po antes de conectá-la aos pads `B+`/`B-`.
* **Regra de Ouro:** Nunca conecte um cabo TRRS entre as duas metades quando estiver utilizando controladores wireless nice!nano, pois isso causará curto-circuito e danos irreversíveis aos pinos GPIO e à controladora.
