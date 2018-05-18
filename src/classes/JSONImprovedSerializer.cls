/* Author: Charlie Jonas (charlie@callawaycloudconsulting.com)
 * Description: Allows more robust JSON serialization
 *   1: maps JSON props to class props
 *   2: remove null values from serialized strings
 */
public abstract class JSONImprovedSerializer {
    private Map<String,String> mapKeys;

    private boolean serializeNulls = true;

    /* SETUP METHODS */
    //constructor
    protected JSONImprovedSerializer(Map<String,String> mapping){
        this.mapKeys = mapping;
    }

    //use to set how nulls are serialized.
    // Set false to remove nulls from string.
    public void setSerializeNulls(boolean b){
        this.serializeNulls = b;
    }

    public String serialize(Object obj){
        String retString = JSON.serialize(obj, !serializeNulls);
        retString = transformStringForSerilization(retString);
        return retString;
    }

    public Object deserialize(String jsonString, System.Type type){
        jsonString = transformStringForDeserilization(jsonString);
        return JSON.deserialize(jsonString, type);
    }

    private String transformStringForSerilization(String s){
        return replaceAll(s, mapKeys);
    }

    private String transformStringForDeserilization(String s){
        Map<String,String> flippedMap = new Map<String,String>();
        for(String key : mapKeys.keySet()){
            flippedMap.put(mapKeys.get(key), key);
        }
        return replaceAll(s, flippedMap);
    }

    private String replaceAll(String s, Map<String,String> toFromMap){
        for(String key : toFromMap.keySet()){
            s = s.replaceAll('"'+key+'"(\\ )*:', '"'+toFromMap.get(key)+'":');
        }
        return s;
    }

}