# Reserved Keyword Serializer
A Utility class for better control over JSON serialization/deserialization in salesforce apex

## Install

1. `git clone`
1. `cd` into folder
1. `sfdx force:mdapi:deploy -u [username] -d ./src -w 10000`

## Usage

### extend

For any JSON you need to Serialize datastructure you need to seralize:
1: `extends JSONReservedSerializer`
2: pass mappings into the `super()` constructor.  Mapping is defined by `Map<Type, Map<String,String>>` where `Type` is the top level object you are serializing.  This allows for seralizaiton of multiple types in a single class.

```java
public class MySerializer extends JSONImprovedSerializer {

  private MySerializer() {
    //setup mappings
    super(new Map<Type,Map<String,String>>{
      MyOuterDTO.class => OUTER_DTO_MAPPINGS
    });
  }

  //define DTO's using mapped names
  static final Map<String, String> OUTER_DTO_MAPPINGS = new Map<String, String> {
      'obj' => 'object',
      'isPrivate' => 'private'
  };

  public class OuterDTO {
    public InnerDTO obj;
  }

  public class InnerDTO {
    public Boolean isPrivate;
    public String notReserved;
  }
}
```

### Serialize / Deserialize

```java

String origString = '{"object":{"private":true,"notReserved":"abc"}}';

//deserialization
MySerializer json = new MySerializer();
MySerializer.OuterDTO dto = (MySerializer.OuterDTO) json.deserialize(
  origString,
  MySerializer.OuterDTO.class
);

//serialization
String newString = json.serialize(obj, MySerializer.OuterDTO.class);
System.assertEquals(origString, newString);
```

### Notes

1. Serialization mappings are global to the entire object
1. Likely will fail due to limit exceptions with extremely large strings
