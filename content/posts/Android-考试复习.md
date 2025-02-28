---
title: Android 考试复习
date: 2019-06-22 22:27:59
tags:
categories:
- 专业课
---



判断题(20分)  
单项选择题(30分)  
编程题(40分)  
论述题(10分)   

<!--more-->

###### 需要权限的操作

1. 网络权限 

   ```xml
   在 AndroidManifest.xml 添加
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
   ```

2. 外存储**公共**空间 

   ```xml
   manifest 中声明外存储写入权限
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

   注意：  
   Internal Storage (内存储)：  **无需声明权限**，其他应用无法访问的应用程序的独立空间。文件随应用删除而删除，空间有限，放应用必须文件  

   External Storage：   

   + 外存储**私有**空间: **无需声明权限**，随应用卸载删除，放普通文件、缓存文件。挂载到：`/mnt/sdcard/android/data/packname/files`
   + 外存储**公共**空间: **需声明权限**，Android公共目录、音乐、图片等等。挂载到：挂载到:`/mnt/sdcard/`


​    

###### 启动activity及传参的方法

+ `Intent intent = new Intent(this, SecondActivity.class)`
+ `intent.putExtra("value", "dafadfadfa")`
+ `startActivity(intent)`
+ `String value = getIntent().getStringExtra("value")`

```java
//MainActivity中

Intent intent = new Intent(this, SecondActivity.class);  //（上下文环境, 目的Activity）
intent.putExtra("value", "dafadfadfa");   //在第一个页面以 键值对 将数据装进Intent   
startActivity(intent);   //startActivity方法

//--------------------------------------------------------------

//SecondActivity中
...
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_sec);
    String value = getIntent().getStringExtra("value");  //在第二个页onCreate()面拿到数据 
}
...
```



###### Activity的主要生命周期回调函数

![](https://developer.android.google.cn/images/activity_lifecycle.png)

Activity 生命周期回调方法汇总表

| 方法          | 说明                                                         | 是否能事后终止？ | 后接                           |
| ------------- | ------------------------------------------------------------ | ---------------- | ------------------------------ |
| `onCreate()`  | 首次创建 Activity 时调用。 您应该在此方法中执行所有正常的静态设置 — 创建视图、将数据绑定到列表等等。 系统向此方法传递一个 Bundle 对象，其中包含 Activity 的上一状态，不过前提是捕获了该状态。始终后接 `onStart()`。 | 否               | `onStart()`                    |
| `onRestart()` | 在 Activity 已停止并即将再次启动前调用。始终后接 `onStart()` | 否               | `onStart()`                    |
| `onStart()`   | 在 Activity 即将对用户可见之前调用。如果 Activity 转入前台，则后接 `onResume()`，如果 Activity 转入隐藏状态，则后接 `onStop()`。 | 否               | `onResume()`  或 `onStop()`    |
| `onResume()`  | 在 Activity 即将开始与用户进行交互之前调用。 此时，Activity 处于 Activity 堆栈的顶层，并具有用户输入焦点。始终后接 `onPause()`。 | 否               | `onPause()`                    |
| `onPause()`   | 当系统即将开始继续另一个 Activity 时调用。 此方法通常用于确认对持久性数据的未保存更改、停止动画以及其他可能消耗 CPU 的内容，诸如此类。 它应该非常迅速地执行所需操作，因为它返回后，下一个 Activity 才能继续执行。如果 Activity 返回前台，则后接 `onResume()`，如果 Activity 转入对用户不可见状态，则后接 `onStop()`。 | **是**           | `onResume()`  或 `onStop()`    |
| `onStop()`    | 在 Activity 对用户不再可见时调用。如果 Activity 被销毁，或另一个 Activity（一个现有 Activity 或新 Activity）继续执行并将其覆盖，就可能发生这种情况。如果 Activity 恢复与用户的交互，则后接 `onRestart()`，如果 Activity 被销毁，则后接 `onDestroy()`。 | **是**           | `onRestart()` 或 `onDestroy()` |
| `onDestroy()` | 在 Activity 被销毁前调用。这是 Activity 将收到的最后调用。 当 Activity 结束（有人对 Activity 调用了 `finish()`），或系统为节省空间而暂时销毁该 Activity 实例时，可能会调用它。 您可以通过 `isFinishing()` 方法区分这两种情形。 | **是**           | 无                             |



###### LinearLayout的基本布局方法；基本控件属性，高宽，比重等

+ layout_width,layout_height 宽高：`match_parent(匹配父容器)`，`wrap_content(自适应)`
- android:orientation：LinearLayout方向 : `vertical` , `horizontal`
- android:layout_gravity ：**相对于**该控件的**父组件**，控件本身的显示位置。
  仅在LinearLayout内有效，受android:orientation属性影响
  `bottom` , `center`
- android:gravity：控件内**内容**的显示位置
- android:layout_weight：比重，android:orientation **相应方向的值需设为0dp**
  `android:layout_width="0dp" android:layout_weight="1"`



###### 在Activity中获取布局控件的方法

`findViewById()`:基于ID名称获取组件

```java
public class MainActivity extends AppCompatActivity {
    private EditText editTextUserName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        editTextUserName = findViewById(R.id.act_main_editText_username);
        ...
```



###### 常用事件回调接口

2种实现监听的方法

- 匿名内部类
- lambda表达式 (set language level to 8)

`View.OnClickListener: onClick()` : 点击监听回调函数

```java
//onCreate()中
buttonSubmit = findViewById(R.id.act_main_button_submit);
//匿名内部类
buttonSubmit.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        String string = editTextUserName.getText().toString();
        textViewUserName.setText(string);
    }
});

