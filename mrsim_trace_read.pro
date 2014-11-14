; docformat = 'rst'
;
; NAME:
;       MrSim_Trace_Read
;
;*****************************************************************************************
;   Copyright (c) 2014, Matthew Argall                                                   ;
;   All rights reserved.                                                                 ;
;                                                                                        ;
;   Redistribution and use in source and binary forms, with or without modification,     ;
;   are permitted provided that the following conditions are met:                        ;
;                                                                                        ;
;       * Redistributions of source code must retain the above copyright notice,         ;
;         this list of conditions and the following disclaimer.                          ;
;       * Redistributions in binary form must reproduce the above copyright notice,      ;
;         this list of conditions and the following disclaimer in the documentation      ;
;         and/or other materials provided with the distribution.                         ;
;       * Neither the name of the <ORGANIZATION> nor the names of its contributors may   ;
;         be used to endorse or promote products derived from this software without      ;
;         specific prior written permission.                                             ;
;                                                                                        ;
;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY  ;
;   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES ;
;   OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT  ;
;   SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,       ;
;   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED ;
;   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR   ;
;   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     ;
;   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN   ;
;   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH  ;
;   DAMAGE.                                                                              ;
;*****************************************************************************************
;
; PURPOSE:
;+
;   Read data files generated by the particle tracing code "tparticle". There is "one"
;   conlumn per particle. Each particle has six "subcolumns" containing the particle
;   position [x,y,z] and velocity [vx, vy, vz]. All fields are separated by a single space.
;   No header preceeds the data.
;
; :Params:
;       FILENAME:       in, required, type=string
;                       Name of the file to be read.
;
; :Returns:
;       DATA:           A structure containing one field per particle. Each field
;                           contains an array [x, y, z, vx, vy, vz] for each time step.
;
; :History:
;   Modification History::
;       2014-11-11  -   Written by Matthew Argall
;       2014-11-13  -   Return an array instead of a structure.
;-
function MrSim_Trace_Read, filename
	compile_opt idl2
    on_error, 2

	;Make sure the file exists
	if file_test(filename) eq 0 then $
		message, 'File does not exist: "' + filename + '".'

	;Open and read the first line
	line1 = ''
	openr,    lun, filename, /GET_LUN
	readf,    lun, line1
	free_lun, lun

	;Parse the first line to determine how many particles were used.
	!Null      = strsplit(line1, ' ', COUNT=nColumns)
	nParticles = nColumns / 6

	;Inputs for MrRead_Ascii
	groups       = reform(rebin(lindgen(1,nParticles), 6, nParticles), nColumns)
	column_names = 'Particle_' + strtrim(groups, 2)
	column_types = replicate('Float', nColumns)
	data = MrRead_Ascii(filename, $
	                    COUNT=nTimes, $
	                    GROUPS=groups, $
	                    COLUMN_NAMES=column_names, $
	                    COLUMN_TYPES=column_types)

	;Convert from structure to array
	array = fltarr(6, nTimes, nParticles)
	for i = 0, nParticles - 1 do array[0,0,i] = data.(i)

	return, array
end