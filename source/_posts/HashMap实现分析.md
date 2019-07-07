---
title: HashMap实现分析
date: 2019-07-07 20:32:58
categories: 
- 源码分析
tags: [数据结构,源码分析]
---

摘要
1.HashMap实现时用到的数据结构
2.HashMap实现的原理
3.重写equals方法需要同时重写hashCode方法的原因


## 一、HashMap实现时用到的数据结构
###哈希表
1.什么是哈希表
###链表
###红黑树

## 二、HashMap的实现原理
###1.存储结构是什么样的
java7以前采用数组+链表的形式,数组用来实现哈希表，链表用来解决哈希冲突，在java8中，对于节点数大于8的链表，将使用红黑树代替链表来存储元素。这样有什么好处?

HashMap中含有一个Map.Entry类型的数组table，用来存放元素。也就是说table数组的元素是Map.Entry类的实现类
```java
transient Node<K,V>[] table //Node<K,V> 实现了 Map.Entry接口
```
```java
static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;
    final K key;
    V value;
    Node<K,V> next; //下一个节点
    public final int hashCode() {
        return Objects.hashCode(key) ^ Objects.hashCode(value);
    }
    public final boolean equals(Object o) {
        if (o == this)
            return true;
        if (o instanceof Map.Entry) {
            Map.Entry<?,?> e = (Map.Entry<?,?>)o;
                if (Objects.equals(key, e.getKey()) &&
                    Objects.equals(value, e.getValue()))
            return true;
        }
        return false;
    }
}
```

###2.如何构建哈希表
HashMap提供了四种构造函数，如果用户没有传递initialCapacity和loadFactor这两个参数，会使用默认值initialCapacity=16、loadFactor=0.75f

构造函数中对initialCapacity和loadFactor进行了数值校验，核心函数是```tableSizeFor```
```java
public HashMap(int initialCapacity, float loadFactor) {
    if (initialCapacity < 0)
        throw new IllegalArgumentException("Illegal initial capacity: " +
        initialCapacity);
        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;
        if (loadFactor <= 0 || Float.isNaN(loadFactor))
            throw new IllegalArgumentException("Illegal load factor: " +
            loadFactor);
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }
```

```tableSizeFor```通过这个函数获得了一个2的整数次幂的容量值。
```java
//返回一个比cap大且是2的幂次的整数，如cap=10，返回2^4=16。
//这个算法的原理是什么？
static final int tableSizeFor(int cap) {
    int n = cap - 1;
    n |= n >>> 1;
    n |= n >>> 2;
    n |= n >>> 4;
    n |= n >>> 8;
    n |= n >>> 16;
    return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
}
```
通过分析构造函数，发现此时并没有创建存储元素的数组，只是再为创建数组初始化了一些参数

###3.HashMap的容量值为什么是2的整数次幂
###4.如何计算元素的hash
###5.哈希冲突的处理方法
###6.容器如何动态扩容
###7.如何将元素放入容器
###8.如何从容器中取出元素
###9.装载因子默认为0.75的原因

## 三、重写equals方法需要同时重写hashCode方法的原因


## 参考文献
[HashMap实现原理及源码分析](https://www.cnblogs.com/chengxiao/p/6059914.html)
[HashMap实现原理及源码分析(Java 8)](https://www.cnblogs.com/yangming1996/p/7997468.html)