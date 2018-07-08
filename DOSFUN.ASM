;-------------------------------------------------------------------------
; DOSFUNC.ASM -- Assembly Language Routines to Convert DosWrite, DosRead,
;                     and DosExit to DOS calls.
;                PC Magazine * Charles Petzold, 7/88
;                Copyright (C) 1988, Ziff Communications Co.
;-------------------------------------------------------------------------

		DOSSEG
		.MODEL	LARGE, PASCAL

;----------------------------------------------
; DosRead (Handle, &Buffer, Count, &BytesRead)
;----------------------------------------------

		.CODE
		PUBLIC	DosRead

DosRead		PROC USES BX CX DX DS,	\
		Handle:WORD, Buffer:PTR BYTE, Count:WORD, BytesRead:PTR BYTE

		Lds	DX, Buffer		; Buffer for data
		Mov	CX, Count		; Number of bytes to read
		Mov	BX, Handle		; Handle
		Mov	AH, 3Fh			; DOS function call
		Int	21h

		Jc	Finish			; If error, get out

		Lds	BX, BytesRead		; Get bytes read pointer
		Mov	[BX], AX		; Store bytes read in there
		Sub	AX, AX			; Set AX for no error
Finish:         Ret

DosRead		ENDP

;---------------------------------------------
; DosWrite (Handle, &Buffer, Count, &Written)
;---------------------------------------------

		.CODE
		PUBLIC	DosWrite

DosWrite	PROC USES BX CX DX DS,	\
	 	Handle:WORD, Buffer:PTR BYTE, Count:WORD, Written:PTR BYTE

		Lds	DX, Buffer		; Buffer with data
		Mov	CX, Count		; Number of bytes to write
		Mov	BX, Handle		; Handle
		Mov	AH, 40h			; DOS function call
		Int	21h

		Jc	Finish			; If error, get out

		Lds	BX, Written		; Get bytes written pointer
		Mov	[BX], AX		; Store bytes written in there
		Sub	AX, AX			; Set AX for no error
Finish:         Ret

DosWrite	ENDP

;---------------------------------
; DosExit (TermThreads, ExitCode)
;---------------------------------

		.CODE
		PUBLIC	DosExit

DosExit		PROC TermThreads:WORD, ExitCode:WORD

		Mov	AX, ExitCode		; Get exit code from stack
		Mov	AH, 4Ch			; DOS function call
		Int	21h

DosExit		ENDP
		END
