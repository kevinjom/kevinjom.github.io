---
title: Java IO读取速度测试
date: 2012-11-29 23:43:39
tags:
  - java
  - io
  - junit
---

不知道是什么情况，今天喜欢上了看IO这个东东。。回来码了几行简单的不能再简单的代码 ，跑了一把，得了几个 数据 ，放到这里跟大家分享下。。
先把测试的结果截图摆上来欣赏一下：有一点需要说明的是，前四个方法是以字节流的形式读取一个大小为11M左右的rar文件，后面两个 方法是以字符流的形式读取在小在1M~2M之间的一个文本文件~

![](/images/java-io-speed.jpg)

具体每个方法是怎么实现 的，代码简单到了什么程度，常用到了什么程度 。。。。。。
话不多说，元芳，代码在这里，你怎么看？

```java
public class IOSpeedTest {
    private static final String file = "G:\\pt.rar";

    @Test
    public void testWithoutBuf() throws IOException {
        int line = 0;
        FileInputStream in = new FileInputStream(file);
        int bit = -1;
        while ((bit = in.read()) != -1) {
            if (bit == '\n') {
                ++line;
            }
        }
        if (in != null) {
            in.close();
        }
        System.out.println(line);
    }

    @Test
    public void testWithBufferedIn() throws IOException {
        BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
        int line = 0;
        int bit = -1;
        while ((bit = in.read()) != -1) {
            if (bit == '\n') {
                ++line;
            }
        }
        if (in != null) {
            in.close();
        }
        System.out.println(line);
    }

    @Test
    public void testWithFixedBuf() throws IOException {
        int bufSize = 8196;
        FileInputStream in = new FileInputStream(file);
        int line = 0;
        byte[] buf = new byte[bufSize];
        while (in.read(buf) != -1) {
            for (byte element : buf) {
                if (element == '\n') {
                    ++line;
                }
            }
        }
        if (in != null) {
            in.close();
        }
        System.out.println(line);
    }

    @Test
    public void testWithWholeFile() throws IOException {
        FileInputStream in = new FileInputStream(file);
        int line = 0;
        byte[] buf = new byte[file.length()];
        in.read(buf);
        for (byte element : buf) {
            if (element == '\n') {
                ++line;
            }
        }
        if (in != null) {
            in.close();
        }
        System.out.println(line);
    }

    private static final String txt = "G:\\cy.txt";

    @Test
    public void testWithBf() throws IOException {
        BufferedReader bf = new BufferedReader(new InputStreamReader(new FileInputStream(txt)));
        while (bf.readLine() != null) {

        }
    }

    @Test
    public void testWithFixedBf() throws IOException {
        int bufSize = 8196;
        InputStreamReader reader = new InputStreamReader(new FileInputStream(txt));
        char[] buf = new char[bufSize];
        while (reader.read(buf) != -1) {

        }
        reader.close();
    }

}
```

好长时间没有自己写过文章了，今天写这么水的东西出来，求轻喷。。~~
kevin 11/29/2012
