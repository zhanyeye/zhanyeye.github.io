---
title: Android 笔记
date: 2019-05-12 08:27:59
tags:
categories:
- 专业课
---





在最前面：
在AS中新建project 时，请勾上：

+ This project will support instant apps
+ `use androidx.* artifacts`    避免版本依赖的问题

<!--more-->

##### Example 01 UI

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/blob/master/example01/src/main/res/layout/activity_main.xml>)

> dp，像素密度，设备屏幕尺寸无关的，描述控件间距离等    (记：device)
> sp，描述**字体**大小    (记：script)
> px，像素，相对的绝对单元，与CSS相似等，图片等  (记：Pixel)



RelativeLayout: 相对布局
LinearLayout: 线性布局
ConstraintLayout: 约束布局

###### Relative Layout & Linear Layout

Linear与Relative布局的区别: 如果层级多的使用RelativeLayout  
![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/img/img/20190607101909.png)

LinearLayout 主要属性

+ android:orientation，LinearLayout方向
  `vertical` ,  `horizontal`
+ android:layout_gravity，**相对于**该控件的**父组件**，控件本身的显示位置。仅在LinearLayout内有效，受android:orientation属性影响
  `bottom` , `center`
+ android:gravity，**控件内**内容的显示位置
+ android:layout_weight，比重，android:orientation **相应方向的值需设为0dp**
  `android:layout_width="0dp"   android:layout_weight="1"`



###### ConstraintLayout

它的出现主要是为了解决布局嵌套过多的问题 [link](https://www.jianshu.com/p/17ec9bd6ca8a)

添加依赖 : 在app/build.gradle文件中添加ConstraintLayout的依赖

```
implementation 'com.android.support.constraint:constraint-layout:1.1.3'
```

与Relative的区别：**仅对相同位置/方向进行相对的约束**
![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/img/img/20190607091106.png)


![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/img/img/20190607092539.png)

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout  ...>
    <TextView
        android:id="@+id/textView"
        android:text="TextView_A"
        ...
        tools:layout_editor_absoluteX="189dp"
        tools:layout_editor_absoluteY="253dp" />

    <TextView
        android:id="@+id/textView2"
        android:text="TextView_B"
        ...
        android:layout_marginBottom="56dp"
        app:layout_constraintBottom_toTopOf="@+id/textView"
        tools:layout_editor_absoluteX="280dp" />

    <TextView
        android:id="@+id/textView3"
        android:text="TextView_C"
		...
        android:layout_marginBottom="72dp"
        app:layout_constraintBottom_toBottomOf="@+id/textView"
        tools:layout_editor_absoluteX="101dp" />
</androidx.constraintlayout.widget.ConstraintLayout>
```



----



##### Example 02 Common Widgets

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/blob/master/example02/src/main/res/layout/activity_main.xml>)

android:id属性，声明组件ID; 后端可以通过ID值获取组件对象

+ @+id，创建一个新ID
+ @id，引用一个ID
+ @，引用资源
+ @android:，引用android下自带资源

```xml
<TextView
    android:id="@+id/textView1"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:text="基本文本显示" />

<ImageView
    android:id="@+id/imageView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:srcCompat="@android:drawable/ic_input_add" />
```

基本输入组件： Buttons；Text Fields；CheckBoxes；Radio Buttons；Toggle Buttons；ImageView；EditText

other: imageview; progressBar; Seekbar; RatingBar;



-----



##### Example 03 UI & Events

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/blob/master/example03/src/main/java/com/example/example03/MainActivity.java>)

> 后端仅基于ID名称获取组件，无法基于不同布局文件区分组件ID，也无法区分组件类型。
> 调用到不是当前布局上组件，运行时才能发现错误。 
> 因此，ID的名称必须能够体现具体的完整的信息，从而避免出错。 
> 较好的命名方法 : 布局类型 _ 布局名称 _ 组件类型 _ 组件名称: `act_main_editText_username`

`findViewById()` : 基于ID名称获取组件



**Android中Callback的设计与使用 ? 理解掌握2种实现监听的方法?**

+ 匿名内部类
+ lambda表达式 (set language level to 8)

`View.OnClickListener: onClick()`

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

`EditText: TextChangedListener `

```java
//onCreate()中
editTextNameChange = findViewById(R.id.act_main_editText_change);
//匿名内部类
editTextNameChange.addTextChangedListener(new TextWatcher() {
    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        textViewNamechange.setText(s);
    }

    @Override
    public void afterTextChanged(Editable s) {

    }
});
```

`View.OnLongClickListener: onLongClick()`
`View.OnFocusChangeListener: onFocusChange()`
`View.OnTouchListener: onTouch()`
`View.OnKeyListener: onKey()`

...

----



##### Example 04 App Resources & R

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example04/src/main/res>)

**各文件目录放置的资源?**

+ drawable : 图片相关的xml文件 (若图标有固定的尺寸，不需要更改，那么drawable更适合)
+ minmap :  图片相关的xml文件   (如果需要变大变小的，有动画的，放在mipmap中能有更高的质量)
+ Layout : 布局文件
+ value : 用于存放显示相的配置数据的定义文件，如strings.xml, style.xml, dimens.xml, arrays.xml, ids.xml等



**R.java的作用与意义 ?**

+ R.java文件自动生成，用来定义Android程序中所有各类型的资源的索引
+ 在java程序中引用资源 `R.resource_type.resource_name`
+ 在XML文件中引用资源 `@[package:]type/name`
  @drawable/icon
  @ 代表的是R.java类
  `drawable` 代表的是`R.java`中的静态内部类 `drawable`
  `/icon`代表静态内部类 `drawable` 中的静态属性 `icon`
  如果访问的是Android系统中自带的文件，则要添加包名“Android:” `android:textColor="@android:color/red"`
+ 往R.java文件中添加一条资源记录
  为组件添加Id属性作为标识:`@id+/name`



自定义资源文件，创建字符串数组资源，添加ListView，引入自定义字符串数组至ListView显示

```xml
自定义资源文件 mysource.xml

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string-array name="courses">
        <item>C语言</item>
        <item>Java语言</item>
        <item>数据库原理</item>
        <item>计算机网络</item>
    </string-array>
</resources>

布局文件 activity_main.xml
<ListView
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:entries="@array/courses"></ListView>
```

定义字符串数组资源，并在代码中通过R调用

```java
button = findViewById(R.id.act_main_button);
```



[Resources Overview](https://developer.android.google.cn/guide/topics/resources/overview.html)  
[Providing Resources](https://developer.android.google.cn/guide/topics/resources/providing-resources.html)  
[Accessing Resources](https://developer.android.google.cn/guide/topics/resources/accessing-resources.html)  
[Resource Types](https://developer.android.google.cn/guide/topics/resources/available-resources.html)



---



##### Example 05 Activities

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example05/src/main/java/com/example/example05>)

###### Activities

> [`Activity`](https://developer.android.google.cn/guide/components/activities.html)是一个应用组件，用户可与其提供的屏幕进行交互（相当于一个页面）
> 每个 Activity 都会获得一个用于绘制其用户界面的窗口。
> 窗口通常会充满屏幕，但也可小于屏幕并浮动在其他窗口之上

> 一个应用通常由多个彼此松散联系的 Activity 组成。 一般会指定应用中的某个 Activity 为“主”Activity，即首次启动应用时呈现给用户的那个 Activity。 而且每个 Activity 均可启动另一个 Activity，以便执行不同的操作。 每次新 Activity 启动时，前一 Activity 便会停止，但系统会在堆栈（“返回栈”）中保留该 Activity。 当新 Activity 启动时，系统会将其推送到返回栈上，并取得用户焦点。 返回栈遵循基本的“后进先出”堆栈机制，因此，当用户完成当前 Activity 并按“返回”按钮时，系统会从堆栈中将其弹出（并销毁），然后恢复前一 Activity。



**Declare Activities**

使用activity 需要在 `manifest` 配置中声明: 在 `<application>` 添加1个 `<activity>` 元素

```
<manifest ... >
  <application ... >
      <activity android:name=".ExampleActivity" />
      ...
  </application ... >
  ...