//lambda表达式
buttonSubmit.setOnClickListener(v -> {
    String string = editTextUserName.getText().toString();
    textViewUserName.setText(string);
});
```



`EditText: TextChangedListener` : 文本变化监听函数

```java
//onCreate()中
editTextNameChange = findViewById(R.id.act_main_editText_change);
//匿名内部类
editTextNameChange.addTextChangedListener(new TextWatcher() {
    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		//变化前
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        //变化时
        textViewNamechange.setText(s);
    }

    @Override
    public void afterTextChanged(Editable s) {
		变化后
    }
});
```

`View.OnFocusChangeListener: onFocusChange()`  
`View.OnTouchListener: onTouch()`  
`View.OnKeyListener: onKey()`  



###### 基本控件及属性

???



###### 理解MVVM设计模式，以及在Android中的应用

**View**  
 View层做的就是和UI相关的工作，我们只在XML和Activity或Fragment写View层的代码，View层不做和业务相关的事，也就是我们的Activity 不写和业务逻辑相关代码，也不写需要根据业务逻辑来更新UI的代码，因为更新UI通过Binding实现，更新UI在ViewModel里面做（更新绑定的数据源即可）
**简单的说：View层不做任何业务逻辑、不涉及操作数据、不处理数据、UI和数据严格的分开**。

**ViewModel**  
ViewModel层做的事情刚好和View层相反，ViewModel 只做和业务逻辑和业务数据相关的事，不做任何和UI、控件相关的事，ViewModel 层不会持有任何控件的引用，更不会在ViewModel中通过UI控件的引用去做更新UI的事情。

**Model**   
Model 的职责很简单，基本就是实体模型（Bean）同时包括Retrofit 的Service 





###### 基于键值对保存数据的接口及方法 (SharedPreferences 接口)

[link](<https://github.com/zhanyeye/android-examples/tree/master/example11/src/main/java/com/example/example11/util>)

Saving Key-Value Sets: 

自定义application，暴露获取application对象的静态方法 

```java
public class MyApplication extends Application {
    private static MyApplication instance;
    public static MyApplication getInstance() {
        return instance;
    }
    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }
}
```

修改 AndroidManifest [配置](<https://github.com/zhanyeye/android-examples/blob/master/example11/src/main/AndroidManifest.xml>)启动自定义application  
`android:name=".util.MyApplication"`

创建 SharedPreferences 操作工具类

```java
/**
 * 有则直接使用，没有则创建名为为pre_my的XML配置文件
 * 位置data\data\packagename\shared_prefs
 * 声明使用范围
 */
