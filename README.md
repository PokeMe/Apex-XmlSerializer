# Apex-XmlSerializer

## Goal
The aim of this library is to use POJO/POAO for serializing into xml.

## Examples

First define your POJO/POAO
```
public class XmlWrapper implements XMLSerializer.XMLSerializable {
    public Human h;
    
    public Object getField(String fieldName){ 
        Map<String, Object> fieldMap = new Map<String, Object>{
            'human' => this.h
        };
        return fieldMap.get(fieldName);
    }
    
    public String[] getFieldList(){
        return new String[]{
            'human'
        };
    }
    public Map<String, Map<String, String> > getFieldToAttrMap() {
        return new Map<String, Map<String, String> >{
			'human' => new Map<String, String> {
				'type' => 'Male'
			}
		};
    }
}

public class Human implements XMLSerializer.XMLSerializable {
    public Integer age;
    public String name;
    
    public Object getField(String fieldName){ 
        Map<String, Object> fieldMap = new Map<String, Object>{
            'age' => this.age
            , 'name' => this.name
        };
        return fieldMap.get(fieldName);
    }
    
    public String[] getFieldList(){
        return new String[]{
            'name'
            , 'age'
        };
    }
    public Map<String, Map<String, String> > getFieldToAttrMap() {
        return new Map<String, Map<String, String> >{};
    }
}

```

Using your defined POJO/POAO

```

XmlWrapper x = new XmlWrapper();
x.h = new Human();
x.h.age = 42;
x.h.name = 'Bob';

String output = XMLSerializer.serialize(x);
```

This produces
```
<human type="Male">
	<age>42</age>
	<name>Bob</name>
</human
```


