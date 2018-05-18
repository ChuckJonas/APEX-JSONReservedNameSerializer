@isTest
public class JSONImprovedSerializer_Tests {

    @isTest
    private static void testRoundTrip(){
        String origString = '{"object":{"notReserved":"abc","private":true}}';

        MySerializer myJSON = new MySerializer();

        //deserialization
        MyDTO obj = (MyDTO)
        myJSON.deserialize(
            origString,
            MyDTO.class
        );

        //serialization
        String newString = myJSON.serialize(obj);
        System.assertEquals(origString, newString);
    }

    // CLASS FOR TESTING
    public class MySerializer extends JSONImprovedSerializer {
        public MySerializer() {
            //setup mappings
            super(
                new Map<String,String>{
                    'obj' => 'object',
                    'isPrivate' => 'private'
                }
            );
            //turn off null serialization
            setSerializeNulls(false);
        }
    }

    //define DTO's using mapped names
    public class MyDTO {
        public MyInnerDTO obj;
    }

    public class MyInnerDTO {
        public Boolean isPrivate;
        public String notReserved;
    }

}