public class SharedPreferencesUtils {
    private static SharedPreferences sf = create();
    private static final String PRE_FILE = "pre_my";
    private static final String MYEDIT = "myedit";

    /**
     * 封装SharedPreferences的构建过程，对外仅暴露允许修改的方法
     * @return
     */
    private static SharedPreferences create() {
        return MyApplication.getInstance()
                .getSharedPreferences(PRE_FILE, Context.MODE_PRIVATE);
    }

    public static void putMyedit (String myedit) {
        sf.edit().putString(MYEDIT, myedit).apply();
    }

    public static String getMyedit() {
        return sf.getString(MYEDIT, "");
    }

}

```

在activity中将输入写入文件

```java
// 在Main_Activity.java 中
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    editText = findViewById(R.id.act_main_edittext);
    textView = findViewById(R.id.act_main_textView);
    button = findViewById(R.id.act_main_button);
    // 获取值，没有默认值为空
    textView.setText(SharedPreferencesUtils.getMyedit());

    button.setOnClickListener(v -> {
        SharedPreferencesUtils.putMyedit(editText.getEditableText().toString());
    });
}
```



###### 了解ViewModel中声明可观测数据，并在布局绑定的方法

 [link](<https://github.com/zhanyeye/android-examples/tree/master/example12/src/main/java/com/example/example12>)

 在项目gradle配置中，启动dataBinding

```json
dataBinding {
        enabled = true
}
```

添加整合了viewmodel livedata 的依赖lifecycle-extensions

```
def lifecycle_version = "2.0.0"
// ViewModel and LiveData
implementation "androidx.lifecycle:lifecycle-extensions:$lifecycle_version"
```

+ **官方推荐一个activity对应绑定一个ViewModel**



创建实体类

创建自定义viewmodel类

声明 `页面数据绑定`/`生命周期绑定`的MutableLiveData类型数据

创建修改方法，在子线程中修改数据

+ `setValue()`  在主线程 中更新数据 
+ `postValue()`  在子线程 中更新数据 : **自动通知主线程修改**
+ `getValue()`

```java
public class MainViewModel extends AndroidViewModel {
    private static final String TAG = "MainViewModel";
    // 将预在页面绑定的数据，声明为与页面生命周期绑定的MutableLiveData可变类型
    // 可以想象为一个能够绑定到视图页面的容器
    public MutableLiveData<User> userLiveData = new MutableLiveData<>();

    /**
     * 必须声明的构造函数
     * 自动注入application对象，便于后期使用
     * @param application
     */
    public MainViewModel(@NonNull Application application) {
        super(application);
        User user = new User("BO");
        userLiveData.setValue(user); //在主线程 中更新数据 
    }

    /**
     * 在子线程中异步操作修改绑定数据，而非主线程
     * 因此必须使用postValue()方法，自动通知主线程修改
     */
    public void change() {
        new Thread(() -> {
            try {
                Thread.sleep(2000);
                User u = userLiveData.getValue();
                u.name = "SUN";
                // 也可重新重新创建一个user对象，置入
                userLiveData.postValue(u);
            } catch (InterruptedException e) {
            }
        }).start();
    }
}

```

修改layout文件，添加数据绑定标签`<data><variable/></data>`

绑定自定义的ViewModel类

在控件，通过表达式绑定数据，或方法 

双向绑定 `@={}`

**对象中的属性改变时，更新不会通知**

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout>
    <data>
        <variable
            name="mianVM"
            type="com.example.example12.viewmodel.MainViewModel" />
    </data>
    <LinearLayout 
        ...
        tools:context=".MainActivity">

        <TextView
            ...
            android:text="@{mianVM.userLiveData.name}" />
        
        <!-- VM方法不能耦合view对象:vm 不能绑定组件，应为可能已经被销毁了 -->
        <Button
            android:onClick="@{() -> mianVM.change()}"
            android:text="异步改变值" />
        
        <!-- 直接调用activity中的方法 -->
        <Button
            ...
            android:onClick="onButtonClick"
            android:text="To SecActivity" />

    </LinearLayout>
</layout>
```