</manifest >
```

| 回调方法    | 特点                                                         |
| ----------- | ------------------------------------------------------------ |
| onCreate()  | 系统会在创建 Activity 时调用此方法. <br />实现内初始化 Activity 的数据 .<br />必须在 setContentView() 中定义 Activity 所使用的的layout文件.<br />onCreate() 完成后 下一步 就是 onStart(). |
| onStart()   | As `onCreate()` exits, the activity enters the Started state.<br />the activity becomes visible to the user.<br />This callback contains the activity’s final preparations for coming to the foreground and becoming interactive. |
| onPause()   | when the activity loses focus and enters a Paused state.<br />the activity will soon enter the **Stopped** or **Resumed** state.<br />may continue to update the UI if the user is expecting the UI to update (a media player playing). |
| onStop()    | when the activity is no longer visible to the user<br />may happen because the activity is being destroyedd, a new activity is starting, or an existing activity is entering a Resumed state and is covering the stopped activity<br />next callback that the system calls is either `onRestart()`  or  `onDestroy()` |
| onRestart() | when an activity in the Stopped state is about to restart<br />restores(恢复) the state of the activity from the time that it was stopped<br />This callback is always followed by `onStart()` |
| onDestroy() | invokes this callback before an activity is destroyed<br />ensure that all of an activity’s resources are released |



###### Common [Intents](https://developer.android.google.cn/guide/components/intents-common.html)

Intent在Android中的核心作用就是“跳转”,同时可以携带必要的信息，将Intent作为一个信息桥梁

1. explicit intent : 显示跳转到下一个活动

   ```java
   Intent intent = new Intent(this, SecondActivity.class);  //上下文环境； 目的Activity
   startActivity(intent);   //startActivity方法
   ```

2. 传递数据 : `intent.putExtra(key, value)` 上一个活动向下一个活动传递数据

   ```java
   //在第一个页面将数据装进Intent
   intent.putExtra("extra_data", "dafadfadfa");   //键值对
//在第二个页面拿到数据
   getIntent().getStringExtra("extra_data");
   ```

3. implicit intent : specifies an action that can invoke any app on the device able to perform the action

   ```java
   // Create the text message with a string
   Intent sendIntent = new Intent();
   sendIntent.setAction(Intent.ACTION_SEND);
   sendIntent.putExtra(Intent.EXTRA_TEXT, textMessage);
   sendIntent.setType("text/plain");
   
   // Verify that the intent will resolve to an activity
   if (sendIntent.resolveActivity(getPackageManager()) != null) {
       startActivity(sendIntent);
   }
   ```

**Starting an Activity**
内容：Activity的切换方法；切换时前后Activity经历的生命周期过程；通过Intent在跳转切换时传递参数；Bundle；
要求：实现全部生命周期回调函数，在跳转时观察activity的状态，传递并接收参数。

**知识点1**：[实现`OnClickListener`接口的三种方法](https://blog.csdn.net/markshz/article/details/80762818)

1. 创建内部类    ~（麻烦）~
   
   > 创建一个内部类实现OnClickListener接口并重写onClick方法
2. 主类中实现OnClickListener接口: 
   
   > 在主类中实现OnClickListener接口并重写onClick方法
   > button.setOnClickListener(this);
3. 匿名内部类:
   
   > 当按钮较少或只有一个按钮时，可以直接创建OnClickListener的匿名内部类传入按钮的setOnClickListener参数中
   
   

**知识点2**：[super.onCreate(savedInstanceState)](https://www.cnblogs.com/dazuihou/p/3565647.html)

1. onCreate()方法其实是覆写了基类（Activity类）的onCreate方法，super.onCreate()是在调用基类中的onCreate方法。

   > 而在子类的onCreate方法中，不能直接调用onCreate(),因为这样做会产生递归，为了解决这一问题，java用super关键字表示超类的意思，当前类就是从超类继承而来的

2. savedInstanceState是保存当前Activity的状态信息

   > 如果一个非running的Activity因为资源紧张而被系统销毁，当再次启动这个Activity时，可以通过这个保存下来的状态实例，即通过saveInstanceState获取之前的信息，然后使用这些信息，让用户感觉和之前的界面一模一样，提升用户体验。




```java
//MainActivity类中实现OnClickListener接口，并重写 OnClick() 方法
public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private static final String TAG = "MainActivity";

    private Button button;
    private EditText editText;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState); //保存当前Activity的状态信息
        Log.i(TAG, "onCreate()");
        setContentView(R.layout.activity_main);  //放置UI布局
        button = findViewById(R.id.act_main_button);
        editText = findViewById(R.id.act_main_edittext);

        button.setOnClickListener(this); //为什么用this???
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.act_main_button:
                Intent intent = new Intent(this, SecActivity.class);
                intent.putExtra("value", editText.getText().toString()); //以键值对传值
                startActivity(intent);
        }
    }
}

```

```java
public class SecActivity extends AppCompatActivity {
    private static final String TAG = "SecActivity";

    private TextView textView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sec);
        Log.i(TAG, "SecActivity onCreate()");
        String value = getIntent().getStringExtra("value");
        textView = findViewById(R.id.act_sec_textview);
        textView.setText(value);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.i(TAG, "SecActivity onStart()");
        // The activity is about to become visible.
    }
    @Override
    protected void onResume() {
        super.onResume();
        Log.i(TAG, "SecActivity onResume()");
        // The activity has become visible (it is now "resumed").
    }
    @Override
    protected void onPause() {
        Log.i(TAG, "SecActivity onPause()");
        super.onPause();
        // Another activity is taking focus (this activity is about to be "paused").
    }
    @Override
    protected void onStop() {
        Log.i(TAG, "SecActivity onStop()");
        super.onStop();
        // The activity is no longer visible (it is now "stopped")
    }
    @Override
    protected void onDestroy() {
        Log.i(TAG, "SecActivity onDestroy()");
        super.onDestroy();
        // The activity is about to be destroyed.
    }

}

```



----



##### Example 06  [RecyclerView](https://www.jianshu.com/p/4f9591291365)

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example06/src/main/java/com/example/example06>)

> The views in the list are represented by *view holder*(视图持有者) objects. These objects are instances of a class you define by extending `RecyclerView.ViewHolder`. Each view holder is in charge of displaying a single item with a view. 
> The `RecyclerView`creates only as many view holders as are needed to display the on-screen portion of the dynamic content, plus a few extra. As the user scrolls through the list, the `RecyclerView` takes the off-screen views and rebinds them to the data which is scrolling onto the screen.

###### create RecyclerView

配置：在对应的 `build.gradle`   文件中dependencies加上   

```
implementation 'androidx.recyclerview:recyclerview:1.0.0'
```

创建RecyclerView中[item布局样式](<https://github.com/zhanyeye/android-examples/blob/master/example06/src/main/res/layout/recyclerview_news.xml>)

创建实体类news封装数据  

> 实体类属性 public ?     :谷歌虚拟机没有使用内联，减少损耗   故不建议使用 get/set ， 直接public

创建自定义adapter

+ 在adapter中创建viewholder (在Adapter中创建一个**继承RecyclerView.ViewHolder**的静态内部类，记为VH)

+ adapter添加news集合属性, 添加有参构造函数

+ adapter继承RecyclerView.Adapter，并声明VH泛型为自定义的VH类型

+ 在**Adapter中实现3个方法**
  
  1. **onCreateViewHolder()**
  
     > 这个方法主要**生成**为**每个Item [inflater](https://www.jianshu.com/p/cdc9d4c0826e?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)出一个View**，但是该方法**返回**的是一个**ViewHolder**。该方法把View直接封装在ViewHolder中，然后我们面向的是ViewHolder这个实例，当然这个ViewHolder需要我们自己去编写
  
  2. **onBindViewHolder()**
  
     > 这个方法主要用于**适配渲染数据到View**中。方法**提供**给你了一**viewHolder**而不是原来的convertView
  
  3. **getItemCount()**
  
     > 这个方法就**类似**于BaseAdapter的**getCount**方法了，即总共有多少个条目。



重写getItemCount()方法返回集合元素数量，即需要渲染的item数量  
重写onBindViewHolder()方法，当视图item滚动，绑定对应数据到item中的相应控件  
重写onCreateViewHolder()方法，声明item布局样式，并将view item对象，交由viewholder持有  
RecyclerView默认不包含点击事件及点击动画，需手动实现  



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



RecyclerView提供了**三种布局管理器**：
- **LinerLayoutManager** 以**垂直**或者**水平列表**方式展示Item
- **GridLayoutManager** 以**网格**方式展示Item
- **StaggeredGridLayoutManager** 以**瀑布流**方式展示Item

```java
public class MainActivity extends AppCompatActivity {
    private RecyclerView recyclerView;
    private MainAdapter adapter;
    private Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        recyclerView = findViewById(R.id.act_main_recyclerview);
        // 指定一个默认的布局管理器
        RecyclerView.LayoutManager mLayoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(mLayoutManager);
        // 指定item插入/移除动画
        // recyclerView.setItemAnimator(new DefaultItemAnimator());
        // 指定item分割线
        recyclerView.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        // 指定适配器
        adapter = new MainAdapter(listNews());
        recyclerView.setAdapter(adapter);

