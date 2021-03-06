; docformat = 'rst'
;
; NAME:
;       MrSim_ReadInfoAscii
;
; PURPOSE:
;+
;       The purpose of this program is to read the ASCII "info" file relating to Bill
;       Daughton's simulations.
;
; :Categories:
;   Data Reader, Simulation, Bill Daughton
;
; :Uses:
;   Uses the following external programs::
;       cgErrorMSG.pro (Coyote Graphics)
;                           
; :Author:
;    Matthew Argall::
;       University of New Hampshire
;       Morse Hall, Room 113
;       8 College Rd.
;       Durham, NH, 03824
;       matthew.argall@wildcats.unh.edu
;
; :Copyright:
;       Copyright 2013 by Matthew Argall
;
; :History:
;   Modification History::
;       2014/01/22  -   Written by Matthew Argall
;       2014/01/29  -   Added fields to account for 3D simulation info files - MRA
;       2014/02/07  -   Renamed from Sim_Read_Info_Ascii.pro to MrSim_ReadInfoAscii.pro - MRA
;       2014/10/04  -   Added MrSim_ReadInfoAscii_GetStruct to handle different versions
;                           of the info file. - MRA
;-
;*****************************************************************************************
;+
;
; :Params:
;       FILENAME:           in, required, type=string
;                           Name of the "info" file to be read.
;       VERSION:            in, optional, type=integer, default=1
;                           Version of the ASCII info file to read. Up until 2014-10-03
;                               all simulations have used version 1. The real mass ratio,
;                               symmetric simulations use a different type. Versions are::
;                                   Version                    File Contents
;                                      1                            L_di
;                                                                   L_de
;                                                                   Ti_Te
;                                                                   Tbi_Ti
;                                                                   Tbe_Te
;                                                                   wpe_wce
;                                                                   mi_me
;                                                                   etc.
;                                                                  -------
;                                       2                           L_di
;                                                                   L_de
;                                                                   rhoi_L
;                                                                   Ti_Te
;                                                                   Tbi_Ti
;                                                                   Tbe_Te
;                                                                   nb_n0
;                                                                   wpe_wce
;                                                                   mi_me
;                                                                   etc.
;                                                                  -------
;
; :Returns:
;       DATA:               out, optional, type=structure
;                           Structure containing simulation information.
;-
function MrSim_ReadInfoAscii_GetStruct, filename, version
    compile_opt strictarr
    on_error, 2
    
    ;Which version of the ASCII file to read?
    if n_elements(version) eq 0 then version = 1
    
    ;Create an Info structure
    if version eq 1 then begin
        info = { L_di:       0D, $
                 L_de:       0D, $
                 Ti_Te:      0D, $
                 Tbi_Ti:     0D, $
                 Tbe_Te:     0D, $
                 wpe_wce:    0D, $
                 mi_me:      0D, $
                 theta:      0D, $
                 taui:       0D, $
                 num_step:   0L, $
                 Lx_de:      0D, $
                 Ly_de:      0D, $
                 Lz_de:      0D, $
                 Lx_di:      0D, $
                 Ly_di:      0D, $
                 Lz_di:      0D, $
                 nx:         0D, $
                 ny:         0D, $
                 nz:         0D, $
                 damp:       0D, $
                 courant:    0D, $
                 nproc:      0D, $
                 nppc:       0D, $
                 b0:         0D, $
                 v_A:        0D, $
                 di:         0D, $
                 N_e:        0D, $
                 Ne_sheet:   0D, $
                 Ne_back:    0D, $
                 N_total:    0D, $
                 dtxwpe:     0D, $
                 dtxwce:     0D, $
                 dtxwci:     0D, $
                 E_interval: 0L, $
                 dx_de:      0D, $
                 dy_de:      0D, $
                 dz_de:      0D, $
                 L_debye:    0D, $
                 dx_rhoi:    0D, $
                 dx_rhoe:    0D, $
                 dx_debye:   0D, $
                 n0:         0D, $
                 vthi_c:     0D, $
                 vthe_c:     0D, $
                 vdri_c:     0D, $
                 vdre_c:     0D, $
                 fluct_diagnostic_interval: 0L, $
                 nfac:       0D, $
                 e_weight_sheet:    0D, $
                 e_weight_bckgrd:   0D, $
                 ion_weight_sheet:  0D, $
                 ion_weight_bckgrd: 0D $
               }
               
    endif else if version eq 2 then begin
        ;Create an Info structure
        info = { L_di:       0D, $
                 L_de:       0D, $
                 rhoi_L:     0D, $      ;New Addition
                 Ti_Te:      0D, $
                 Tbi_Ti:     0D, $
                 Tbe_Te:     0D, $
                 nb_n0:      0D, $      ;New Addition
                 wpe_wce:    0D, $
                 mi_me:      0D, $
                 theta:      0D, $
                 taui:       0D, $
                 num_step:   0L, $
                 Lx_de:      0D, $
                 Ly_de:      0D, $
                 Lz_de:      0D, $
                 Lx_di:      0D, $
                 Ly_di:      0D, $
                 Lz_di:      0D, $
                 nx:         0D, $
                 ny:         0D, $
                 nz:         0D, $
                 damp:       0D, $
                 courant:    0D, $
                 nproc:      0D, $
                 nppc:       0D, $
                 b0:         0D, $
                 v_A:        0D, $
                 di:         0D, $
                 N_e:        0D, $
                 Ne_sheet:   0D, $
                 Ne_back:    0D, $
                 N_total:    0D, $
                 dtxwpe:     0D, $
                 dtxwce:     0D, $
                 dtxwci:     0D, $
                 E_interval: 0L, $
                 dx_de:      0D, $
                 dy_de:      0D, $
                 dz_de:      0D, $
                 L_debye:    0D, $
                 dx_rhoi:    0D, $
                 dx_rhoe:    0D, $
                 dx_debye:   0D, $
                 n0:         0D, $
                 vthi_c:     0D, $
                 vthe_c:     0D, $
                 vdri_c:     0D, $
                 vdre_c:     0D $
               }
    endif
    
    return, info
