title: 聊聊限流
speaker: 王宁
files: /js/ga.js



<slide class="bg-black-blue aligncenter">
<style>.language-java{color:#fff !important;text-shadow:none !important;}.token.operator{background: none;}</style>

# 聊聊限流 {.text-landing.text-shadow}

By 王宁 {.text-intro}



<slide class="bg-black-blue aligncenter">

## 为什么要限流 {.text-landing.text-shadow}

<slide class="bg-black-blue aligncenter">

:::cta


:高并发:

---

* ## 缓存 {.lightSpeedIn}
* ## 降级 {.lightSpeedIn}
* ## 限流 {.lightSpeedIn}
{.text.build}



<slide class="bg-black-blue aligncenter">

> 限流的目的是为了保护系统不被大量请求冲垮，通过限制请求的速度来保护系统
{.text-quote}


<slide class="bg-black-blue aligncenter">

> 限流的目的是为了保护系统不被大量请求冲垮，通过限制请求的速度来保护系统
{.text-quote}

## 高可用
{.text.build}


<slide class="bg-black-blue aligncenter">

<slide class="bg-black-blue aligncenter">

# 如何做限流 {.heartBeat}
{.text.build}


<slide class="bg-black-blue aligncenter" :class="size-80">


# 控制并发数量
控制同一时刻有多少请求占用资源

----

```java
public class XXXService {

    private final Semaphore permit = new Semaphore(10, true);
    public void process(){
        try{
            permit.acquire();
            //业务逻辑处理
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            permit.release();
        }
    }
}
```


<slide class="bg-black-blue aligncenter">



# 控制访问速率
控制单位时间内有多少请求可以进入

* ##### 计数器 {.heartBeat}
* ##### 漏桶 {.heartBeat}
* ##### 令牌桶 {.heartBeat}
{.text.build}



<slide class="bg-black-blue aligncenter">

:::card {.quote}

## 计数器

> 单位时间内，通过简单计数的方式限制流量。如果一个流量进来，计数器加一，如果超过最大阈值则拒绝请求，当时间过渡时，将计数器还原为0。 {.aligncenter .heartBeat}
{.text.build}

---

![](https://kooup-static.koocdn.com/images/2020/10/29/d0a1ccf8-a9b1-40bd-acf4-6fbbc72b2d16.jpg){.aligncenter .heartBeat}
{.text.build}



<slide class="bg-black-blue aligncenter">

# 问题：计数器算法有什么漏洞？

<slide class="bg-black-blue aligncenter">

:::card {.quote}


<slide class="bg-black-blue aligncenter">

:::card {.quote}

## 滑动窗口

> 滑动窗口，又称rolling window。将单位时间划分为多个小格子，用一个滑动的窗口计算流量。 {.aligncenter .heartBeat}
{.text.build}

---
![](https://kooup-static.koocdn.com/images/2020/10/29/422c99b0-6dc5-4400-a6c9-6f3c7e4a602d.jpg){.aligncenter .heartBeat}
{.text.build}



<slide class="bg-black-blue aligncenter">

:::card {.quote}

## 漏桶

> 水（请求）先进入到漏桶里，漏桶以一定的速度出水，当水流入速度过大会直接溢出，可以看出漏桶算法能强行限制数据的传输速率。 {.aligncenter .heartBeat}
{.text.build}

---
![](https://i.loli.net/2017/08/11/598c905caa8cb.png){.aligncenter .heartBeat}
{.text.build}



<slide class="bg-black-blue aligncenter">

:::card {.quote}

## 令牌桶

> 系统会以一个恒定的速度往桶里放入令牌，如果请求需要被处理，则需要先从桶里获取一个令牌，当桶里没有令牌可取时，则拒绝服务，令牌桶算法通过发放令牌，根据令牌的rate频率做请求频率限制，容量限制等。 {.aligncenter .heartBeat}
{.text.build}

---
![](https://kooup-static.koocdn.com/images/2020/10/29/36f9a698-1770-48b5-a36c-2db3c26c67ed.jpg){.aligncenter .heartBeat}
{.text.build}



<slide class="bg-black-blue">


## RateLimiter  --- Guava

>> RateLimiter基于令牌桶算法，以设定的恒定速率向令牌桶内放置令牌，请求到达时，只有拿到令牌才能执行；

RateLimiter支持预消费

<slide class="bg-black-blue">

#### RateLimiter有两种限流模式

* 稳定模式(SmoothBursty:令牌生成速度恒定，平滑突发限流) `RateLimiter limiter = RateLimiter.create(doublepermitsPerSecond)`

RateLimiter.create(5)表示桶容量为5且每秒新增5个令牌，即每隔200毫秒新增一个令牌；limiter.acquire()表示消费一个令牌，如果当前桶中有足够令牌则成功（返回值为0），如果桶中没有令牌则暂停一段时间，比如发令牌间隔是200毫秒，则等待200毫秒后再去消费令牌，这种实现将突发请求速率平均为了固定请求速率。
* 渐进模式(SmoothWarmingUp:令牌生成速度缓慢提升直到维持在一个稳定值，平滑预热限流) `RateLimiter limiter = RateLimiter.create(doublepermitsPerSecond, long warmupPeriod, TimeUnit unit);`

permitsPerSecond表示每秒新增的令牌数，warmupPeriod表示在从冷启动速率过渡到平均速率的时间间隔。


<slide class="bg-black-blue aligncenter">

# 限流组件的设计


<slide class="bg-black-blue aligncenter">

* # 资源
* # 限流
* # 配置

{.text.build}



<slide class="bg-black-blue aligncenter">

# 限流

```java
public interface Limiter {
    /**
     * 限流的qps
     *
     * @return
     */
    double getQPS();
    /**
     * 尝试获取通过的许可，如果获取不到直接返回false
     *
     * @return
     */
    boolean tryAcquire();
}
```



<slide class="bg-black-blue aligncenter">

# 配置

```java
public class LimiterRule implements Serializable {
    /**
     * 资源名
     */
    private String resource;
    /**
     * 限制qps
     */
    private double qps = -1;
    /**
     * 是否启用
     */
    private boolean enable = true;
}

```



<slide class="bg-black-blue aligncenter">


# 资源  =====>  限流

```java
public interface LimiterFactory {
    /**
     * 根据资源获取限流组件
     *
     * @param resource 资源字符串
     * @return
     */
    Limiter getLimiterByResource(String resource);
}

```



<slide class="bg-black-blue aligncenter">

# 限流实现方式

------

* ### RateLimiter {.bounceIn}
* ### 。。。 {.bounceIn}
{.text.build}


<slide class="bg-black-blue aligncenter">

# 限流  <=====>  配置

------

* ### 初始化 {.bounceIn}
* ### 变更 {.bounceIn}
{.text.build}


-----

<slide class="bg-black-blue aligncenter">

# 配置方式 {.bounceIn}

* ### 字典配置 {.bounceIn}
* ### Apollo {.bounceIn}
* ### zookeeper {.bounceIn}
* ### ... {.bounceIn}
{.text.build}

<slide class="bg-black-blue aligncenter">

```java
/**
 * 限流配置源
 */
public interface LimiterConfigurationSource {
    /**
     * 注册配置更新监听器
     *
     * @param listener
     */
    void addUpdateListener(ConfigurationUpdateListener listener);
    /**
     * 删除配置更新监听器
     *
     * @param listener
     */
    void removeUpdateListener(ConfigurationUpdateListener listener);
    /**
     * 配置监听器。配置更新时会进行回调
     */
    interface ConfigurationUpdateListener {
        /**
         * 更新配置的回调函数
         *
         * @param configuration
         */
        void updateConfiguration(UpdateConfiguration configuration);
    }
    /**
     * 更新的配置信息
     */
    @Data
    class UpdateConfiguration {
        /**
         * 新增的限流规则
         */
        private Collection<LimiterRule> added;
        /**
         * 更新的限流规则
         */
        private Collection<LimiterRule> changed;
        /**
         * 删除的限流规则
         */
        private Collection<LimiterRule> deleted;
    }

}
```

<slide class="bg-black-blue aligncenter">

# 谢谢
