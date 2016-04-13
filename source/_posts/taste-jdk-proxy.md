---
title: jdk动态代理实现原理
date: 2013-09-13 21:33:33
tags:
  - java
  - dynamic proxy
  - proxy
  - source code
---

写在前面:
- 大神和diao炸天的亲请绕道..
- 关于代理模式的概念这里省去,大家可以放鸟尽情搜..
- 关于为什么叫动态代理,个人理解是代理的类是在运行时动态生成的,大家也可以参考网上的理解..
- 文笔很差,所以文字较少,都在代码和注释中..

=======一点不华丽的分割线-------------------------

开门见山,lets go..

java中可以通过jdk提供的 Proxy.newProxyInstance静态方法来创建动态代理对象,下面先来看看这个方法的实现

```java
public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h)
  throws IllegalArgumentException {
  //InvocationHandler不能为空,因为对代理对象的所有方法调用实际上都会委托到InvocationHandler的invoke方法,
  //这个我们后面通过查看产生的代理类的源代码便会一目了然
  if (h == null) {
    throw new NullPointerException();
  }

  //这个是核心的地方,通过提供的ClassLoader和interface列表来产生代理类,具体的实现可以参考getProxyClass这个方法的实现,
  //真正的工作是由sun.misc.ProxyGenerator这个类来完成的,可以google查看具体的逻辑.在我们的程序中通过设置
  //System.setProperty("sun.misc.ProxyGenerator.saveGeneratedFiles", "true")可以查看产生的类文件
  Class cl = getProxyClass(loader, interfaces);

  //因为代理类继承了Proxy类.而Proxy中定义了构造函数protected Proxy(InvocationHandler h),所以可以反射得到Constructer实例
  //创建代理对象
  try {
    Constructor cons = cl.getConstructor(constructorParams);
    return (Object) cons.newInstance(new Object[] { h });
  } catch (NoSuchMethodException e) {
    throw new InternalError(e.toString());
  } catch (IllegalAccessException e) {
    throw new InternalError(e.toString());
  } catch (InstantiationException e) {
    throw new InternalError(e.toString());
  } catch (InvocationTargetException e) {
    throw new InternalError(e.toString());
  }
}

```

下面通过个例子来说明下:
先来定义一个接口,jdk的动态代理基于接口来创建代理类,不能基于类的原因是java不支持多重继承,而代理类都会继承Proxy类(个人理解).


```java
/**
 * Subject
 *
 * @author Kevin Fan
 * @since 2013-9-13 下午2:43:33
 */
public interface Subject {
  void pub(String key, String content);

  String sub(String key);
}
```

再来一个具体的实现,在代理模式中可以叫它的实例可以叫target,这个是真正执行操作的对象

```java
/**
 * SimpleSubject
 *
 * @author Kevin Fan
 * @since 2013-9-13 下午2:45:03
 */
public class SimpleSubject implements Subject {
  private Map<String, String> msg = new ConcurrentHashMap<String, String>();

  public void pub(String key, String content) {
    System.out.println("pub msg: key is " + key + ", content is " + content);
    msg.put(key, content);
  }

  public String sub(String key) {
    if (msg.containsKey(key)) {
      String ret = msg.get(key);
      System.out.println("sub msg: key is " + key + ", result is " + ret);
      return ret;
    }

    return null;
  }

}
```

好,接下来我们来写个动态代理工厂,根据 不同的target来创建动态代理对象

```java
/**
 * SubjectProxyFactory
 *
 * @author Kevin Fan
 * @since 2013-9-13 下午2:47:24
 */
public class SubjectProxyFactory {
  //TODO: cache
  public static Subject getSubject(final Subject realSubject) {
    return (Subject) Proxy.newProxyInstance(realSubject.getClass().getClassLoader(), new Class[] { Subject.class },
        new InvocationHandler() {

        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("\naction before method invocation....");
        Object retVal = method.invoke(realSubject, args);
        System.out.println("action after method invocation....\n");
        return retVal;
        }
        });
  }
}
```

可以看到这是一个简单的实现,只是在真实对象执行前后各打一句信息..

接下来用一个 main函数来把这些结合起来

```java
/**
 * Demo
 *
 * @author Kevin Fan
 * @since 2013-9-13 下午2:50:28
 */
public class Demo {
  public static void main(String[] args) {
    //设置此系统属性,以查看代理类文件
    System.setProperty("sun.misc.ProxyGenerator.saveGeneratedFiles", "true");

    //创建真实对象
    Subject subj = new SimpleSubject();
    subj.pub("name", "kevin.fan");
    subj.sub("name");

    //创建代理对象
    Subject proxy = SubjectProxyFactory.getSubject(subj);
    proxy.pub("hobby", "r&b music");
    proxy.sub("name");
  }
}
```

