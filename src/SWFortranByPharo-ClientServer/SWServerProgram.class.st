"
I'm a server.
"
Class {
	#name : #SWServerProgram,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Program'
}

{ #category : #accessing }
SWServerProgram class >> build [
	<script>
	|project|
	project := SWMTofJS newMainProgramFrom: SWServer.
	project transpile.
	project inspect.

]