修改activity代码，获取自定义动态创建的binding对象，获取自定义viewmodel对象

将vm绑定到UI页面

将绑定数据绑定到activity生命周期

+ Activity 的`onCreate()` 中基于layout文件生成绑定对象 (setContentView 删去)

+ 绑定类会基于 layout 中生成的变量,自动生成 getter/setter 方法

+ 绑定自定义的 ViewModel 类 ：`binding.setMianVM(mainViewModel);`

+ 将绑定数据，与当前activity生命周期绑定：`binding.setMianVM(mainViewModel);` 如，当数据改变时，且activity可见时，自动更新页面

+ activity有处理UI，跳转更新等操作，业务逻辑操作由vm负责

  > vm 不能绑定组件，应为可能已经被销毁了

```java
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 取消默认调用setContentView()方法代码：设置该activity 要渲染的布局UI

        /**
         * 必须先在layout中使用data标签声明变量
         * 才能基于layout文件的命名，动态自动生成ActivityMainBinding类
         * The Data Binding Library generates binding classes that are used to access the layout's variables and views. 
         */
        ActivityMainBinding binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
        // 必须通过工具类获取VM对象，不能手动创建
        MainViewModel mainViewModel = ViewModelProviders.of(this).get(MainViewModel.class);
        // 基于layout中声明的变量，自动生成属性变量的getter/setter方法
        binding.setMianVM(mainViewModel);
        /**
         * 将绑定数据，与当前activity生命周期绑定
         * 例如，当数据改变时，且activity可见时，自动更新页面
         */
        binding.setLifecycleOwner(this);
    }
    /**
     * activity有处理UI，跳转更新等操作，业务逻辑操作由vm负责
     * @param view
     */
    public void onButtonClick(View view) {
        Log.i(TAG, "onButtonClick: ");
        Intent intent = new Intent(this, SecActivity.class);
        startActivity(intent);
    }
}
```



###### 了解侧滑的实现方法



