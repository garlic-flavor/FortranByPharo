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
	|module|
	module := SWMTofJS newMainProgramFrom: SWServer.
	module enableDebugMode.
	module transpile.
	module inspect.

]
