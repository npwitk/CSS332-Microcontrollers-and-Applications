		.EQU SUM = 0x300

		.ORG 00
		LDI R16, 0x25
		LDI R17, $34
		LDI R1, 0b00110001
		ADD R16, R17
		ADD R16, R18
		LDI R17, 11
		ADD R17, R17
		STS SUM, R16
HERE:	JMP HERE