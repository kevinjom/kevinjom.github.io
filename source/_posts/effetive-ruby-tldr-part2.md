---
title: effetive-ruby-tldr-part2
date: 2016-05-18 19:27:16
tags:
  - ruby
  - effetive
  - best-practice
---

## #11. Create namespace by nesting code in Module
- Use modules to create namespece by nesting definiton inside them.
- Mirror you namesapece structure to your dir structure.
- Use `::` to fully qualify a top-level constant.

## #12. Understand the Different Flavors of Equality
- Use `==` to test if two obejcts represent the same value.

```ruby
1 == `1.0` # true
```
- Use `eql?` to test if two objects represent the same value and also the same
  type.

```ruby
1 == `1.0` # false
1 == 1 # true
```

- Use `equal?` to test if two objects are the same object (with same object_id),
  so **never** override this method.

- `===` - `== || =~ || is_a?`

```ruby
'a'==='a' #true -  'a'=='a'
/a/i==='Abc' #0 - /a/i =~ 'Abc'
String==='a' #true - 'a'.is_a? String
```

## #13. Implement Comparison via <=> and the Comparable Module
- Implement object ordering by defining a “<=>” operator and including the Comparable module.
- The “<=>” operator should return nil if the left operand can’t be compared with the right.
- If you implement “<=>” for a class you should consider aliasing eql? to “==”, especially if you want instances to be usable as hash keys. In which case you should also override the hash method. NOTE. `==` does **NOT** test type equity.

## #14. Share Private State Through Protected Methods
- Protected methods can  be called with an explicit receiver from objects of the same class

## #15. Prefer Class Instance Variables to Class Variables

## #16. Duplicate Collections Passed as Arguments Before Mutating Them
- Method arguments in Ruby are passed as references, not values
- The dup and clone methods only create shallow copies.

```ruby
class User
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

u1 = User.new 'kevin'
u2 = Use.new 'others'

arr = [u1, u2]
arr2 = arr.dup

u2.name = 'new name'

arr == arr2 # true

```

- For most objects, Marshal can be used to create deep copies when needed.

```ruby
arr3 = Marshal.load Marshal.dump arr

u2.name = 'new new'

arr == arr3 #false

```

## #17. Use the Array Method to Convert nil and Scalar Objects into Arrays

```ruby
Array(nil)  # []
Array([nil, :a]) # [nil, :a]
Array({a:12,b:323} #[:a, :b]

# Array() - First tries to call Array#to_ary on arg, then Array#to_a.
```

## #18. Consider Set for Efficient Element Inclusion Checking
- `require 'set'` before you use it.

## #19. Know How to Fold Collections with reduce
- Always use a starting value for the accumulator.

```ruby
[1,2,3].reduce(0,:+)  #6
```

- The block given to reduce should always return an accumulator. It’s fine to mutate the current accumulator, just remember to return it from the block”.

```ruby
[1,2,3].reduce({}) do |map, e|
    map[e.to_s] = e
    map
end
```


## #20. Consider Using a Default Hash Value

## #21. Prefer Delegation to Inheriting from Collection Classes

