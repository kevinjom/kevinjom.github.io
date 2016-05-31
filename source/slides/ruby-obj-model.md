title: Introduction to Ruby Object Model
author:
  name: kevinjom
  twitter: kevinjom
  url: http://kevinjom.github.io
theme: jdan/cleaver-retro
controls: false
style: style.css
output: ruby-object-model.html

--

### Introduction to
# Ruby Object Model

--

### In Ruby

## Everything is an object

--

### Everything is an object

## Object
## =
## State + Behaviour

--

### Everything is an object

## Object
## =
## instance variable + method 

--
```ruby
class Animal 
  def name=(name)
    @name = name
  end

  def name
    @name
  end

  def age
    18
  end
end
```

--

```ruby
dog=Animal.new       #  <Animal:0x007ff8ca4d06a0>
dog.name= 'wangcai'
dog.name    # 'wangcai'

dog.class          #  Animal
dog.object_id     # 70353261331280

Animal.class     #  Class
Animal.object_id       #  70353257040020
```

--

## How does object look like inside Ruby

--

# Object

--

```c
struct RObject {
    struct RBasic basic;
    union {
	struct {
	    long numiv;
	    VALUE *ivptr;
            struct st_table *iv_index_tbl;
	} heap;
	VALUE ary[ROBJECT_EMBED_LEN_MAX];
    } as;
};
```

--

```c
struct RBasic {
    VALUE flags;
    const VALUE klass;
}
```

--

```c
struct RObject {
    const VALUE klass;
    VALUE *ivptr;
};
```

--