        button = findViewById(R.id.act_main_button);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, SecActivity.class);
                startActivity(intent);
            }
        });
    }

    private List<News> listNews() {
        News n1 = new News(1, "阿根廷VS波黑", "小组赛F组 阿根廷VS波黑");
        News n2 = new News(2, "法国VS洪都拉斯", "小组赛E组 法国VS洪都拉斯");
        News n3 = new News(3, "瑞士VS厄瓜多尔", "小组赛E组 瑞士VS厄瓜多尔");
        News n4 = new News(4, "西班牙VS荷兰", "小组赛B组 西班牙VS荷兰");
        News n5 = new News(5, "俄罗斯VS丹麦", "小组赛A组 俄罗斯VS丹麦");
        News n6 = new News(6, "巴西VS意大利", "小组赛C组 巴西VS意大利");
        News n7 = new News(7, "日本VS伊朗", "小组赛D组 日本VS伊朗");
        List<News> news = new ArrayList<>();
        news.add(n1); news.add(n2); news.add(n3); news.add(n4);
        news.add(n5); news.add(n6); news.add(n7);
        news.add(n1); news.add(n2); news.add(n3); news.add(n4);
        return news;
    }
}

```




###### 需求OnItemClicklistener

+ 在item布局样式中添加点击波纹动画  
+ 在adapter onBindViewHolder()方法为item view设置点击监听  
+ 高级，自定义接口，实现在activity等的点击监听

```xml
//在RecyclerView.xml根元素加上属性：添加点击波纹动画  
android:background="?android:attr/selectableItemBackground"
android:clickable="true"
android:focusable="true"
```

```java
//在适配器中，自定义监听接口,实现在activity等的点击监听
public interface OnItemClickListener {
    void onItemClick(View view, int position, News news);
}

//onBindViewHolder()方法为item view设置点击监听 
@Override
public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
    holder.title.setText(news.get(position).title);
    holder.suttitle.setText(news.get(position).subtitle);
    holder.pic.setImageResource(R.mipmap.ic_launcher);
    holder.itemView.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Toast.makeText(context, news.get(position).title, Toast.LENGTH_SHORT).show();
        }
    });
}
```

```java
//实现在activity等的点击监听
//在onCreate()中：
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        Intent i = new Intent(SecActivity.this, ThirdActivity.class);
        startActivity(i);
    }
});
```



###### SwipeRefreshLayout
+ 添加下拉刷新功能，将RecyclerView嵌入[SwipeRefreshLayout](<https://github.com/zhanyeye/android-examples/blob/master/example06/src/main/res/layout/activity_third.xml>)  
+ 通过Handler模拟耗时操作，添加元素  

```xml
//将RecyclerView嵌入SwipeRefreshLayout 
<androidx.swiperefreshlayout.widget.SwipeRefreshLayout
    android:id="@+id/act_third_swipe"
    android:layout_width="match_parent"
    android:layout_height="0dp"
    android:layout_weight="1">
    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/act_third_recyclerview"
        android:layout_width="match_parent"
        android:layout_height="match_parent"/>
</androidx.swiperefreshlayout.widget.SwipeRefreshLayout>
```

通过Handler模拟耗时操作，[添加元素](<https://github.com/zhanyeye/android-examples/blob/master/example06/src/main/java/com/example/example06/ThirdActivity.java>)

```java
private SwipeRefreshLayout swipe;
swipe = findViewById(R.id.act_third_swipe);
swipe.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
    @Override
    public void onRefresh() {
        //模拟耗时操作，子线程禁止直接修改主线程控件属性
        new Handler().postDelayed(() -> {
            //取消刷新动画
            swipe.setRefreshing(false);
            news.add(0, new News(1, "阿根廷VS波黑" + news.size(), "小组赛F组 阿根廷VS波黑"));
            adapter.notifyDataSetChanged(); //通知适配器数据改变
            }, 2000);
        }
});
```



----



##### Example 07 ItemTouchHelper

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example07/src/main/java/com/example/example07/adapter>)

ItemTouchHelper，用来协助处理RecyclerView中item的移动/滑动/拖拽等操作  

> Callback内部类(非回调接口)，继承实现各种操作  
> 重写getMovementFlags()方法，决定拖拽滑动在哪个方向是被允许  
> 重写onSwiped()方法，Item横向滑动时回调，删除item  
> DefaultItemAnimator类定义recyclerView item操作动画  
> adapter添加/移除item必须通过notifyItemInserted()/notifyItemRemoved()方法，才有动画互交效果  
> 重写onSwiped()方法可删除item，但无法删除数据，通过自定义回调接口实现  
> 依然通过SwipeRefreshLayout下拉刷新



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



-----



##### Example 08 Appbar & Toolbar & Menu

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example08/src/main>)

###### Appbar & Toolbar

> 欲使用功能丰富的appbar/toolbar，需先关闭android自带的title/actionbar  
> 自定义无title/actionbar样式的主题  
> 在AndroidManifest配置中引入自定义主题  
> 自定义独立的appbar布局文件，注意命名空间  
> 在activity layout中引入(类似JSP的include)  
> 在activity中获取toolbar对象，可动态修改各种属性  
> 动态置于ActionBar，开启左箭头(可选)等等  

自定义无title/actionbar样式的主题 : res/values/styles.xml 中

```xml
 <!-- 自定义无title/actionbar样式 -->
<style name="AppTheme.NoActionBar">
    <item name="windowNoTitle">true</item>
    <item name="windowActionBar">false</item>
</style>
```

在[AndroidManifest](<https://github.com/zhanyeye/android-examples/blob/master/example08/src/main/AndroidManifest.xml>)配置中引入自定义主题: 

`android:theme="@style/AppTheme.NoActionBar">`

自定义独立的appbar布局文件，注意命名空间

```xml
---->> appbar.xml
<?xml version="1.0" encoding="utf-8"?>
<com.google.android.material.appbar.AppBarLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="wrap_content">

    <androidx.appcompat.widget.Toolbar

        android:id="@+id/my_toolbar"
        android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize"
        app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
        app:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"></androidx.appcompat.widget.Toolbar>

</com.google.android.material.appbar.AppBarLayout>
```

在activity layout中引入(类似JSP的include)

```xml
---->> activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout ...
    tools:context=".MainActivity">

    <include layout="@layout/appbar"></include>

</LinearLayout>
```

在activity中获取toolbar对象，可动态修改各种属性  
动态置于ActionBar，开启左箭头(可选)等等  

```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.my_toolbar);
        // 动态修改toolbar属性
        toolbar.setLogo(R.mipmap.ic_launcher);
        toolbar.setTitle("标题");
        setSupportActionBar(toolbar);
        // 显示左箭头
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }
	...
    ...    
}
```

###### Menu

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



-------



##### Example 09 Navigation & BottomNavigationView

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example09/src/main>)

###### Fragment & Navigation

> 在module gradle配置引入navigation-fragment，navigation-ui依赖  
> (不直接声明依赖，创建导航视图文件时也可自动引入，但AS会卡住假死)  
> 创建多个Fragment及布局  
> 创建navigation资源目录，创建nav_graph导航视图文件  
> 在导航视图中引入fragment，声明导航规则  
> (也可设置fragment的独立global action)  
> 修改activity_main布局，添加NavHostFragment容器，，引用导航视图，声明必须属性   



引入依赖

```
def nav_version = "2.0.0"
implementation "androidx.navigation:navigation-fragment:$nav_version"
implementation "androidx.navigation:navigation-ui:$nav_version"
```

创建多个Fragment及布局

> new -> fragment -> 勾选 Create Layout XML; 下面的2个include 选项不要勾选 (在创建 fragment 类的同时 创建布局文件)


```java
public class FoodFragment extends Fragment {
    private static final String TAG = "FoodFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_food, container, false);
    }
    //fragment中组件初始化写在 onViewCreated() 中
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Button button = view.findViewById(R.id.frag_food_detail_button);
        button.setOnClickListener(v -> {
            Navigation.findNavController(v).navigate(R.id.action_foodFragment_to_foodDetailFragment);
        });
    }
}
```



创建navigation资源目录，创建nav_graph[导航视图文件](<https://github.com/zhanyeye/android-examples/blob/master/example09/src/main/res/navigation/nav_graph.xml>)

> 在导航视图中引入fragment，声明导航规则 : **设置指定的id 导航到指定的 fragment类 和 它的布局**

```xml
<?xml version="1.0" encoding="utf-8"?>
<navigation xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/nav_graph"
    app:startDestination="@id/foodFragment">
    <fragment
        android:id="@+id/foodFragment"
        android:name="com.example.example09.FoodFragment"
        android:label="fragment_food"
        tools:layout="@layout/fragment_food" >
        <action
            android:id="@+id/action_foodFragment_to_foodDetailFragment"
            app:destination="@id/foodDetailFragment" />
    </fragment>
    <fragment
        android:id="@+id/foodDetailFragment"
        android:name="com.example.example09.FoodDetailFragment"
        android:label="fragment_food_detail"
        tools:layout="@layout/fragment_food_detail" />
    ...
    ...