ok,小手抖一下,走你,看下执行结果


```java
pub msg: key is name, content is kevin.fan
sub msg: key is name, result is kevin.fan


action before method invocation....
pub msg: key is hobby, content is r&b music
action after method invocation....


action before method invocation....
sub msg: key is name, result is kevin.fan
action after method invocation....
```


可以看到在调用代理对象的方法时,添加的额外动作已经生效,接下来我们看下生成的代理类的代码..

```java
import com.aliyun.demo.kevin.coder.lang.proxy.Subject;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.lang.reflect.UndeclaredThrowableException;

//这里很清楚了,代理类继承了Proxy类,并且实现了Proxy.newProxyInstance这个方法中传入的接口

public final class $Proxy0 extends Proxy
implements Subject
{

  //这些方法在下面的static init block中进行初始化
  private static Method m4;
  private static Method m1;
  private static Method m3;
  private static Method m0;
  private static Method m2;

  static
  {
    try
    {
      m4 = Class.forName("com.aliyun.demo.kevin.coder.lang.proxy.Subject").getMethod("sub", new Class[] { Class.forName("java.lang.String") });
      m1 = Class.forName("java.lang.Object").getMethod("equals", new Class[] { Class.forName("java.lang.Object") });
      m3 = Class.forName("com.aliyun.demo.kevin.coder.lang.proxy.Subject").getMethod("pub", new Class[] { Class.forName("java.lang.String"), Class.forName("java.lang.String") });
      m0 = Class.forName("java.lang.Object").getMethod("hashCode", new Class[0]);
      m2 = Class.forName("java.lang.Object").getMethod("toString", new Class[0]);
      return;
    }
    catch (NoSuchMethodException localNoSuchMethodException)
    {
      throw new NoSuchMethodError(localNoSuchMethodException.getMessage());
    }
    catch (ClassNotFoundException localClassNotFoundException)
    {
      throw new NoClassDefFoundError(localClassNotFoundException.getMessage());
    }
  }

  //构造函数,接收一个 InvocationHandler作为参数,这就是为什么Proxy.newProxyInstance方法里可以
  //通过InvocationHandler实例作为参数来反射获取Constructer实例
  public $Proxy0 paramInvocationHandler)
    throws
    {
      super(paramInvocationHandler);
    }

  //下面通过这个来看下代理对象中方法是怎样调用的
  public final String sub(String paramString)
    throws
    {
      try
      {
        //全部是通过调用InvocationHandler的invoke方法,传入对应的方法和参数
        return (String)this.h.invoke(this, m4, new Object[] { paramString });
      }
      catch (Error|RuntimeException localError)
      {
        throw localError;
      }
      catch (Throwable localThrowable)
      {
        throw new UndeclaredThrowableException(localThrowable);
      }
    }

  public final boolean equals(Object paramObject)
    throws
    {
      try
      {
        return ((Boolean)this.h.invoke(this, m1, new Object[] { paramObject })).booleanValue();
      }
      catch (Error|RuntimeException localError)
      {
        throw localError;
      }
      catch (Throwable localThrowable)
      {
        throw new UndeclaredThrowableException(localThrowable);
      }
    }

  public final void pub(String paramString1, String paramString2)
    throws
    {
      try
      {
        this.h.invoke(this, m3, new Object[] { paramString1, paramString2 });
        return;
      }
      catch (Error|RuntimeException localError)
      {
        throw localError;
      }
      catch (Throwable localThrowable)
      {
        throw new UndeclaredThrowableException(localThrowable);
      }
    }

  public final int hashCode()
    throws
    {
      try
      {
        return ((Integer)this.h.invoke(this, m0, null)).intValue();
      }
      catch (Error|RuntimeException localError)
      {
        throw localError;
      }
      catch (Throwable localThrowable)
      {
        throw new UndeclaredThrowableException(localThrowable);
      }
    }

  public final String toString()
    throws
    {
      try
      {
        return (String)this.h.invoke(this, m2, null);
      }
      catch (Error|RuntimeException localError)
      {
        throw localError;
      }
      catch (Throwable localThrowable)
      {
        throw new UndeclaredThrowableException(localThrowable);
      }
    }

}
```
