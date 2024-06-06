/*

    "ChambersTools v0.1"
    Codice per la versione stand-alone e VST.
    Realizzato in Cabbage Studio, richiesto per la compilazione della GUI.
    
    github.com/ghostvita
    
*/

<Cabbage>

/*      GUI Cabbage     */
form caption("Chambers Tool") size(520, 360), guiMode("queue"), pluginId("chgv"), colour(4,4,4) typeface("../ui/NexaText-Trial-Heavy.ttf")

;  Tastiera
keyboard bounds(10, 254, 500, 95)

; Display
signaldisplay bounds(160, 146, 350, 95), colour("white") displayType("waveform"), backgroundColour(4, 4, 4), zoom(-1), signalVariable("gaAudioMasterDisplayL", "gaAudioMasterDisplayR"), channel("display")

;  Pad
groupbox bounds(10, 16, 282, 120), text("Pad") channel("envbox") , fontColour(255, 255, 255, 255) outlineColour(209, 204, 201, 255) colour(20, 20, 20, 255)
vslider bounds(18, 38, 40, 94) channel("attack"), text("Att") range(0.2, 15, 0.4, 0.5, 0.01), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
vslider bounds(60, 38, 40, 94) channel("decay"), text("Dec") range(0.2, 15, 1, 0.5, 0.01), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
vslider bounds(102, 38, 40, 94) channel("sustain"), text("Sus") range(0.2, 15, 1, 0.5, 0.01), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
vslider bounds(144, 38, 40, 94) channel("release"), text("Rel") range(0.2, 15, 1, 0.5, 0.01), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(186, 38, 49, 94) channel("lp"), text("Cutoff") range(0, 22000, 22000, 0.5, 1), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)

;  Riverbero Pad
groupbox bounds(10, 150, 144, 95), text("Pad Reverb") channel("revbox") , fontColour(255, 255, 255, 255) outlineColour(209, 204, 201, 255) colour(20, 20, 20, 255)
rslider bounds(18, 182, 60, 55) channel("revmix"), text("Mix") range(0.5, 1, 0.7, 1, 0.001), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(86, 182, 60, 55) channel("revhp"), text("HP") range(0, 22000, 0, 0.5, 1), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(236, 38, 49, 94) channel("noise"), text("Noise") range(0, 1, 0.1, 1, 0.1), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)

;  Microfono
groupbox bounds(304, 16, 207, 120), text("The Chamber") channel("micbox") , fontColour(255, 255, 255, 255) outlineColour(209, 204, 201, 255) colour(20, 20, 20, 255)
rslider bounds(314, 38, 49, 94) channel("gainmic"), text("Gain") range(0, 1, 0.1, 0.25, 0.0001), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(450, 38, 49, 94) channel("cutoffmic"), text("Cutoff") range(0, 22000, 22000, 0.5, 1), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(382, 38, 49, 94) channel("revmic"), text("Chamber") range(0.7, 1, 0.7, 1, 0.001), trackerColour(255, 255, 255, 255) outlineColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)

</Cabbage>

