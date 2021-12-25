"
I'm a server.
"
Class {
	#name : #SWServerProgram,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Server-Program'
}

{ #category : #accessing }
SWServerProgram class >> build [
	<script>
	|project|
	project := SWPTofJS newFrom: SWServer.

	project inspect.

]