</navigation>
```

修改[activity_main布局](<https://github.com/zhanyeye/android-examples/blob/master/example09/src/main/res/layout/activity_main.xml>)，添加NavHostFragment容器，，引用导航视图，声明必须属性

```xml
 //activity_main
<!-- 声明一个NavHostFragment容器 -->
    <fragment
        android:id="@+id/my_nav_host_fragment"
        android:name="androidx.navigation.fragment.NavHostFragment"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        app:defaultNavHost="true"
        app:navGraph="@navigation/nav_graph" />
```



###### BottomNavigationView

> com.google.android.material.bottomnavigation.BottomNavigationView  
> (自动包含选中状态样式：图标加亮+显示字体，区别未选中其他item)  
> 创建menu文件，声明Navigation所需item，图标及文字，绑定Navigation中的fragment  
> 在activity布局声明引入底部导航BottomNavigationView控件，引用menu  
> 在activity中获取NavController对象及并绑定BottomNavigationView对象



创建menu文件，声明Navigation所需item，图标及文字，绑定Navigation中的fragment

```xml
------->> menu_bottom_nav.xml

<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:id="@id/foodFragment"
        android:title="Food"
        android:icon="@drawable/food_u" />
    <item android:id="@id/hotelFragment"
        android:title="Hotel"
        android:icon="@drawable/hotel_u" />
    <item android:id="@id/mapFragment"
        android:title="Map"
        android:icon="@drawable/ic_loc_in_map_u" />
    <item android:id="@+id/menu_bottom_list"
        android:title="List"
        android:icon="@drawable/main_index_my_pressed" />
</menu>
```

在[activity布局](<https://github.com/zhanyeye/android-examples/blob/master/example09/src/main/res/layout/activity_main.xml>)声明引入底部导航BottomNavigationView控件，引用menu

```xml
<com.google.android.material.bottomnavigation.BottomNavigationView
    android:id="@+id/bottom_nav"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:menu="@menu/menu_bottom_nav" />
```

在[Activity类](<https://github.com/zhanyeye/android-examples/blob/master/example09/src/main/java/com/example/example09/MainActivity.java>)中获取NavController对象及并绑定BottomNavigationView对象

```java
public class MainActivity extends AppCompatActivity implements NavController.OnDestinationChangedListener {
    private static final String TAG = "MainActivity";

    private NavController controller;
    private BottomNavigationView bottomNavigationView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        bottomNavigationView = findViewById(R.id.bottom_nav);
        controller = Navigation.findNavController(this, R.id.my_nav_host_fragment);
        // 监听导航切换事件
        controller.addOnDestinationChangedListener(this);
        NavigationUI.setupWithNavController(bottomNavigationView, controller);
    }
    @Override
    public void onDestinationChanged(@NonNull NavController controller, @NonNull NavDestination destination, @Nullable Bundle arguments) {
        switch (destination.getId()) {
            case R.id.foodDetailFragment:
                bottomNavigationView.setVisibility(View.GONE);
                break;
            default:
                bottomNavigationView.setVisibility(View.VISIBLE);
        }
    }
}
```



--------



##### Example 10 DrawerLayout & NavigationView

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example10/src/main/res/layout>)

> 基于DrawerLayout创建抽屉布局，从内向外逐层构建  
> 引入com.google.android.material:material:1.0.0依赖  
> 创建基本主内容布局，声明layout_behavior属性避免被appbar覆盖  
> 可声明使用showIn属性，增加预览效果  
> 创建appbar布局，声明toolbar，引入主内容布局(需声明使用noactionbar样式)  
> 基于menu创建抽屉导航选项  
> 基于DrawerLayout创建抽屉布局，引入appbar布局，NavigationView引用menu导航  
> 可选创建抽屉头部布局，并引入到NavigationView属性(自定义了头部背景样式)  
> Activity代码中添加actionbar  
> 监听navigationView OnNavigationItemSelectedListener  
> 任意item被点击，关闭抽屉  
> 抽屉与下导航，选一种作为app主布局即可  

引入依赖

```
implementation 'com.google.android.material:material:1.0.0'
```

创建基本主内容布局，声明layout_behavior属性避免被appbar覆盖

> 可声明使用showIn属性，增加预览效果 (预览该布局在外层layout中的效果)

```xml
------->> content.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout ...
    app:layout_behavior="com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior"
    tools:showIn="@layout/appbar">

    <TextView
        ...
        android:text="左拉抽屉；单activity开发，用navfragmenthost替换" />

</LinearLayout>
```

创建appbar布局，声明toolbar，引入主内容布局 (需在AndroidManifest.xml和style.xml声明使用AppTheme.NoActionBar样式)
`<include layout = "">`引入 content 布局

```xml
------>> appbar.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout ...
    tools:showIn="@layout/activity_main">

    <com.google.android.material.appbar.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content">

        <androidx.appcompat.widget.Toolbar
            android:id="@+id/my_toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            app:popupTheme="@style/ThemeOverlay.AppCompat.Light"
            app:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar" />
    </com.google.android.material.appbar.AppBarLayout>

    <include layout="@layout/content" />
</LinearLayout>

```

基于[menu创建抽屉导航选项](<https://github.com/zhanyeye/android-examples/blob/master/example10/src/main/res/menu/menu_drawer.xml>)

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <group android:checkableBehavior="single">
        <item
            android:id="@+id/nav_camera"
            android:icon="@android:drawable/ic_menu_camera"
            android:title="camera" />
        ...
        ...
    </group>

    <item android:title="Communicate">
        <menu>
            <item
                android:id="@+id/nav_share"
                android:icon="@android:drawable/ic_menu_share"
                android:title="share" />
            ...
            ...
        </menu>
    </item>

</menu>

```

基于DrawerLayout创建抽屉布局，引入appbar布局，NavigationView引用menu导航  

```xml
---->> menu_drawer.xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.drawerlayout.widget.DrawerLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/drawer_layout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:fitsSystemWindows="true"
    tools:context=".MainActivity"
    tools:openDrawer="start">

    <include
        layout="@layout/appbar"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

    <com.google.android.material.navigation.NavigationView
        android:id="@+id/nav_view"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:layout_gravity="start"
        android:fitsSystemWindows="true"
        app:headerLayout="@layout/drawer_header"
        app:menu="@menu/menu_drawer" />

</androidx.drawerlayout.widget.DrawerLayout>

```

可选创建抽屉头部布局，并引入到NavigationView属性(自定义了头部背景样式)

```xml
---->> drawer_header.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="176dp"
    android:background="@drawable/side_nav_bar"
    android:gravity="bottom"
    android:orientation="vertical"
    android:padding="16dp">

    <ImageView
        android:id="@+id/imageView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:paddingTop="8dp"
        app:srcCompat="@mipmap/ic_launcher_round" />

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginVertical="8dp"
        android:textSize="20sp"
        android:textStyle="bold"
        android:textColor="@color/colorAccent"
        android:text="主标题"/>

    <TextView
        android:id="@+id/textView"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="副标题" />

</LinearLayout>
```

Activity代码中添加actionbar  
监听navigationView OnNavigationItemSelectedListener  
任意item被点击，关闭抽屉  