<CsoundSynthesizer>
    <CsOptions>
        -n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 --displays
    </CsOptions>
    <CsInstruments>
        ;  Variabili globali
        ksmps           = 32
        nchnls          = 2
        0dbfs           = 10 
        gaRvbSend       = 0
        gaRvbSendMic    = 0
        gaAudioMasterDisplayL = 0
        gaAudioMasterDisplayR = 0
        gifn	ftgen	0,0, 257, 9, .5,1,270

        /*      strumento Controlli GUI     */
        instr 99
            gkAttack    cabbageGetValue "attack"    ;Parametro: attacco
            gkDecay     cabbageGetValue "decay"     ;Parametro: decay
            gkSustain   cabbageGetValue "sustain"   ;Parametro: sustain
            gkRelease   cabbageGetValue "release"   ;Parametro: release
            gkGainMic   cabbageGetValue "gainmic"   ;Parametro: gain mic
            gkRevMix    cabbageGetValue "revmix"    ;Parametro: mix riverbero pad
            giRoom      =               .95         ;Costante:  room
            gkRevHP     cabbageGetValue "revhp"     ;Parametro: hi-pass riverbero
            gkNoiseAmt  cabbageGetValue "noise"     ;Parametro: gain pink noise
            gkLowpass   cabbageGetValue "lp"        ;Parametro: pad lo-pass
            gkCutoffMic cabbageGetValue "cutoffmic" ;Parametro: mic lo-pass
            gkMicRevMix cabbageGetValue "revmic"    ;Parametro: mix riverbero mic
            giRevCutoff =               20000
        endin
        
        
        /*              Pad                 */
        instr 1
            gkAmp = p5
            gkEnv mxadsr i(gkAttack), i(gkDecay), i(gkSustain), i(gkRelease)
            kFreq = (p4/2)
            
            ;Oscillatori
            aSound[] init 5
            aSound[0] oscili 1, kFreq
            aSound[1] vco2 0.2, kFreq*3, 12
            aSound[2] oscili 0.5, kFreq*6
            aSound[3] oscili 0.8, kFreq*2
            aSound[4] oscili 0.5, kFreq*5
            aSig = (aSound[0] + aSound[1] + aSound[2] + aSound[3] + aSound[4]) /4
            aSig = aSig*gkEnv
            
            ;LFO panning
            aLfo oscili 0.3, 2
            aL, aR pan2 aSig, k(aLfo)+ .5
            aL vdelay aL, 40, 500
            
            ;LP Pad
            aL moogvcf2 aL, gkLowpass, 0
            aR moogvcf2 aR, gkLowpass, 0

            ;Noise
            aNoise pinker
            aNoise *= gkEnv
            aNoise *= gkNoiseAmt / 100
            aL += aNoise
            aR += aNoise
            
            ;Out e mandata a riverbero
            outs aL, aR
            gaRvbSend = (gaRvbSend + (aL * gkRevMix))*.8
            gaAudioMasterDisplayL = (gaAudioMasterDisplayL + aR) /2
            gaAudioMasterDisplayR = (gaAudioMasterDisplayR + aR) /2
        endin
        
        
        /*        The Chamber                 */
        instr 5
            aIn inch 1
            aIn distort aIn, 2, gifn
            aIn moogvcf2 aIn, gkCutoffMic, 0
            outs aIn*gkGainMic, aIn*gkGainMic
            gaRvbSendMic = (gaRvbSendMic + (aIn * gkMicRevMix))*.8
            gaAudioMasterDisplayL = (gaAudioMasterDisplayL + aIn*gkGainMic) /2
            gaAudioMasterDisplayR = (gaAudioMasterDisplayR + aIn*gkGainMic) /2
        endin
        
        /*        Mandata: Riverbero Pad      */
        instr 50
            aRvbL, aRvbR reverbsc gaRvbSend, gaRvbSend, giRoom, giRevCutoff
            aRvbL atone aRvbL, gkRevHP
            aRvbR atone aRvbR, gkRevHP
            aRvbL vdelay aRvbL, 40, 500
            outs aRvbL, aRvbR
            gaRvbSend = 0
            gaAudioMasterDisplayL = (gaAudioMasterDisplayL + aRvbL) /2
            gaAudioMasterDisplayR = (gaAudioMasterDisplayR + aRvbR) /2
        endin
        
        /*      Mandata: Riverbero Chamber    */
        instr 51
            aRvbL, aRvbR reverbsc gaRvbSendMic, gaRvbSendMic, giRoom, giRevCutoff
            aRvbL atone aRvbL, gkRevHP
            aRvbR atone aRvbR, gkRevHP
            aRvbL vdelay aRvbL, 40, 500
            outs aRvbL*gkGainMic, aRvbR*gkGainMic
            gaRvbSendMic = 0
            gaAudioMasterDisplayL = (gaAudioMasterDisplayL + aRvbL*gkGainMic) /2
            gaAudioMasterDisplayR = (gaAudioMasterDisplayR + aRvbR*gkGainMic) /2
        endin
        
        
        /*      Display    */
        instr 52
            display gaAudioMasterDisplayL, .1, 1
            dispfft gaAudioMasterDisplayL, .1, 1024
            display gaAudioMasterDisplayR, .1, 1
        endin
        
       



    </CsInstruments>
    <CsScore>
        f 1 0 16384 10 1
        i 1 0 z
        i 50 0 z
        i 51 0 z
        i 52 0 z

        i 5 0 z
        i 99 0 z
        f0 z
    </CsScore>
</CsoundSynthesizer>
