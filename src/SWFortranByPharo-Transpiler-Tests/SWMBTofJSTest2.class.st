Class {
	#name : #SWMBTofJSTest2,
	#superclass : #SWTranspilerTestBaseJS,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMBTofJSTest2 >> test_9002_ZnUrl_queryAt_ifPresent [
	SWServer setUpTranspiler: module.
	self resultWith: { ZnUrl } equals: 'var t_0 = null;
t_0 = url.at("name");
if(t_0 != null){
    var name = t_0;
    return name;
}
'
]

{ #category : #tests }
SWMBTofJSTest2 >> test_9003_cascading_2 [
	self resultWith: {  } equals: 'var t_0 = null;
var t_1 = null;
t_0 = new Dictionary();
t_1 = new Set();
t_1.add_("hello");
t_1.add_("good-bye");
t_0["world"] = t_1;
return t_0;
'
]

{ #category : #tests }
SWMBTofJSTest2 >> test_9004_cascading_3 [
	self resultWith: { Boolean } equals: 'var t_0 = null;
If(needle){
    var t_1 = null;
    var t_2 = null;
    t_1 = new Dictionary();
    t_2 = new Set();
    t_2.add_("hello");
    t_2.add_("good-bye");
    t_1["world"] = t_2;
    t_0 = t_1;
} else {
    var t_3 = null;
    var t_4 = null;
    t_3 = new Dictionary();
    t_4 = new Set();
    t_4.add_("lost");
    t_4.add_("hell");
    t_3["heaven"] = t_4;
    t_0 = t_3;
}
return t_0;
'
]

{ #category : #utilities }
SWMBTofJSTest2 >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpileAsMain

]
