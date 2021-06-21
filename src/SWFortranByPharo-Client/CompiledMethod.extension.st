Extension { #name : #CompiledMethod }

{ #category : #'*SWFortranByPharo-Client' }
CompiledMethod >> transpileUsing: transpiler [
	self flag: #TODO.
	transpiler enterBlock.
	self sourceNode transpileUsing: transpiler.
	transpiler leaveBlock.
]

{ #category : #'*SWFortranByPharo-Client' }
CompiledMethod >> transpileUsing: transpiler asMainOf: project [
	self flag: #TODO.
	transpiler putMainProgramHeaderOf: project.
	self transpileUsing: transpiler.
	transpiler putMainProgramFooterOf: project.
	^ transpiler contents.
]
