''
''        Author: Marko Lukat
'' Last modified: 2019/05/21
''       Version: 0.4
''
CON
  _clkmode = client#_clkmode
  _xinfreq = client#_xinfreq

OBJ
   client: "core.con.client.badgeWX"
  SSD1306: "core.con.ssd1306"

     view: "coreView.1K.SPI"
     rgbx: "jm_rgbx_pixel"
     comm: "FFDS1"
  
PUB main

  init

  comm.str(string($FE, "SET:wifi-mode,STA", 13))        ' STAtion mode only
  if response_eq(string($FE, "=S,0", 13), 250)
    ifnot ina[client#BTN_COM_L] | ina[client#BTN_COM_R] ' both shoulder buttons released
      reboot                                            ' skip next level, reboot

    rgbx.clear                                          ' shut down LEDs
    comm.str(string($FE, "FRUN:autorunSD.bin", 13))     ' next level boot loader
    waitcnt(clkfreq + cnt)

' We don't expect to reach this point.

  pixels[0] := pixels[3] := $05_00_00_00

DAT                                                     ' RGBX pixel data
pixels  long    $05_05_05_00[4]
  
DAT                                                     ' display initialisation sequence
        byte    6
iseq    byte    SSD1306#SET_MEMORY_MODE, %111111_00     ' horizontal mode
        byte    SSD1306#SET_SEGMENT_REMAP|1             ' |
        byte    SSD1306#SET_COM_SCAN_DEC                ' rotate 180 deg
        byte    SSD1306#SET_CHARGE_PUMP, %11_010100     ' no external Vcc

PRI init : surface

  rgbx.start_2812b(@pixels, 4, client#RGBX, 1_0)        ' start RGBX LED driver

  surface := view.init                                  ' start OLED driver
  view.cmdN(@iseq, iseq[-1])                            ' finish setup
  view.swap(surface)                                    ' show initial screen
  view.cmd1(SSD1306#DISPLAY_ON)                         ' display on

  dira[client#WX_DI] := 1                               ' send break to enable
  waitcnt(clkfreq /320 + cnt)                           ' command mode
  dira[client#WX_DI] := 0                               ' length = 30/baud
                                                        
  comm.start(client#WX_DO, client#WX_DI, 115200)        ' link to WiFi h/w

  outa[client#BTN_SEC_M] := 1                           ' shoulder push button
  dira[client#BTN_SEC_M] := 1                           ' active

PRI response_eq(signature, timeout)

  repeat strsize(signature)                             ' check incoming string
    if byte[signature++] <> comm.rxtime(timeout)        ' response against our
      return{FALSE}                                     ' signature

  return TRUE                                           ' match
  
DAT