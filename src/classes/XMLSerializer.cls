public class XMLSerializer {
    
    public Interface XMLSerializable {
        
        Object getField(String fieldName);
        
        String[] getFieldList();
        
        /*
            Maps field to attributes
            e.g. If we had <animal type="Dog">Fido</animal>
            we would have animal => (type => dog)
        */
        Map<String, Map<String, String> > getFieldToAttrMap();

    }
    
    public virtual class XMLTaglessValue implements XMLSerializable {
        
        Object value;
        public XMLTaglessValue(){}
        public XMLTaglessValue(Object value){
            this.value = value;
        }
        public Object getField(String fieldName) {
            return null;
        }
        
        public String[] getFieldList() {
            return new String[]{};
        }
        
        public virtual Map<String, Map<String, String> > getFieldToAttrMap(){
            return new Map<String, Map<String, String> >();
        }
    }
    
    public static String serialize(XMLSerializable obj) {
        return serialize(obj, false);
    }
    
    public static String serialize(XMLSerializable obj, boolean writeEmptyTags) {
        
        XmlStreamWriter w = new XmlStreamWriter();
        
        serialize(obj, w, writeEmptyTags);
        
        return w.getXMLString();
    }
    
    private static void serialize(XMLSerializable obj, XmlStreamWriter w, boolean writeEmptyTags) {

        Map<String, Map<String, String> > fieldToAttrMap = obj.getFieldToAttrMap();
        Map<String, String> parentAttrMap = fieldToAttrMap.get('');
        if (parentAttrMap != null && !parentAttrMap.isEmpty()) {
            for (String attrKey : parentAttrMap.keySet()) {
                w.writeAttribute('', '', attrKey, parentAttrMap.get(attrKey));
            }
        }
        
        if (obj instanceof XMLTaglessValue) {
                
                w.writeCharacters(String.valueOf( 
                    ((XMLTaglessValue) obj).value
                    
                ));
                
        } else {

            for (String fld : obj.getFieldList()) {
                
                Object fldValue = obj.getField(fld);
                if (!writeEmptyTags && fldValue == null){
                    continue;
                }

                if (fldValue == null){
                    w.writeEmptyElement('', fld, '');
                    
                } else if (fldValue instanceof XMLSerializable) {
                    
                    writeStartElement(obj, w, fld);
                    serialize((XMLSerializable) fldValue, w, writeEmptyTags);
                    w.writeEndElement();
                    
                } else if (fldValue instanceof List<XMLSerializable>) {
                    for (XMLSerializable e : (XMLSerializable[]) fldValue){
                        writeStartElement(obj, w, fld);
                        serialize(e, w, writeEmptyTags);
                        w.writeEndElement();
                    }
                    
                } else {
                    
                    writeStartElement(obj, w, fld);
                    w.writeCharacters(String.valueOf(fldValue));
                    w.writeEndElement();
                    
                }
                
            }
        }
    }
    
    private static void writeStartElement(XMLSerializable obj, XmlStreamWriter w, String fld) {
        Map<String, Map<String, String> > fieldToAttrMap = obj.getFieldToAttrMap();
        
        w.writeStartElement('', fld, '');
        
        Map<String, String> attrMap = fieldToAttrMap.get(fld);
        if (attrMap != null && !attrMap.isEmpty()) {
            for (String attrKey : attrMap.keySet()) {
                w.writeAttribute('', '', attrKey, attrMap.get(attrKey));
            }
        }
    }
    
}