```java
public class MainActivity extends AppCompatActivity implements NavigationView.OnNavigationItemSelectedListener {
    private Toolbar toolbar;
    private DrawerLayout drawerLayout;
    private NavigationView navigationView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        toolbar = findViewById(R.id.my_toolbar);
        drawerLayout = findViewById(R.id.drawer_layout);
        navigationView = findViewById(R.id.nav_view);
        setSupportActionBar(toolbar);
        // 显示左箭头
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        navigationView.setNavigationItemSelectedListener(this);
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem menuItem) {
        switch (menuItem.getItemId()) {
            case R.id.nav_camera:
                Toast.makeText(this, "camera", Toast.LENGTH_SHORT).show();
                break;

        }
        drawerLayout.closeDrawer(GravityCompat.START); //任意item被点击，关闭抽屉  
        return true;
    }
}
```



---------



##### Example 11 SharedPreferences 接口

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example11/src/main/java/com/example/example11/util>)

> Saving Key-Value Sets:  
> https://developer.android.google.cn/training/data-storage/shared-preferences  
> 基本的保存键值对数据的实现  
> 自定义application，暴露获取application对象的静态方法  
> 修改AndroidManifest配置启动自定义application  
> 创建SharedPreferences操作工具类  
> 编写输入输出布局  
> 在activity中将输入写入文件  
> 重新进入应用，文本输出控件，显式上次持久化的数据  

> SharedPreferences 需要上下文
> 使用： `getApplicationContext()` 拿



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

修改AndroidManifest[配置](<https://github.com/zhanyeye/android-examples/blob/master/example11/src/main/AndroidManifest.xml>)启动自定义application  
`android:name=".util.MyApplication"`

创建SharedPreferences操作工具类

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



----



##### Example 12 DataBinding & ViewModel & LiveData

复习完成 ​-> ​[link](<https://github.com/zhanyeye/android-examples/tree/master/example12/src/main/java/com/example/example12>)

 在项目gradle配置中，启动dataBinding

```json
dataBinding {
        enabled = true
}
```

添加整合了viewmodel livedata的依赖lifecycle-extensions

```
def lifecycle_version = "2.0.0"
// ViewModel and LiveData
implementation "androidx.lifecycle:lifecycle-extensions:$lifecycle_version"
```

+ **官方推荐一个activity对应绑定一个ViewModel**



###### 基本实现，基于mainactivity

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



###### 整合recycleview的实现，基于secactivity

创建[实体类](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/java/com/example/example12/entity/News.java>)，创建[VM](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/java/com/example/example12/viewmodel/SecViewModel.java>)

创建更新可观测数据

初始化时，异步更新可观测数据

创建方法，异步更新可观测数据

```java
public class SecViewModel extends AndroidViewModel {
    private static final String TAG = "SecViewModel";
    // 模拟每次获取的新数据，不是加上旧的全部数据
    public MutableLiveData<List<News>> newsLoad = new MutableLiveData<>();

    public SecViewModel(@NonNull Application application) {
        super(application);
        // 加载的同时发出异步获取更新数据请求
        initNews();
    }

    /**
     *  模拟异步请求并获取最新的数据
     */
    private void initNews() {
        new Thread(() -> {
            try {
                Thread.sleep(1000);
                News n1 = new News(1, "阿根廷VS波黑", "小组赛F组 阿根廷VS波黑");
                List<News> news = new ArrayList<>();
                news.add(n1);
                // 将数据异步更新绑定
                newsLoad.postValue(news);
            } catch (InterruptedException e) {
            }
        }).start();
    }

    public void loadNews() {
        new Thread(() -> {
            try {
                Thread.sleep(2000);
                News n1 = new News(1, "荷兰VS西班牙", "小组赛F组 荷兰VS西班牙");
                List<News> news = new ArrayList<>();
                news.add(n1);
                newsLoad.postValue(news);

            } catch (InterruptedException e) {

            }
        }).start();
    }
}
```

创建recycleview_item[布局](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/res/layout/recyclerview_news.xml>)，绑定实体类中属性

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout>
    <data>
    	<variable name = "news" type="com....News"/>
    </data>
    <LinearLayout>
    	...
    </LinearLayout>
</layout>
```

修改[layout](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/res/layout/activity_sec.xml>)，绑定VM，绑定VM中更新方法

```xml

<?xml version="1.0" encoding="utf-8"?>
<layout>
    <data>
        <variable name="secVM" type="com.example.example12.viewmodel.SecViewModel" />
    </data>
    <LinearLayout 
        ...
        tools:context=".SecActivity">

        <androidx.recyclerview.widget.RecyclerView
            android:id="@+id/act_sec_recyclerview" />

        <Button
            android:onClick="@{() -> secVM.loadNews()}"
            android:text="更新" />
        <Button
            android:onClick="toThird"
            android:text="双向绑定" />
    </LinearLayout>
</layout>
```

**创建自定义[adapter](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/java/com/example/example12/adapter/SecAdapter.java>)，初始化数据集合，重写基本方法**

创建viewholder

> viewholder不再holder控件，而是每一个itemview对应的binding对象
> 通过binding对象绑定集合中的数据

```java
static class MyViewHolder extends RecyclerView.ViewHolder {
    private RecyclerviewNewsBinding binding;

    public MyViewHolder(@NonNull View itemView, RecyclerviewNewsBinding binding) {
        super(itemView);
        this.binding = binding;
    }
}
```

重写onCreateViewHolder()方法，动态创建数据绑定对象

> 为每个item创建binding对象，复用

修改viewholder hold绑定对象

> 返回的 viewholder 基于绑定对象创建：`return new MyViewHolder(binding.getRoot(), binding);`

```java
@NonNull
@Override
public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
    LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
    // 为每个item创建binding对象，复用
    RecyclerviewNewsBinding binding = DataBindingUtil.inflate(layoutInflater, R.layout.recyclerview_news, parent, false);
    return new MyViewHolder(binding.getRoot(), binding);
}
```

重写onBindViewHolder()方法，将当前viewholder的binding对象绑定对应的集合数据

> binding 对象的set方法

```java
@Override
public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
    holder.binding.setNews(currentNewsList.get(position));
}
```

[DiffUtil.Callback](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/java/com/example/example12/adapter/SecAdapter.java>)
自定义DiffUtil.Callback类，重写相关方法，实现更新adapter时的计算依据
adapter对外提供自己的更新方法
基于自定义Callback类，实现高效的，仅针对需更新项的，支持动画效果的，动态更新

[Activity](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/java/com/example/example12/SecActivity.java>)
修改activity代码，获取binding/viewmodel对象，绑定生命周期等
初始化recycleview，adapter等
监听自定义viewmodel中的数据更新，等有更新时，调用adapter提供的更新方法，通知其更新

```java
	...
    @Override
    protected void onCreate(Bundle savedInstanceState) {
		...
        // 监听MV中数据更新，注入结果
        viewModel.newsLoad.observe(this, news -> {
                Log.i(TAG, "onChanged");
                // 将最新数据交由adapter渲染
                adapter.updateNews(news);
                // 更新到顶部
                recyclerView.scrollToPosition(0);
        });
     ...
```





###### Two-way data binding

[双向绑定](<https://github.com/zhanyeye/android-examples/blob/master/example12/src/main/res/layout/activity_third.xml>)要比vue复杂。例如，封装在可观测数据内，数据的改变无法直接响应

双向绑定 `@={}`



---



##### Example 13 Connecting to the Network

复习完成 -> [link](<https://github.com/zhanyeye/android-examples/tree/master/example13/src/main/java/com/example/example13>)

###### Network Request/Response & Image Resources

添加请求权限

```xml
在 AndroidManifest.xml 添加
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

创建自定义application类，配置

```java
public class MyApplication extends Application {
    public static Application instance;
    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }
    public static Application getInstance() {
        return instance;
    }
}
-----------------------
AndroidManifest.xml 中 application 的 android:name=".util.MyApplication"
```

Android 9以后，要求网络请求必须为HTTPS加密请求，不便于测试，创建配置关闭该功能  

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
------------------------
AndroidManifest.xml 中 application 的 android:networkSecurityConfig="@xml/network_security_config"
```

引入Retrofit框架依赖

```xml
implementation 'com.squareup.retrofit2:converter-gson:2.5.0'
implementation 'com.squareup.retrofit2:retrofit:2.5.0'
```

创建实体类

创建封装响应数据的DTO类  (data transfer object)

```java
/**
 * 用于从json字符串转成Java对象  
 * 属性名称必须与响应中属性名称完全相同，一个dto可对应多个响应
 * 没有对应属性，自动忽略
 */
public class NewsDTO {
    public News news;
    public List<News> newsList;

}
```

创建网络请求接口，声明与后端对应的restful请求地址，图片资源请求处理

```java
/**
 * 后端将数据封装在Map转为json
 * 与基于弱类型JS的前端处理不同，由于无法确定Map中值的类型而无法反序列化数据
 * 因此，为返回的响应创建对应转换的DTO类型，响应数据封装在DTO对象属性中
 * 请求路径不能使用，/，开始，否则baseurl设置会无效，将直接向服务器根路径相对请求
 * 请求注解与springMVC相似
 */
public interface NewsService {
    @GET("news/{id}")
    Call<NewsDTO> getNews(@Path("id") int id);

    @GET("news")
    Call<NewsDTO> listNews();

    /**
     * 全局的图片下载，可声明在一个独立的接口，此处简化
     * 传入图片地址，响应返回图片封装在ResponseBody
     * 结合构造retrofit时的缓存策略，自动重用缓存图片
     * 可结合自定义bindingadapter使用，更简洁，耦合性更低
     * @param url
     * @return
     */
    @GET
    Call<ResponseBody> getBitmap(@Url String url);

    /**
     * 即使没有返回值，也必须封装一个空类型Void
     * @param n
     * @return
     */
    @POST("news")
    Call<ResponseBody> post(@Body News n); //Call<Void> post(@Body News n);
}
```

构造封装retrofit对象，声明缓存，请求相对根路径，转换器，拦截器等配置

构造封装请求接口类型对象，并对外暴露

```java
public class ServiceFactory {
    // 默认retrofit将请求的图片置于缓存，当向相同地址请求图片时，自动加载缓存的图片
    // 自动在data/data/应用包/cache下，创建缓存文件,10MB
    private static OkHttpClient client = new OkHttpClient.Builder()
            .cache(new Cache(MyApplication.getInstance().getCacheDir(), 10 * 1024 * 1024))
            .build();
    // 基于OKhttp对象，自定义属性，构造retrofit对象
    private static Retrofit retrofit = new Retrofit.Builder()
            // 本地测试不能使用localhost，使用本地IP
            // 根路径必须已，/，结束
            // .baseUrl("http://192.168.1.3:8080/api/")
            .baseUrl("http://www.whyman.site/api/") //设置网络请求的Url地址
            .client(client)
            .addConverterFactory(GsonConverterFactory.create()) //设置数据解析
            .build();

    // retrofit自动创建接口的代理类
    public static NewsService getNewsService() {
        return retrofit.create(NewsService.class);
    }
}
```

+ 小小知识点： **Builder 设计模式**

  + 在类中加一个静态内部类
  + 静态内部类中有public方法设置属性
  + 最后build() 方法，返回外部的类的对象

  > Builder模式通常作为配置类的构建器将配置的构建和表示分离开来，同时也是将配置从目标类中隔离出来，避免作为过多的setter方法，并且隐藏内部的细节。Builder模式比较常见的实现形式是通过链式调用，这样使得代码更加简洁、易懂。缺点是，内部类与外部类相互引用，可能会导致内存消耗比较大，不过鉴于现在的手机内存来讲，这点几乎影响不大。



编写布局文件  
监听事件，调用retrofit完成异步的网络请求，并将结果渲染到视图  

+ 像网络请求这种线程阻塞的操作，禁止在主线程中执行
+ enqueue()为异步方法，将请求任务加入应用全局异步请求队列
+ 在异步子线程中获取响应对象，在主线程，回调结果。即onResponse()方法为主线程调用

```java
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    private Button button;
    private TextView textView;
    private ImageView imageView;
    NewsService service = ServiceFactory.getNewsService();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        button = findViewById(R.id.button);
        textView = findViewById(R.id.textView);
        imageView = findViewById(R.id.imageView);
        button.setOnClickListener(v -> {
            // 像网络请求这种线程阻塞的操作，禁止在主线程中执行
            // enqueue()为异步方法，将请求任务加入应用全局异步请求队列
            // 在异步子线程中获取响应对象，在主线程，回调结果。即onResponse()方法为主线程调用
            service.listNews().enqueue(new Callback<NewsDTO>() {
                @Override
                public void onResponse(Call<NewsDTO> call, Response<NewsDTO> response) {
                    if (response.body() == null) {
                        return;
                    }
                    // 基于converter-gson自动完成反序列化
                    NewsDTO newsDTO = response.body();
                    List<News> newsList = newsDTO.newsList;
                    textView.setText(newsList.get(0).title);
                }

                @Override
                public void onFailure(Call<NewsDTO> call, Throwable t) {

                }
            });
            // 基于图片资源地址，获取渲染图片
            service.getBitmap("resources/pics/Spain_Flag.jpg").enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    Log.i(TAG, "image");
                    // BitmapFactory类，提供将多种类型数据转为bitmap的静态方法
                    Bitmap bitmap = BitmapFactory.decodeStream( response.body().byteStream());
                    imageView.setImageBitmap(bitmap);

                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {

                }
            });

        });

        findViewById(R.id.act_main_button_tosec).setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, SecActivity.class);
            startActivity(intent);
        });
    }
}

