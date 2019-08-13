/* Author: Charlie Jonas (charlie@callawaycloudconsulting.com)
 * Description: Allows reserved named serialization.
 * Usage:  See Readme @ https://github.com/ChuckJonas/APEX-JSONReservedNameSerializer
 */
public abstract class JSONReservedSerializer {
    private final Map<Type,Map<String,String>> typeMapKeys;

    public JSONReservedSerializer(Map<Type, Map<String, String>> typeMapKeys){
        this.typeMapKeys = typeMapKeys;
    }

    public String serialize(Object obj, System.Type type){
        return serialize(obj, false, type);
    }

    public String serialize(Object obj, Boolean suppressNulls, System.Type type){
        String retString = JSON.serialize(obj, suppressNulls);
        retString = transformStringForSerilization(retString, typeMapKeys.get(type));
        return retString;
    }

    public Object deserialize(String jsonString, System.Type type){
        jsonString = transformStringForDeserilization(jsonString, typeMapKeys.get(type));
        return JSON.deserialize(jsonString, type);
    }

    private static String transformStringForSerilization(String s, Map<String, String> mapKeys){
        if(mapKeys == null){
            return s;
        }
        return replaceAll(s, mapKeys);
    }

    private static String transformStringForDeserilization(String s, Map<String, String> mapKeys){
        if(mapKeys == null){
            return s;
        }
        Map<String,String> flippedMap = new Map<String,String>();
        for(String key : mapKeys.keySet()){
            flippedMap.put(mapKeys.get(key), key);
        }
        return replaceAll(s, flippedMap);
    }

    private static String replaceAll(String s, Map<String,String> toFromMap){
        for(String key : toFromMap.keySet()){
            s = s.replaceAll('"'+key+'"(\\ )*:', '"'+toFromMap.get(key)+'":');
        }
        return s;
    }
}
