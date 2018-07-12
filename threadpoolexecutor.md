title: Java线程池的使用和踩坑记录
speaker: 王宁
transition: zoomin
theme: dark
usemathjax: yes
files: /js/ga.js


[slide]

![](http://p8ia113oq.bkt.clouddn.com/7ce4279e64f098736b53539e40a295c4.png)

[slide data-transition="slide"]

# 线程池的使用和踩坑记录

### 王宁

[slide  data-transition="horizontal3d"]

* 线程池用法
* 线程池的应用
  - 复杂业务场景(我的课堂、我的直播)
  - 异步更新缓存
  - 本地生产消费者模式
* 线上应用卡死的排查之路

[slide ]

# 线程池用法

* <span style="font-size: 50px;color:green;"> ThreadPoolExecutor  </span> {:&.bounceIn}

----
<br/>

* <span style="font-size: 50px;"> ScheduledThreadPoolExecutor  </span> {:&.bounceIn}



[slide data-transition="horizontal3d"  style="background-image:url('http://p8ia113oq.bkt.clouddn.com/58c83f909f3c3bdf029d7104fc3d1644.png')"]


# Runnable

```java
public interface Runnable {
    /**
     * When an object implementing interface <code>Runnable</code> is used
     * to create a thread, starting the thread causes the object's
     * <code>run</code> method to be called in that separately executing
     * thread.
     * <p>
     * The general contract of the method <code>run</code> is that it may
     * take any action whatsoever.
     *
     * @see     java.lang.Thread#run()
     */
    public void run();
}
```


[slide data-transition="horizontal3d"]


# Callable

```java
public interface Callable<V> {
    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    V call() throws Exception;
}
```

[slide data-transition="horizontal3d"]

# Future

```java
public interface Future<V> {
    /**Attempts to cancel execution of this task.*/
    boolean cancel(boolean mayInterruptIfRunning);
    /**
     * Returns {@code true} if this task was cancelled before it completed normally.
     */
    boolean isCancelled();
    /**Returns {@code true} if this task completed.*/
    boolean isDone();
    /**
     * Waits if necessary for the computation to complete, and then
     * retrieves its result.
     */
    V get() throws InterruptedException, ExecutionException;
    V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException;
}

public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}

public class FutureTask<V> implements RunnableFuture<V>{
  //....
}
```


[slide ]

# ThreadPoolExecutor

[slide data-transition="cover-circle"]

![](http://p8ia113oq.bkt.clouddn.com/5e5a1ce7090805ed382c262517c5ba57.png)


[slide ]

# 构造函数

```java
public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,
      TimeUnit unit,BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory,
                              RejectedExecutionHandler handler)
```

[slide ]

{:&.bounceIn}

## corePoolSize


>核心线程数。当提交一个任务时，线程池会新建一个线程来执行任务，直到当前线程数等于corePoolSize。

## maximumPoolSize

>线程池中允许的最大线程数。线程池的阻塞队列满了之后，继续提交任务，如果当前的线程数小于maximumPoolSize，则会新建线程来执行任务。

## keepAliveTime

> 线程空闲的时间。线程的创建和销毁是需要代价的。线程执行完任务后不会立即销毁，而是继续存活一段时间。

## threadFactory

> 创建线程的工厂
[slide ]


{:&.moveIn}

## BlockingQueue<Runnable> workQueue

> 用来保存等待执行的任务的阻塞队列

* ArrayBlockingQueue {:&.fadeIn}
* LinkedBlockingQueue
* SynchronousQueue
* PriorityBlockingQueue

<br><br><br>

`线程池大小大于corePoolSize后是先放workQueue还是先扩大线程池大小到maximumPoolSize？`

[slide]
{:&.moveIn}

## RejectedExecutionHandler handler

>线程池的拒绝策略。
>
>所谓拒绝策略，是当向线程池中提交任务时，如果此时线程池中的线程已经饱和了，而且阻塞队列也已经满了，则线程池会选择一种拒绝策略来处理该任务。

<br>
* AbortPolicy：直接抛出异常，默认策略  {:&.fadeIn}
* CallerRunsPolicy：用调用者所在的线程来执行任务；
* DiscardOldestPolicy：丢弃阻塞队列中靠最前的任务，并执行当前任务；
* DiscardPolicy：直接丢弃任务；
* 自定义实现

[slide]
{:&.moveIn}

## allowCoreThreadTimeOut

## prestartAllCoreThreads()
## shutdown()
## shutdownNow()

[slide]

# Executors

[slide]
{:&.moveIn}

### newFixedThreadPool

```java
new ThreadPoolExecutor(nThreads, nThreads,0L, TimeUnit.MILLISECONDS
                                        ,new LinkedBlockingQueue<Runnable>())
```
> 固定大小线程池,无限队列。

<br>

### newSingleThreadExecutor

```java
new ThreadPoolExecutor(1, 1,0L, TimeUnit.MILLISECONDS
                                        ,new LinkedBlockingQueue<Runnable>())
```
> 一个线程（的线程池）,无限队列。

<br/>

## newCachedThreadPool

```java
new ThreadPoolExecutor(0, Integer.MAX_VALUE,60L, TimeUnit.SECONDS
                                        ,new SynchronousQueue<Runnable>())
```
> 缓存的线程池，有多少任务就创建多少线程。线程闲置一分钟自动回收。


[slide ]
# 线程池大小配置 {:&.flexbox.vleft .moveIn}


* CPU密集型
* IO密集型

<br/><br/>


>CPU密集型线程数量 = CPU数量 + 冗余量

<br/>

>IO密集型线程数量 = 正常状态下每秒的请求峰值 * 99%的响应均值(秒) + 冗余量(20%~40%)


[slide ]

# 线程池的应用 {:&.flexbox.vleft .moveIn}

* 复杂业务场景(我的课堂、我的直播) {:&..moveIn}
* 异步更新缓存
* 本地生产消费者模式


[slide data-transition="horizontal3d"]

# 我的课堂业务

```java
/**
 * 我的课堂业务接口
 */
public interface MyCourseService {
    /**
     * 查过某个用户所有的课程数据
     */
    Collection<UserCourseVo> findAllUserCourseByUserId(int userId);
}
/**
 * 用户购课数据
 */
@Data
public class UserProduct {

    private int productId;

    private int userId;

    private int productLine;
}
/**
 * 我的课堂展示数据对象
 */
public class UserCourseVo {
}
```

[slide data-transition="horizontal3d"]

# 处理课程的公共组件

```java
public class MyCourseComponent {

    public Collection<UserProduct> findAllUserProductByUserId(int userId) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }
    /**
     * 处理考研产品
     */
    public Collection<UserCourseVo> disposeKaoYanUserProduct(
                            Collection<UserProduct> userProducts) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }
    /**
     * 处理出国产品
     */
    public Collection<UserCourseVo> disposeChuGuoUserProduct(
                            Collection<UserProduct> userProducts) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }

    /**
     * 处理通用产品线产品
     */
    public Collection<UserCourseVo> disposeTongyongUserProduct(
                            Collection<UserProduct> userProducts) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }

    /**
     * 处理k12产品
     */
    public Collection<UserCourseVo> disposeK12UserProduct(
                            Collection<UserProduct> userProducts) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }

    /**
     * 处理老课堂
     */
    public Collection<UserCourseVo> disposeOldCourseUserProduct(
                            Collection<UserProduct> userProducts) {
        // 省略逻辑代码
        return Lists.newArrayList();
    }

    public static Collection<UserProduct> filter(Collection<UserProduct> userProducts, final int productLine) {
        return Collections2.filter(userProducts, new Predicate<UserProduct>() {

            @Override
            public boolean apply(UserProduct input) {
                return input.getProductLine() == productLine;
            }
        });
    }
}
```

[slide data-transition="horizontal3d"]

# 业务接口实现

```java
public class MyCourseServiceImpl implements MyCourseService {

    private MyCourseComponent c = new MyCourseComponent();

    @Override
    public Collection<UserCourseVo> findAllUserCourseByUserId(int userId) {
        Collection<UserProduct> userProducts = c
                                            .findAllUserProductByUserId(userId);

        Collection<UserCourseVo> result = Lists.newArrayList();

        result.addAll(c.disposeKaoYanUserProduct(filter(userProducts, 1)));

        result.addAll(c.disposeChuGuoUserProduct(filter(userProducts, 2)));

        result.addAll(c.disposeTongyongUserProduct(filter(userProducts, 3)));

        result.addAll(c.disposeK12UserProduct(filter(userProducts, 4)));

        result.addAll(c.disposeOldCourseUserProduct(filter(userProducts, 5)));

        return result;
    }
}
```

[slide data-transition="horizontal3d"]

# 业务接口多线程实现

```java
public Collection<UserCourseVo> findAllUserCourseByUserId(int userId) {
    Collection<UserProduct> userProducts = c.findAllUserProductByUserId(userId);
    Collection<UserCourseVo> result = Lists.newArrayList();
    List<Future<Collection<UserCourseVo>>> futures = Lists.newArrayList();

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeKaoYanUserProduct(filter(userProducts, 1))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeChuGuoUserProduct(filter(userProducts, 2))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeTongyongUserProduct(filter(userProducts, 3))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeK12UserProduct(filter(userProducts, 4))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeOldCourseUserProduct(filter(userProducts, 5))));

    for (Future<Collection<UserCourseVo>> collectionFuture : futures) {
        try {
            result.addAll(collectionFuture.get());
        }
        catch (Exception e) {
            logger.error("处理数据发生异常", e);
        }
    }
    return result;
}
```

[slide data-transition="horizontal3d"]

# 优化后的业务接口多线程实现

```java
public Collection<UserCourseVo> findAllUserCourseByUserId(int userId) {
    Collection<UserProduct> userProducts = c.findAllUserProductByUserId(userId);
    Collection<UserCourseVo> result = Lists.newArrayList();
    List<Future<Collection<UserCourseVo>>> futures = Lists.newArrayList();

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeKaoYanUserProduct(filter(userProducts, 1))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeChuGuoUserProduct(filter(userProducts, 2))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeTongyongUserProduct(filter(userProducts, 3))));

    futures.add(threadPoolExecutor
            .submit(() -> c.disposeK12UserProduct(filter(userProducts, 4))));

    // 在当前用户线程执行逻辑
    Collection<UserCourseVo> oldUserCourseVos = c
            .disposeOldCourseUserProduct(filter(userProducts, 5));
    result.addAll(oldUserCourseVos);

    // 获取异步线程执行结果
    for (Future<Collection<UserCourseVo>> collectionFuture : futures) {
        try {
            result.addAll(collectionFuture.get());
        }
        catch (Exception e) {
            logger.error("处理数据发生异常", e);
        }
    }
    return result;
}

```

[slide data-transition="horizontal3d"]

# 线程池配置

```java

new ThreadPoolExecutor(corePoolSize, maxPoolSize, 300, TimeUnit.SECONDS,
        new SynchronousQueue<>(),MyThreadFactory.create("async-run-business-"),
        new ThreadPoolExecutor.CallerRunsPolicy());

```

[slide]

# 异步更新缓存


[slide data-transition="horizontal3d"]

# 线程池配置

```java

new ThreadPoolExecutor(20, 50, 300, TimeUnit.SECONDS,
        new LinkedBlockingQueue<Runnable>(50),MyThreadFactory.create("async-update-cache-"),
        new ThreadPoolExecutor.DiscardPolicy());

```

[slide]

# 本地生产消费者模式


[slide data-transition="horizontal3d"]

# 业务代码

```java

public class ProductersAndConsumerDemo {
    private static Logger logger = LoggerFactory.getLogger(ProductersAndConsumerDemo.class)
    /**批量查询时的单次数量*/
    private static final int SEARCH_BATH_COUNT = 50;

    private Queue<ProductValue> queue;
    private ThreadPoolExecutor productersThreadPoolTaskExecutor;
    private ThreadPoolExecutor consumersThreadPoolTaskExecutor;
    @Setter
    @Getter
    private volatile boolean productComplete;

    public ProductersAndConsumerDemo() {
        queue = Queues.newLinkedBlockingQueue();
        productersThreadPoolTaskExecutor = createThreadPoolExecutor("producter-", 30, 30);
        consumersThreadPoolTaskExecutor = createThreadPoolExecutor("consumer-", 11, 11);
    }

    public void run() {
        // 启动消费者
        startConsumer();
        // 开始生产数据
        productData();
        // 关闭生产者线程池
        shutdownThreadPoolTaskExecutor(productersThreadPoolTaskExecutor);
        setProductComplete(true);
        // 关闭消费者线程池
        shutdownThreadPoolTaskExecutor(consumersThreadPoolTaskExecutor);
    }

    private void shutdownThreadPoolTaskExecutor(ThreadPoolExecutor threadPoolTaskExecutor) {
        threadPoolTaskExecutor.shutdown();
        try {
            while (!threadPoolTaskExecutor.awaitTermination(1, TimeUnit.SECONDS)) {}
        }
        catch (InterruptedException e) {
            logger.error(e.getMessage(), e);
        }
    }

    private void productData() {
        logger.info("从业务系统生产数据");
        List<Future<List<ProductValue>>> futures = Lists.newArrayList();
        while (true) {
            // 模拟从业务系统分页查询数据
            Collection<Product> objects = findValue();
            addSearchLiveProductToQueueFromFuture(futures);
            if (CollectionUtils.isNotEmpty(objects)) {
                break;
            }
            for (final Product product : objects) {
                Future<List<ProductValue>> future = productersThreadPoolTaskExecutor
                        .submit(() -> findProductValueByProduct(product));
                futures.add(future);
            }
        }
        logger.info("从业务系统生产数据完毕");
    }

    private List<ProductValue> findProductValueByProduct(Product product) {
        // 将Product转换为多个ProductValue
        return Lists.newArrayList();
    }

    private Collection<Product> findValue() {
        // 模拟从业务系统分页查询数据
        return Lists.newArrayList();
    }

    private void addSearchLiveProductToQueueFromFuture(List<Future<List<ProductValue>>> futures) {
        if (CollectionUtils.isNotEmpty(futures)) {
            for (Future<List<ProductValue>> future : futures) {
                try {
                    List<ProductValue> productValues = future.get();
                    if (CollectionUtils.isNotEmpty(productValues)) {
                        queue.addAll(productValues);
                    }
                }
                catch (Exception e) {
                    logger.error(e.getMessage(), e);
                }
            }
            futures.clear();
        }
    }

    private void startConsumer() {
        final Map<String, String> existingDataIdAndSignatureMap = findExistingDataIdAndSignature();
        final Set<String> insertDataIds = Sets.newConcurrentHashSet();
        final CountDownLatch countDownLatch = new CountDownLatch(consumersThreadPoolTaskExecutor.getCorePoolSize() - 1);
        consumersThreadPoolTaskExecutor.submit(() -> {
            try {
                logger.info("clean线程启动,开始等待consumer结束");
                countDownLatch.await();
                logger.info("consumer线程全部结束,开始执行清理任务");
                // .... 利用已存在的数据和新插入的数据清理垃圾数据
                logger.info("clean线程退出");
            }
            catch (Throwable e) {
                logger.error(e.getMessage(), e);
            }
        });
        for (int i = 0; i < consumersThreadPoolTaskExecutor.getCorePoolSize() - 1; i++) {
            consumersThreadPoolTaskExecutor.submit(() -> {
                logger.info("consumer线程启动[{}]", Thread.currentThread().getName());
                try {
                    insertDataIds.addAll(consumerData(existingDataIdAndSignatureMap));
                }
                catch (Throwable e) {
                    logger.error(e.getMessage(), e);
                }
                finally {
                    countDownLatch.countDown();
                    logger.info("consumer线程退出[{}]", Thread.currentThread().getName());
                }
            });
        }
    }

    /**
     * 循环消费数据
     *
     * @param existingDataIdAndSignatureMap 已经存在的数据id和数据签名
     */
    private Set<String> consumerData(Map<String, String> existingDataIdAndSignatureMap) {
        Set<String> insertDataIds = Sets.newHashSet();
        while (!isProductComplete() || !queue.isEmpty()) {
            ProductValue productValue = queue.poll();
            if (productValue != null) {
                String id = productValue.getId();
                try {
                    if (!ObjectUtils.equals(productValue.getSignature(), existingDataIdAndSignatureMap.get(id))) {
                        // 将数据插入到数据源中
                    }
                }
                catch (Throwable e) {
                    logger.error(e.getMessage(), e);
                }
                finally {
                    insertDataIds.add(id);
                }
            } else {
                try {
                    Thread.sleep(100);
                }
                catch (InterruptedException e) {}
            }
        }
        return insertDataIds;
    }

    /**
     * 从数据源中查询已存在的所有数据id和数据签名。
     *
     * @return
     */
    private Map<String, String> findExistingDataIdAndSignature() {
        Map<String, String> result = Maps.newHashMap();
        // 从数据源中查询出的数量，这里省略查询过程
        long totalCount = 1000;
        List<Future<Map<String, String>>> futures = Lists.newArrayList();
        for (long i = 0; i <= totalCount / SEARCH_BATH_COUNT; i++) {
            Future<Map<String, String>> future = consumersThreadPoolTaskExecutor.submit(() -> {
                // 省略查询逻辑
                return Maps.newHashMap();
            });
            futures.add(future);
        }
        for (Future<Map<String, String>> future : futures) {
            try {
                result.putAll(future.get());
            }
            catch (Exception e) {
                logger.error("查询已经存在的数据失败", e);
            }
        }
        return result;
    }
}

```

[slide data-transition="horizontal3d"]

# 线程池配置

```java

new ThreadPoolExecutor(corePoolSize, maxPoolSize, 300,TimeUnit.SECONDS,
        new SynchronousQueue<>(),MyThreadFactory.create("async-run-business-"),
        new ThreadPoolExecutor.CallerRunsPolicy());

```

[slide]

# 线上应用卡死的排查之路 {:&.moveIn}


[slide data-transition="horizontal3d"]

## 依然是刚才的本地生产消费者模式代码

[slide data-transition="horizontal3d"]

![](http://p8ia113oq.bkt.clouddn.com/4943d3441b70b535dac8818e1382cc63.png)



[slide data-transition="horizontal3d"]

# 看个例子

```java
public class ThreadPoolExecutorTest {
    public static void main(String[] args) {
        int threads = 7;
        long time = 0;
        for (;;) {
            ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(threads, threads, 0L, TimeUnit.MILLISECONDS,
                    new LinkedBlockingQueue<>());
            List<Future> futures = Lists.newArrayListWithCapacity(threads);
            for (int i = 0; i < threads; i++) {
                Future future = threadPoolExecutor.submit(() -> {
                    //
                });
                futures.add(future);
            }
            for (Future future : futures) {
                try {
                    future.get();
                }
                catch (Exception e) {}
            }
            if (threadPoolExecutor.getActiveCount() > 0) {
                System.out.println(threadPoolExecutor.getActiveCount() + "======" + time);
            }
            threadPoolExecutor.shutdown();
            time++;
        }
    }
}
```


[slide data-transition="horizontal3d"]

# 再看个例子

```java
public class ThreadPoolExecutorTest1 {

    public static void main(String[] args) {
        int threads = 20;
        final Thread mainThread = Thread.currentThread();
        ThreadPoolExecutor threadPoolExecutor =
            new ThreadPoolExecutor(threads, threads, 0L, TimeUnit.MILLISECONDS,
                new SynchronousQueue<>(), new ThreadPoolExecutor.CallerRunsPolicy());
        Future[] futures = new Future[threads];
        for (;;) {
            for (int i = 0; i < threads; i++) {
                futures[i] = threadPoolExecutor.submit(() -> {
                    if (Thread.currentThread() == mainThread) {
                        System.exit(10);
                    }
                });
            }
            for (Future future : futures) {
                try {
                    future.get();
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```


[slide]

# 谢谢。。。