end


;+
; :Params:
;       FILENAME:           in, required, type=string
;                           Name of the "info" file to be read.
;
; :Keywords:
;       VERSION:            in, optional, type=integer, default=1
;                           Version of the ASCII info file to read. Up until 2014-10-03
;                               all simulations have used version 1. The real mass ratio,
;                               symmetric simulations use a different type.
;
; :Returns:
;       DATA:               out, optional, type=structure
;                           Structure containing simulation information.
;-
function MrSim_ReadInfoAscii, filename, $
VERSION=version
    compile_opt strictarr
    
    ;catch errors
    catch, the_error
    if the_error ne 0 then begin
        catch, /cancel
        
        ;close the file and free its logical unit number
        if n_elements(lun) gt 0 then free_lun, lun
        
        void = cgErrorMsg()
        return, !null
    endif

    ;Make sure the file exists
    if file_test(filename) eq 0 then message, 'File not found: "' + filename + '"'
    
    ;Count how many lines there are.
    nLines = file_lines(filename)
    nHeader = 1
    nPts = nLines - nHeader
    
    ;Create an Info structure
    info = MrSim_ReadInfoAscii_GetStruct(filename, version)
    
    ;Type of data being read.
    line = ''
    header = ''
    
    ;Open the document and read the header
    openr, lun, filename, /GET_LUN
    readf, lun, format='(a0)', header

    ;Step through all of the data
    for i = 0, nPts-1 do begin
        readf, lun, line
        data = stregex(line, '(-?[0-9]\.?[0-9]+e?[+-]?[0-9]*)', /SUBEXP, /EXTRACT)
        if data[0] eq '' then continue

        if strpos(data[1], '.') eq -1 $
            then outData = long(data[1]) $
            else outData = double(data[1])

        info.(i) = outData
    endfor
    
    ;close the file
    free_lun, lun
    
    return, info
end