```



###### Databinding & ViewModel & BindingAdapter

添加ViewModel LiveData依赖，声明启动Databinding  

```java
dataBinding {
    enabled = true
}
dependencies {
    def lifecycle_version = "2.0.0"
    // ViewModel and LiveData
    implementation "androidx.lifecycle:lifecycle-extensions:$lifecycle_version"
}
```

创建Recyclerview item布局，绑定实体对象，自定义图片网络地址属性  

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout>
    <data>
        <variable
            name="news"
            type="com.example.example13.entity.News" />
    </data>
<LinearLayout ... >
    <!-- 自定义imageUrl属性标签，自定义处理的的adapter -->
    <ImageView
        ...
        app:imageUrl="@{news.picAddress}"
        ... />
    ...
</LinearLayout>
</layout>
```

创建自定义图片绑定适配器，基于动态绑定的图片网络地址，下载图片并渲染  

```java
public class MyImageBindingAdapter {
    private static final String TAG = "MyImageBindingAdapter";
    /**
     * 直接声明imageUrl属性，而非app:imageUrl
     * @param view 第一个参数，是自动传入的，绑定的imageview控件对象
     * @param url 第二个参数，为动态绑定的属性值，即图片网络地址
     */
    @BindingAdapter({"imageUrl"})
    public static void loadImage(ImageView view, String url) {
        // 默认渲染图片
        if (url == null) {
            view.setImageResource(R.mipmap.ic_launcher);
            return;
        }
        ServiceFactory.getNewsService().getBitmap(url).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if (response.body() == null) {
                    return;
                }
                view.setImageBitmap(BitmapFactory.decodeStream(response.body().byteStream()));
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e(TAG, "onFailure: ", t);
            }
        });

    }
}
```

创建ViewModel，声明绑定生命周期的可观测数据，新闻集合  
创建加载方法，通过网络加载数据，并更新可观测数据

```java
public class SecViewModel extends AndroidViewModel {
    public MutableLiveData<List<News>> newsList = new MutableLiveData<>();
    private NewsService newsService = ServiceFactory.getNewsService();
    public SecViewModel(@NonNull Application application) {
        super(application);
    }

    public void loadNews() {
        newsService.listNews().enqueue(new Callback<NewsDTO>() {
            @Override
            public void onResponse(Call<NewsDTO> call, Response<NewsDTO> response) {
                if (response.body() == null) {
                    return;
                }
                List<News> news = response.body().newsList;
                newsList.setValue(news);
            }

            @Override
            public void onFailure(Call<NewsDTO> call, Throwable t) {

            }
        });
    }
}

```

修改layout布局，绑定VM，添加recycleview  

创建recycleview的adapter，新闻集合属性，绑定item  