ItemTouchHelper[使用步骤](https://blog.csdn.net/u014133119/article/details/80942932#commentBox)：

> 自定义callback继承 ItemTouchHelper.Callback -> 在内部写一个数据操作接口 -> 重写触发方法调用接口 -> 适配器实现数据操作接口，重新方法 -> acctivity 中附着 recyclerview

1. 创建 `MyCallback` 继承 `ItemTouchHelper.Callback` 

2. 把数据操作部分抽象成一个接口 `AdapterCallback`,这个接口可以写在 `MyCallback` 内

   > 因为`ItemTouchHelper`在完成触摸的各种动作后，就要对`Adapter`的数据进行操作，比如侧滑删除操作

3. 自定义 adapter 实现接口`MyCallback.AdapterCallback`, 重写相关方法

4. 在`MainActivity`中

   ```java
   ItemTouchHelper helper = new ItemTouchHelper(new MyCallback(adapter));
   helper.attachToRecyclerView(recyclerView);
   ```

具体实现：

MyCallback 及内部接口 AdapterCallback

```java
//MyCallback 及内部接口 AdapterCallback
public class MyCallback extends ItemTouchHelper.Callback {
    private static final String TAG = "MyCallback";
    private AdapterCallback adapterCallback;

    public interface AdapterCallback { //数据操作接口
        void remove(int position);
    }

    public MyCallback(AdapterCallback adapterCallback) {
        this.adapterCallback = adapterCallback;
    }

    /**
     * 该方法返回一个整数，用来指定拖拽和滑动在哪个方向是被允许的。
     * 在其中使用makeMovementFlags(int dragFlags, int swipeFlags)返回，
     * 该方法第一个参数用来指定拖动，第二个参数用来指定滑动。
     * ItemTouchHelper.UP  //滑动拖拽向上方向
     * ItemTouchHelper.DOWN//向下
     * ItemTouchHelper.LEFT//向左
     * ItemTouchHelper.RIGHT//向右
     * ItemTouchHelper.START//依赖布局方向的水平开始方向
     * ItemTouchHelper.END//依赖布局方向的水平结束方向
     *
     * @param recyclerView
     * @param viewHolder
     * @return
     */
    @Override
    public int getMovementFlags(@NonNull RecyclerView recyclerView, @NonNull RecyclerView.ViewHolder viewHolder) {
        // Log.i(TAG, "" + "getMovementFlags");
        //允许上下的拖动
        int dragFlags = ItemTouchHelper.UP | ItemTouchHelper.DOWN;
        //只允许从右向左侧滑
        int swipeFlags = ItemTouchHelper.LEFT;
        return makeMovementFlags(0, swipeFlags);
    }

    /**
     * onMove方法是拖拽的回调，参数viewHolder是拖动的Item，target是拖动的目标位置的Item,
     * 该方法如果返回true表示切换了位置，反之返回false。
     *
     * @param recyclerView
     * @param viewHolder
     * @param target
     * @return
     */
    @Override
    public boolean onMove(@NonNull RecyclerView recyclerView, @NonNull RecyclerView.ViewHolder viewHolder, @NonNull RecyclerView.ViewHolder target) {

        return false;
    }

    /**
     * onSwiped方法为Item滑动回调，viewHolder为滑动的item，direction为滑动的方向。
     *
     * @param viewHolder
     * @param direction
     */
    @Override
    public void onSwiped(@NonNull RecyclerView.ViewHolder viewHolder, int direction) {
        switch (direction) {
            case ItemTouchHelper.LEFT:
                adapterCallback.remove(viewHolder.getAdapterPosition());
        }

    }
}

```

自定义适配器并实现操作接口

```java
//自定义适配器并实现操作接口
public class MainAdapter extends RecyclerView.Adapter<MainAdapter.MyViewHolder> implements MyCallback.AdapterCallback {
    private static final String TAG = "MainAdapter";
    private List<News> news;
    public MainAdapter(List<News> news) {
        this.news = news;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recyclerview_news, parent, false);
        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
        holder.title.setText(news.get(position).title);
        holder.suttitle.setText(news.get(position).subtitle);
        holder.pic.setImageResource(R.mipmap.ic_launcher);
    }

    @Override
    public int getItemCount() {
        return news.size();
    }

    @Override
    public void remove(int position) {
        news.remove(position);
        // 指定通知可提高渲染效率，同时支持动画
        notifyItemRemoved(position);
    }

    static class MyViewHolder extends RecyclerView.ViewHolder {
        TextView title;
        TextView suttitle;
        ImageView pic;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            title = itemView.findViewById(R.id.news_title);
            suttitle = itemView.findViewById(R.id.news_subtitle);
            pic = itemView.findViewById(R.id.news_pic);
        }
    }
}

```

MainActivity配置

```java
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    private RecyclerView recyclerView;
    private MainAdapter adapter;
    private SwipeRefreshLayout swipe;
    private List<News> news = listNews();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        recyclerView = findViewById(R.id.act_main_recyclerview);
        // 指定一个默认的布局管理器
        RecyclerView.LayoutManager mLayoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(mLayoutManager);
        // 指定item插入/移除动画
        DefaultItemAnimator animator = new DefaultItemAnimator();
        // 包含默认的操作动画事件，也可自定义动画时间
        animator.setRemoveDuration(500);
        animator.setMoveDuration(500);
        recyclerView.setItemAnimator(animator);
        // 指定item分割线
        recyclerView.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        // 指定适配器
        adapter = new MainAdapter(news);
        recyclerView.setAdapter(adapter);

        ItemTouchHelper helper = new ItemTouchHelper(new MyCallback(adapter));
        helper.attachToRecyclerView(recyclerView);

        swipe = findViewById(R.id.act_third_swipe);
        swipe.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                //模拟耗时操作，子线程禁止直接修改主线程控件属性
                new Handler().postDelayed(() -> {
                    //取消刷新动画
                    swipe.setRefreshing(false);
                    news.add(0, new News(1, "阿根廷VS波黑" + news.size(), "小组赛F组 阿根廷VS波黑"));
                    // 指定通知可提高渲染效率，同时支持动画
                    adapter.notifyItemInserted(0);
                    recyclerView.scrollToPosition(0);
                }, 500);
            }
        });
    }

    private List<News> listNews() {
        List<News> news = new ArrayList<>();
        News n1 = new News(1, "阿根廷VS波黑", "小组赛F组 阿根廷VS波黑");
        News n2 = new News(2, "法国VS洪都拉斯", "小组赛E组 法国VS洪都拉斯");
        News n3 = new News(3, "瑞士VS厄瓜多尔", "小组赛E组 瑞士VS厄瓜多尔");
        news.add(n1); news.add(n2); news.add(n3);
        return news;
    }
}
```



######  Menu的基本使用方法




创建menu资源目录; 创建menu布局文件; 设置item title，icon等属性: [link](<https://github.com/zhanyeye/android-examples/blob/master/example08/src/main/res/menu/menu.xml>)

+ app:showAsAction属性: always, collapseActionView, ifRoom, never, withText

重写activity onCreateOptionsMenu()方法，加载menu布局 [link](<https://github.com/zhanyeye/android-examples/blob/master/example08/src/main/java/com/example/example08/MainActivity.java>)

```java
    ...
    /**
     * 重写，加载menu布局
     * @param menu
     * @return
     */
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu, menu);
        return true;
    }
```

重写activity onOptionsItemSelected()方法，监听item点击事件 [link](<https://github.com/zhanyeye/android-examples/blob/master/example08/src/main/java/com/example/example08/MainActivity.java>)

```java
    ...
    /**
     * 重写，监听menu点击事件
     * @param item
     * @return
     */
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        String msg = "";
        switch (item.getItemId()) {
            case R.id.menu_add:
                msg = "add";
                break;
            // 点击左箭头，返回，即关闭当前activity
            case android.R.id.home:
                msg = "home";
                finish();
            case R.id.menu_send:
                msg = "send";
                break;
            case R.id.menu_edit:
                msg = "edit";
                break;
            case R.id.menu_del:
                msg = "delete";
                break;
        }
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
        return super.onOptionsItemSelected(item);
    }
    ...
```





###### 了解通知的实现方法

[link](https://github.com/zhanyeye/android-examples/blob/master/example18/src/main/java/com/example/example18/MainActivity.java)

构造Notification，声明必须属性

```java
NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "default");
// 通知必须包含：图标，标题，文本内容
builder.setSmallIcon(R.mipmap.ic_launcher);
builder.setContentTitle(editText.getText().toString());
builder.setContentText(editText2.getText().toString());
// 设置提醒方法，震动、铃声等
builder.setDefaults(Notification.DEFAULT_ALL);
// 读取后是否自动在通知栏删除
builder.setAutoCancel(true);
```

创建PendingIntent对象，封装点击通知intent

```java
// 当点击通知时的执行
Intent intent = new Intent(this, ResultActivity.class);
intent.putExtra("title", editText.getText().toString());
intent.putExtra("text", editText2.getText().toString());
// 预处理intent，即延迟执行的intent
PendingIntent pIntent = PendingIntent.getActivity(this,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT);  // 更新当前通知内容，没有通知则创建
builder.setContentIntent(pIntent);
NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
```

基于版本构造NotificationChannel

```java
//8.0 以后需要加上channelId 才能正常显示
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
    String channelId = "default";
    String channelName = "默认通知";
    manager.createNotificationChannel(new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH));
}
```

发送通知

```java
// 当发送ID相同的通知时，基于Pending设置，决定通知显示方法
manager.notify(count, builder.build());
count++;
```



##### 编程

###### 点击按钮，将输入框中的值，赋值给输出控件

```java
private EditText editTextUserName;
private Button buttonSubmit;
private TextView textViewUserName;

------------------------------------
//onCreate()中
editTextNameChange  =findViewById(R.id.act_main_editText_change);
textViewUserName = findViewById(R.id.act_main_textView_username);
buttonSubmit = findViewById(R.id.act_main_button_submit);
//匿名内部类
buttonSubmit.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        String string = editTextUserName.getText().toString();
        textViewUserName.setText(string);
    }
});
```



###### 构造一个带点击实现的单项对话框

单项???????

```java
// 单选按钮组
AlertDialog.Builder dialog3 = new AlertDialog.Builder(this);
dialog3.setTitle("水果");
dialog3.setItems(arrayFruit, new DialogInterface.OnClickListener() {
    // 传入的which为被选中的位置
    @Override
    public void onClick(DialogInterface dialog, int which) {
        Toast.makeText(MainActivity.this, arrayFruit[which], Toast.LENGTH_SHORT).show();
    }
});
dialog3.show();
```

如果是单选就不看这个了

```
AlertDialog.Builder dialog2 = new AlertDialog.Builder(this);
dialog2.setTitle("删除");
dialog2.setMessage("确定删除吗?");
// 确认按钮回调
dialog2.setPositiveButton("确定", new DialogInterface.OnClickListener() {
	@Override
    public void onClick(DialogInterface dialog, int which) {
    }
});
// 取消回调
dialog2.setNegativeButton("取消", new DialogInterface.OnClickListener() {
	@Override
	public void onClick(DialogInterface dialog, int which) {
    	dialog.dismiss();
    }
});
// 中间回调
dialog2.setNeutralButton("详细内容", new DialogInterface.OnClickListener() {
	@Override
	public void onClick(DialogInterface dialog, int which) {
    }
});
dialog2.show();
```



###### 创建一个RecyclerView.Adapter，自定义ViewHolder，实现基于给定数据与布局信息，渲染RecyclerView

```java
public class MainAdapter extends RecyclerView.Adapter<MainAdapter.MyViewHolder> {
    private static final String TAG = "MainAdapter";
    private List<News> news;

    public MainAdapter(List<News> news) {
        this.news = news;
    }

    /**
     * 基于指定样式，渲染item，并将item对象绑定到viewholder
     * 当回收缓存区没有VH时，回调
     * 基于布局创建item对象，创建VH封装item对象，返回VH以复用
     * 因此，仅会回调有限次数。不同系统版本，不同屏幕尺寸等等均不同
     *
     * @param parent
     * @param viewType
     * @return
     */
    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Log.i(TAG, "onCreateViewHolder");
        // 每一个item对象
		//将一个xml布局文件转换成一个View
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recyclerview_news, parent, false);
        // 由VM持有
        return new MyViewHolder(itemView);
    }

    /**
     * 当渲染指定位置item时，从回收缓存区注入一个相同布局类型的VH，以及item的位置
     * 从vm中获取持有的控件对象，将指定集合位置的数据加载到控件，渲染
     *
     * @param holder
     * @param position
     */
    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
        Log.i(TAG, "onBindViewHolder: " + position + "/" + news.get(position).title);
        holder.title.setText(news.get(position).title);
        holder.suttitle.setText(news.get(position).subtitle);
        // 模拟图片
        holder.pic.setImageResource(R.mipmap.ic_launcher);
    }

    // 必须指定初始化时item数量，后期可动态改变
    @Override
    public int getItemCount() {
        return news.size();
    }

    /**
     * VH的作用是保持item view上的控件对象的引用
     * 避免在复用item上反复findViewById
     */
    static class MyViewHolder extends RecyclerView.ViewHolder {
        TextView title;
        TextView suttitle;
        ImageView pic;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            title = itemView.findViewById(R.id.news_title);
            suttitle = itemView.findViewById(R.id.news_subtitle);
            pic = itemView.findViewById(R.id.news_pic);
        }
    }
}
```

