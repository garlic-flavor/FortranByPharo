Class {
	#name : #SWMBTofJSTest2,
	#superclass : #SWTranspilerTestBaseJS,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMBTofJSTest2 >> test_9002_ZnUrl_queryAt_ifPresent [
	SWServer setUpTranspiler: module.
	self resultWith: { ZnUrl }
]

{ #category : #tests }
SWMBTofJSTest2 >> test_9003_cascading_2 [
	self resultWith: {  } equals: 'var t_0 = null;
var t_1 = null;
return (t_0 = new Dictionary(), 
    t_0["world"] = (t_1 = new Set(), 
        t_1.add_("hello"), 
        t_1.add_("good-bye"), 
        t_1), 
    t_0);
'
]

{ #category : #tests }
SWMBTofJSTest2 >> test_9004_cascading_3 [
	self resultWith: { Boolean } equals: 'var t_0 = null;
var t_1 = null;
var t_2 = null;
return (needle ? (t_0 = new Dictionary(), 
    t_0["world"] = (t_1 = new Set(), 
        t_1.add_("hello"), 
        t_1.add_("good-bye"), 
        t_1), 
    t_0) : new Dictionary()["heaven"] = (t_2 = new Set(), 
    t_2.add_("lost"), 
    t_2.add_("hell"), 
    t_2));
'
]

{ #category : #utilities }
SWMBTofJSTest2 >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpile

]
