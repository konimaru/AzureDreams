''
'' prerequisites, dependencies & Co, Parallax badgeWX
''
''        Author: Marko Lukat
'' Last modified: 2019/05/20
''       Version: 0.3
''
CON
  _clkmode = XTAL1|PLL16X
  _xinfreq = 5_000_000

CON
  #0, AUDIO_L, AUDIO_R                                  ' AUDIO channels

  STAT  = 9                                             ' status LEDs
  RGBX  = 10                                            ' RGB LED strip

  #11, BTN_SEC_R, BTN_SEC_M, BTN_SEC_L                  ' |
       BTN_COM_L, BTN_COM_R                             ' shoulder buttons

  SCL   = 28                                            ' |
  SDA   = 29                                            ' I2C bus

  WX_DI = 30    {P1.tx}                                 ' |
  WX_DO = 31    {P1.rx}                                 ' WiFi comm

PUB null
'' This is not a top level object.

DAT