修改[activity代码](<https://github.com/zhanyeye/android-examples/blob/master/example13/src/main/java/com/example/example13/SecActivity.java>)，构造recycleview，绑定VM，绑定生命周期，监听网络返回的数据，通知adapter更新  

```java
public class SecActivity extends AppCompatActivity {
    ...
    ...
    protected void onCreate(Bundle savedInstanceState) {
        ...
        // 监听MV中数据更新，注入结果
        viewModel.newsList.observe(this, news -> {
            // 将最新数据交由adapter渲染
            adapter.setCurrentNewsList(news);
            adapter.notifyDataSetChanged();
            // 更新到顶部
            recyclerView.scrollToPosition(0);
        });
		...
    }
    ...
    @Override
    protected void onStart() {
        super.onStart();
        viewModel.loadNews();
    }
}

```



###### Post Request

在接口添加post请求  

```java
	/**
     * 即使没有返回值，也必须封装一个空类型Void
     * @param n
     * @return
     */
    @POST("news")
    Call<ResponseBody> post(@Body News n); //Call<Void> post(@Body News n);
```

创建第三个activity，实现2个输入框，1个button  
实现当点击button时，调用post请求向服务器发送数据  
 重写SecActivity onStart()方法，调用VM中的网络数据加载方法，确保从暂停状态恢复，重新加载  

```java
public class ThirdActivity extends AppCompatActivity {
    private static final String TAG = "ThirdActivity";
    private EditText title;
    private EditText subtitle;
    private Button submit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_thrid);
        title = findViewById(R.id.act_third_edittext_title);
        subtitle = findViewById(R.id.act_third_edittext_subtitle);
        findViewById(R.id.act_third_button).setOnClickListener(v -> {
            News n = new News();
            n.title = "" + title.getText().toString();
            n.subtitle = "" + subtitle.getText().toString();
            
            // 不能仅执行post()方法，必须执行enqueue()方法添加至执行队列
            ServiceFactory.getNewsService().post(n).enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    //  结束此activity
                    finish();
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                }
            });
        });
    }
}

```



---



##### Example 14 Room

###### Query

SQLite数据库，SQLite操作无需系统权限  

启动/引入数据绑定，VM，等     引用Room依赖  

```xml
android {
	dataBinding {
        enabled = true
    }
}
dependencies {
    def lifecycle_version = "2.0.0"
    def room_version = "2.0.0"
    implementation "android.arch.lifecycle:extensions:$lifecycle_version"
    implementation "android.arch.persistence.room:runtime:$room_version"
}
```

自定义引入application备用 （在AndroidManifest中引入） 

创建实体类  

```java
@Entity
public class Course {
    @PrimaryKey(autoGenerate = true)
    public int id;
    public String name;
    public String detail;
}
```

创建操作实体类的DAO层接口  

```java
@Dao
public interface CourseDao {
    @Query("SELECT * FROM Course")
    List<Course> list();

    @Query("SELECT * FROM Course c WHERE c.id=:id")
    Course find(int id);

    /**
     * 支持指定的封装属性，而非全部属性
     * @return
     */
    @Query("SELECT c.id, c.name FROM Course c")
    List<Course> listName();

    @Insert
    @Transaction
    void insert(Course... course); //支持同时传入多个course
}
```

创建[数据库工厂](<https://github.com/zhanyeye/android-examples/blob/master/example14/src/main/java/com/example/example14/repository/DatabaseFactory.java>)，封装构造过程，暴露DAO接口(代理类)  

```java
/**
 * 自动在data/data/应用包/下，创建databases目录
 */
@Database(entities = {Course.class}, version = 1, exportSchema = false)
public abstract class DatabaseFactory extends RoomDatabase {
    /**
     * 声明的是抽查类，以及抽象方法，而不是接口！～
     * android自动实现抽象方法，并动态生成接口代理类
     * @return
     */
    public abstract CourseDao courseDao();

    /**
     * 基于全局context，数据库配置类(就是此类)，数据库名称，构建数据库工厂
     */
    private static DatabaseFactory dataBaseFactory = Room
            .databaseBuilder(MyApplication.getInstance(), DatabaseFactory.class, "database")
            // 默认SQLite数据库查询操作在子线程异步执行，添加/修改/删除在主线程，可强制全部使用主线程
            .allowMainThreadQueries()     //允许主线程，可以取消，在子线程中postvalue(),传给子线程
            .build();

    /**
     * 仅对外暴露自动创建的接口代理对象
     * @return
     */
    public static CourseDao getCourseDao() {
        return dataBaseFactory.courseDao();
    }
}

```

创建VM，从数据库获取数据，加载到observer对象 

```java
public class MainViewModel extends AndroidViewModel {
    private static final String TAG = "MainViewModel";
    public MutableLiveData<List<Course>> coursesM = new MutableLiveData<>();

    public MainViewModel(@NonNull Application application) {
        super(application);
    }

    public void loadFromRoom() {
        List<Course> courses = DatabaseFactory.getCourseDao().listName();
        coursesM.setValue(courses);
        //coursesM.postValue(courses);    //如果是子线程
    }
}
```

创建item layout，recyclerview adapter，完成基本绑定操作  

修改activity代码，完成初始化，数据监听等操作  

###### Insert   & Snackbar

创建VM，声明绑定数据，声明添加方法，调用接口实现数据的插入  

```java
public class InsertCourseViewModel extends AndroidViewModel {
    public MutableLiveData<Course> courseM = new MutableLiveData<>();
    public InsertCourseViewModel(@NonNull Application application) {
        super(application);
        courseM.setValue(new Course());    //因为是双向绑定，所以即便开始没有数据也要要传一个，不然会空指针
    }

    public void insert() {
        DatabaseFactory.getCourseDao().insert(courseM.getValue());
    }
}
```

视图双向绑定VM数据，执行VM插入方法  

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout>
    <data>
        <variable
            name="insertVM"
            type="com.example.example14.viewmodel.InsertCourseViewModel" />
    </data>
    <LinearLayout ... >
        <EditText
            ...
            android:hint="课程名称"
            android:text="@={insertVM.courseM.name}"/>
        <EditText
            ...
            android:hint="课程介绍"
            android:text="@={insertVM.courseM.detail}"/>
        <Button
			...
            android:text="提交"
            android:onClick="insert"/>
    </LinearLayout>
</layout>
```

创建展示详细信息activity，修改adapter，绑定item点击监听，传递被点击item对应的数据ID参数跳转  

```java
public class InsertCourseActivity extends AppCompatActivity {
    private InsertCourseViewModel vm;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        vm = ViewModelProviders.of(this).get(InsertCourseViewModel.class);
        ActivityInsertCourseBinding binding = DataBindingUtil.setContentView(this, R.layout.activity_insert_course);
        binding.setInsertVM(vm);
        binding.setLifecycleOwner(this);
    }

    public void insert(View view) {
        // 调用VM方法实现添加
        vm.insert();
        /**
         * Snackbar,需引入material依赖；
         * Toast，浮动显示，即使activity等已退出依然显示
         * snackbar，需要一个view对象，在当前视图显示；
         * 支持像Toast显示short/long时间自动收回
         * 支持定义互交操作
         */
        Snackbar.make(view, "课程添加成功", Snackbar.LENGTH_INDEFINITE)
                .setAction("确定", v -> {
                    finish();    //结束当前activity
                }).show();
    }
}
```

```java
public class MainRecyclerViewAdapter extends RecyclerView.Adapter<MainRecyclerViewAdapter.MyViewHolder> {
    private Context context;
    public MainRecyclerViewAdapter(Context context) {
        this.context = context;
    }
    
    ...
    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
        holder.binding.setCourse(courseList.get(position));
        holder.itemView.setOnClickListener(v -> {   //绑定一个点击事件
            Intent i = new Intent(context, CourseDetailActivity.class);
            i.putExtra("id", courseList.get(position).id);
            context.startActivity(i);
        });
    }
    ...
        
}
```

展示详细信息  

```java
<layout>
    <data>
        <variable
            name="vm"
            type="com.example.example14.viewmodel.CourseDetailViewModel" />
    </data>
<LinearLayout ...>
    <TextView
        ...
        android:text="@{vm.courseM.name}"/>
    <TextView
        ...
        android:text="@{vm.courseM.detail}"/>
</LinearLayout>
</layout>
//--------
public class CourseDetailViewModel extends AndroidViewModel {
    public MutableLiveData<Course> courseM = new MutableLiveData<>();
    public CourseDetailViewModel(@NonNull Application application) {
        super(application);
        courseM.setValue(new Course());
    }

