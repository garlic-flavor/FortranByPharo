Class {
	#name : #SWMBTofF90Test,
	#superclass : #SWTranspilerTestBaseF90,
	#category : #'SWFortranByPharo-Transpiler-Tests-F90'
}

{ #category : #tests }
SWMBTofF90Test >> test_0010_nop [
	self resultWith: {  } equals: 'program SWTestProgram_0010_nop
end program SWTestProgram_0010_nop
'
]

{ #category : #tests }
SWMBTofF90Test >> test_9006_method_call [
	self resultWith: {  } equals: 'program SWTestProgram_9006_stdout
    print *, "hoge!";
end program SWTestProgram_9006_stdout
'
]

{ #category : #utilities }
SWMBTofF90Test >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpileAsMain

]
