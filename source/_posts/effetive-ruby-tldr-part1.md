---
title: Effetive Ruby TLDR - part1
date: 2016-05-12 23:10:28
tags:
  - ruby
  - effetive
  - best-practice
---

## “Accustoming Yourself to Ruby”

### #1. Understand What Ruby Considers To Be True
- Every value is `true`expect `false` and `nil`.
- The number `0` is `ture` in Ruby.
- Check if a value is nil with `value#nil?`.

### #2. Treat All Objects As If They Could Be nil
- Only `nil.nil?` returns `true`.
- You can cast a nil to a empty string with `nil.to_s` or to a int with
  `nil.to_i`.

### #3. Avoid Ruby’s Cryptic Perlisms
- Prefer `String#match` to `str =~ `.
- Don't modify global variables unless you must do.

### #4. Be Aware That Constants Are Mutable
- Always `freeze` constant values to prevent them to be mutated.
- To prevent assigning new values to existing constants, freeze the module they
  are defined in.

### #5. Pay attention to runtime warnings
- Use the `-w` CLI option to enable compile and runtime warnings. Or make it
  part of the `RUBYOPT` env variable.


## Classes, Objects and Modules

### #6. Know how ruby build inheritance hierarchies
- Method lookup algo - move right, then go up, that means when you clll a method
  `foo.bar`, you move to the right, find the class of the object `foo`, if you
find `bar` in `foo`'s class, then invoke it, or move to `foo`'s superclass, do
the same thing.
- If no method has been found, `method_missing` will be called with the same
  algo as above.
- Module are classes too. Including modules silently creates singleton classes
  which are inserted into the hierarchy above the including class.
- Class methods are just instance methods of the class's metaclass

### #7. Be Aware of the Different Behaviors of super
- Use `super` to call the overridden method.
- Use `super` with no args and no parentheses is equivalent to passing it all of
  the arguments which were given to the enclosing method.
- Use to `super()` to call overriden method withoug passing any arguments.


### #8. Invoke super When Initializing Sub-classes
- Ruby doesn't automatically call the `initialize` method in the superclass when
  creating objects from a subclass
- Call the overriden `initialize` method explicitly with `super`

### #9. Be Alert for Ruby’s Most Vexing Parse
- Setter method must have a reciever, inside the class that defines it, the
  receiver should be `self`
- Avoid using `self` when call other methods inside a class.

### #10. Prefer Struct to Hash for Structured Data
- When dealing with structured data which doesn’t quite justify a new class
  prefer using Struct to Hash.
- Assign the return value of Struct::new to a constant and treat that constant
  like a class.

#### Demo
```ruby
  User = Struct.new(:name, :age) # User.class = Class
  user = User.new('kevin', 18)
  puts user.name
  user.age = 22
```

