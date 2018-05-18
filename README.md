# apex-JSONImprovedSerializer
A Utility class for better control over JSON serialization/deserialization in salesforce apex

## Install

1. `git clone`
1. `cd` into folder
1. `sfdx force:mdapi:deploy -u [username] -d ./src -w 10000`

## Usage

### extend

For any JSON you need to Serialize datastructure you need to seralize:
1: `extends JSONImprovedSerializer`
2: pass mappings into the `super()` constructor.  Mapping is in format `'newProperty' => 'oldProperty'`.
3: optionally set how to handle nulls

```java
public class MySerializer extends JSONImprovedSerializer {

  public static MySerializer instance {get; private set;}

  static {
    instance = new MySerializer();
  }

  private MySerializer() {
    //setup mappings
    super(
        new Map<String,String>{
            'classObj' => 'class',
            'isPrivate' => 'private'
        }
    );
    //turn off null serialization
    setSerializeNulls(false);
  }
  public class MySerializerType{
    public String currencyType {get; set;}
    public String myReservedWordProp {get; set;}
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
```

### serialize / deserialize

```java
String origString = '{"object":{"private":true,"notReserved":"abc"}}';

//deserialization
MySerializer.MyDTO obj = (MySerializer.MyDTO)
   MySerializer.instance.deserialize(
      origString,
      MySerializer.MyDTO.class
   );

//serialization
String newString = MySerializer.instance.serialize(obj);
System.assertEquals(origString, newString);
```