    public void getCourse(int id) {
        Course c = DatabaseFactory.getCourseDao().find(id);
        courseM.setValue(c);
    }
}
//--------
public class CourseDetailActivity extends AppCompatActivity {
    /**
     * 如果是单activity切换fragment，就不用这么麻烦了
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityCourseDetailBinding binding = DataBindingUtil.setContentView(this, R.layout.activity_course_detail);
        CourseDetailViewModel vm = ViewModelProviders.of(this).get(CourseDetailViewModel.class);
        binding.setVm(vm);
        binding.setLifecycleOwner(this);
        vm.getCourse(getIntent().getIntExtra("id", 0));
    }
}
```

Snackbar的引入

```xml
implementation 'com.google.android.material:material:1.0.0'
```



##### Example 15 External Storage

###### Internal Storage

内存储，其他应用无法访问的应用程序的独立空间，使用无需声明权限  
文件随应用删除而删除，空间有限，放应用必须文件  
getFilesDir()   拿files 中的文件夹  
getCacheDir()  拿缓存中的文件夹     

都是上下文的方法

/data/data/packagename/files

###### External Storage

外存储私有空间，无需声明权限，随应用卸载删除，放普通文件，缓存文件  
挂载到，/mnt/sdcard/android/data/packname/files  
getExternalFilesDir()/getExternalCacheDir()

外存储公共空间，Android公共目录，音乐，图片等等，需声明权限  
挂载到，/mnt/sdcard/  
Environment.getExternalStoragePublicDirectory()

manifest 中： `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />`



-----



##### Example 16 Dialogs

构造[AlertDialog](https://developer.android.google.cn/guide/topics/ui/dialogs#AlertDialog)  
自定义确认、取消、中性等按钮回调  
单选项  
单选项带确认按钮  
自定义布局样式  
多选项带确认按钮  
DatePickerDialog，minsdk 24  

```java
public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private Button button;
    private Button button2;
    private Button button3;
    private Button button4;
    private Button button5;
    private Button button6;
    private Button button7;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        button = findViewById(R.id.button1);
        button2 = findViewById(R.id.button2);
        button3 = findViewById(R.id.button3);
        button4 = findViewById(R.id.button4);
        button5 = findViewById(R.id.button5);
        button6 = findViewById(R.id.button6);
        button7 = findViewById(R.id.button7);
        button.setOnClickListener(this);
        button2.setOnClickListener(this);
        button3.setOnClickListener(this);
        button4.setOnClickListener(this);
        button5.setOnClickListener(this);
        button6.setOnClickListener(this);
        button7.setOnClickListener(this);
    }

    String[] arrayFruit = new String[]{"苹果", "橘子", "草莓", "香蕉"};
    boolean[] checkedItems = new boolean[arrayFruit.length];
    int selectIndex = 0;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button1:
                // 用于警告等，合理基于设备返回键
                // 基于builder模式构建
                AlertDialog.Builder dialog = new AlertDialog.Builder(this);
                dialog.setTitle("标题");
                dialog.setMessage("内容");
                dialog.setIcon(R.mipmap.ic_launcher);
                dialog.show();   //show 已经实现了 build()
                break;
            case R.id.button2:
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
                break;
            case R.id.button3:
                // 单选按钮组
                AlertDialog.Builder dialog3 = new AlertDialog.Builder(this);
                dialog3.setTitle("水果");
                dialog3.setItems(arrayFruit, new DialogInterface.OnClickListener() {
                    // 传入的which为被选中的位置
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Toast.makeText(MainActivity.this, arrayFruit[which], Toast.LENGTH_SHORT)
                                .show();
                    }
                });
                dialog3.show();
                break;
            case R.id.button4:
                // 单选，添加确认按钮
                AlertDialog.Builder dialog4 = new AlertDialog.Builder(this);
                dialog4.setTitle("水果");
                //传入selectIndex，否则要是final,
                dialog4.setSingleChoiceItems(arrayFruit, selectIndex, new DialogInterface
                        .OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        selectIndex = which;
                    }
                });
                dialog4.setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    // which不是被选中项目，按钮与选项无关
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Toast.makeText(MainActivity.this, arrayFruit[selectIndex], Toast
                                .LENGTH_SHORT).show();
                    }
                });
                dialog4.show();
                break;
            case R.id.button5:
                // 自定义样式填充
                AlertDialog.Builder dialog5 = new AlertDialog.Builder(this);
                LayoutInflater inflater = LayoutInflater.from(this);
            View rootView = inflater.inflate(R.layout.dialog_login, null); //因为弹出一个窗口，所以没有root,null
                dialog5.setTitle("登录");
                dialog5.setView(rootView);
                dialog5.show();
                break;
            case R.id.button6:
                // 多选，带确认按钮
                AlertDialog.Builder dialog6 = new AlertDialog.Builder(this);
                dialog6.setTitle("多选");
                dialog6.setIcon(R.mipmap.ic_launcher);
                dialog6.setMultiChoiceItems(arrayFruit, checkedItems, new DialogInterface
                        .OnMultiChoiceClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which, boolean isChecked) {
                        String string;
                        if (isChecked) {
                            string = "被选中了";
                        } else {
                            string = "被取消了";
                        }
                        Toast.makeText(MainActivity.this, arrayFruit[which] + string, Toast
                                .LENGTH_SHORT).show();
                    }
                });
                dialog6.setPositiveButton("确定", new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        StringBuffer buffer = new StringBuffer();
                        for (int i = 0; i < arrayFruit.length; i++) {
                            if (checkedItems[i]) {
                                buffer.append(arrayFruit[i]);
                            }
                        }
                        Toast.makeText(MainActivity.this, "被选中的水果: " + buffer.toString(), Toast
                                .LENGTH_SHORT).show();
                    }
                });
                dialog6.show();
                break;
            case R.id.button7:
                // DatePickerDialog minsdk最低版本24，此处只有在系统版本大于24时执行有效
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                    DatePickerDialog dialog7 = new DatePickerDialog(this);
                    final Calendar calendar = Calendar.getInstance();
                    dialog7.setOnDateSetListener(new DatePickerDialog.OnDateSetListener() {
                        @Override
                        public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                            calendar.set(Calendar.YEAR, year);
                            calendar.set(Calendar.MONTH, month);
                            calendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                            String result = "日期: "
                                    + calendar.get(Calendar.YEAR) + "-"
                                    + calendar.get(Calendar.MONTH) + "-"
                                    + calendar.get(Calendar.DAY_OF_MONTH);
                            Toast.makeText(MainActivity.this, result , Toast.LENGTH_SHORT).show();
                        }
                    });
                    dialog7.show();
                }
                break;
        }
    }
}

```



##### Example 17 Capture & Gallery

声明外存储写入权限  
`<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />`

在配置中通过screenOrientation属性，将Activity强制设为横向或纵向屏幕，防止手机晃动后activity重置  

```xml
<activity android:name=".MainActivity" android:screenOrientation="portrait">   ...
```

在xml资源目录下，创建共享目录配置  

```xml
res/xml/files_path
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <!-- 相当于Environment.getExternalStorageDirectory()获取的公共空间根路径，被替换 -->
    <external-path name="public_path" path="/" />
    <!-- 还可声明其他私有、缓存、外存储得到空间 -->
</paths>
```

在项目配置注册provider，并引用共享配置  

```xml
AndroidManifest
<!-- authorities一般与applicationId相同，即应用包名称 -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.example.example17"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>
```



在activity自定义照相请求码，写入权限码  
在公共空间/DCIM/Camera/下，创建一个指定名称的图片文件，用于保存照片  
创建拍照方法，基于FileProvider获取图片URI地址  
启动需要结果的照相intent，封装请求吗及强制文件存储的URI地址    
重写onActivityResult()方法，基于请求码判断返回的执行请求  
未防止OOM，将图片按1/4渲染  

Android6以后，要求运行时动态申请权限(类似iOS)  
https://developer.android.google.cn/training/permissions/requesting  
重写onRequestPermissionsResult()方法，在用户授权后执行拍照方法  
刷新相册(可选)  

模拟器，可通过按住alt+鼠标移动镜头，wasd控制方向  Capture



##### Example 18 Notification

<https://developer.android.google.cn/training/notify-user/build-notification> 构造Notification，声明必须属性
创建PendingIntent对象，封装点击通知intent
基于版本构造NotificationChannel
发送通知



##### Example 19 Service

<https://developer.android.google.cn/guide/components/services.html>
<https://developer.android.google.cn/guide/components/bound-services.html>
<https://developer.android.google.cn/training/run-background-service/create-service.html>

自定义服务，封装操作值
重写onCreate()方法，创建子线程执行操作
自定义Binder子类，重写onBind()方法
重写onStartCommand()方法，接收初始化参数
修改项目配置，注册自定义服务

在activity中，自定义类实现ServiceConnection接口
基于自定义ServiceConnection服务连接类获取绑定对象
与服务互交，完成操作



##### Example 20 BroadcastReceiver

<https://developer.android.google.cn/reference/android/content/BroadcastReceiver.html>

自定义接收器，重写onReceive()方法，监听指定action操作
自定义服务，在服务中注册/注销接收器，并声明监听的action
在项目配置中，注册服务，接收器
在activity中启动服务，监听action变化

