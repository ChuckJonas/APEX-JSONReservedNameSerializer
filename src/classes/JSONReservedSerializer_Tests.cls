@isTest
public class JSONReservedSerializer_Tests {

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
        String newString = myJSON.serialize(obj, MyDTO.class);
        System.assertEquals(origString, newString);
    }

    @isTest
    private static void testBlankMapReturnsStringOnSerialize(){
        String stringX = 'x';
        MySerializer myJSON = new MySerializer();
        System.assertEquals('"x"', myJSON.serialize(stringX, true, null)); 
    }

    // CLASS FOR TESTING
    public class MySerializer extends JSONReservedSerializer {
        public MySerializer() {
            //setup mappings
            super(new Map<Type,Map<String,String>>{
                MyDTO.class => new Map<String, String> {
                    'obj' => 'object',
                    'isPrivate' => 'private'
                }
            });
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
