@isTest
private class XMLSerializerTest {
    public class TestXMLClass implements XMLSerializer.XMLSerializable { 
        public String someField;
        public String anotherField;
        public TestXMLClass testSerialize;
        public TestXMLClass[] testSerializeList;
        
        public Object getField(String fieldName){ 
            Map<String, Object> fieldMap = new Map<String, Object>{
                'someField' => this.someField
                , 'another-field' => this.anotherField
                , 'testSerialize' => this.testSerialize
                , 'testSerializeList' => this.testSerializeList
            };
            return fieldMap.get(fieldName);
        }
        
        public String[] getFieldList(){
            return new String[]{
                'another-field'
                , 'someField'
                , 'testSerialize'
                , 'testSerializeList'
            };
        }
        
        public Map<String, Map<String, String> > getFieldToAttrMap() {
            return new Map<String, Map<String, String> >();
        }
        
    }
    
    private static testmethod void test1() {
        TestXMLClass o = new TestXMLClass();
        o.someField = 'fld';
        o.anotherField = 'another';
        o.testSerializeList = new TestXMLClass[]{ new TestXMLClass() };
        o.testSerializeList[0].someField = 'fld2';
        o.testSerialize = new TestXMLClass();
        o.testSerialize.someField = 'fld2';

        String xmlStr = XMLSerializer.serialize(o);
        
        system.assertEquals(
            '<another-field>another</another-field><someField>fld</someField><testSerialize><someField>fld2</someField></testSerialize><testSerializeList><someField>fld2</someField></testSerializeList>'
            , xmlStr
        );
    }
    
    public class TestXMLAttrClass implements XMLSerializer.XMLSerializable { 
        public String someField;
        
        public String data;
        
        public Object getField(String fieldName){ 
            Map<String, Object> fieldMap = new Map<String, Object>{
                'someField' => this.someField
            };
            return fieldMap.get(fieldName);
        }
        
        public String[] getFieldList(){
            return new String[]{
                'someField'
            };
        }
        public Map<String, Map<String, String> > getFieldToAttrMap() {
            return new Map<String, Map<String, String> >{
                'someField' => new Map<String, String> {
                    'type' => data
                }
            };
        }
    }
    
    private static testmethod void test2() {
        TestXMLAttrClass o = new TestXMLAttrClass();
        o.someField = 'fld';
        o.data = 'data';

        String xmlStr = XMLSerializer.serialize(o);
        
        system.assertEquals(
            '<someField type="data">fld</someField>'
            , xmlStr
        );
    }
    
    public class TestOuter implements XMLSerializer.XMLSerializable {
        public TestItem[] items;
        
        public Object getField(String fieldName){ 
            Map<String, Object> fieldMap = new Map<String, Object>{
                'item' => this.items
            };
            return fieldMap.get(fieldName);
        }
        
        public String[] getFieldList(){
            return new String[]{
                'item'
            };
        }
        public Map<String, Map<String, String> > getFieldToAttrMap() {
            return new Map<String, Map<String, String> >{};
        }
    }
    
    public class TestItem extends XMLSerializer.XMLTaglessValue {
        
        public String data;
        
        public TestItem(String d, String v){
            super(v);
            data = d;
        }

        public override Map<String, Map<String, String> > getFieldToAttrMap() {
            return new Map<String, Map<String, String> >{
                '' => new Map<String, String> {
                    'type' => data
                }
            };
        }
    }
    
    private static testmethod void testlist() {
        TestOuter o = new TestOuter();
        o.items = new TestItem[]{
            new TestItem('test1', 'hello')
            , new TestItem('test2', 'world')
        };
        
        String xmlStr = XMLSerializer.serialize(o);
        
        system.assertEquals(
            '<item type="test1">hello</item><item type="test2">world</item>'
            , xmlStr
        );
        
    }
    
    
}