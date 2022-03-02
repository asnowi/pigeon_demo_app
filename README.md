# pigeon_demo_app

#######
前面我们讲到了Flutter与原生通信使用的是BasicMessageChannel，完全实现了接口解耦，通过协议来进行通信，但是这样的一个问题是，多端都需要维护一套协议规范，这样势必会导致协作开发时的通信成本，所以，Flutter官方给出了Pigeon这样一个解决方案。
Pigeon的存在就是为了解决多端通信的开发成本。其核心原理就是通过一套协议来生成多端的代码，这样多端只需要维护一套协议即可，其它代码都可以通过Pigeon来自动生成，这样就保证了多端的统一。
官方文档如下所示。
pub.flutter-io.cn/packages/pi…

引入
首先，需要dev_dependencies中引入Pigeon：
dev_dependencies:
  pigeon: ^1.0.15
复制代码
接下来，在Flutter的lib文件夹同级目录下，创建一个.dart文件，例如schema.dart，这里就是通信的协议文件。
例如我们需要多端统一的一个实体：Book，如下所示。
import 'package:pigeon/pigeon.dart';

class Book {
  String? title;
  String? author;
}

@HostApi()
abstract class NativeBookApi {
  List<Book?> getNativeBookSearch(String keyword);

  void doMethodCall();
}
复制代码
这就是我们的协议文件，其中@HostApi，代表从Flutter端调用原生侧的方法，如果是@FlutterApi，那么则代表从原生侧调用Flutter的方法。
生成
执行下面的指令，就可以让Pigeon根据协议来生成相应的代码，下面的这些配置，需要指定一些文件目录和包名等信息，我们可以将它保存到一个sh文件中，这样更新后，只需要执行下这个sh文件即可。
flutter pub run pigeon \
  --input schema.dart \
  --dart_out lib/pigeon.dart \
  --objc_header_out ios/Runner/pigeon.h \
  --objc_source_out ios/Runner/pigeon.m \
  --java_out ./android/app/src/main/java/dev/flutter/pigeon/Pigeon.java \
  --java_package "dev.flutter.pigeon"
复制代码
这里面比较重要的就是导入schema.dart文件，作为协议，再指定Dart、iOS和Android代码的输出路径即可。
正常情况下，生成完后的代码就可以直接使用了。

Pigeon生成的代码是Java和OC，主要是为了能够兼容更多的项目。你可以将它转化为Kotlin或者Swift。

使用
就以上面这个例子，我们来看下如何根据Pigeon生成的代码来进行跨端通信。
首先，在Android代码中，会生成一个同名协议的接口，NativeBookApi，对应上面HostApi注解标记的协议名。在FlutterActivity的继承类中，创建这个接口的实现类。
private class NativeBookApiImp(val context: Context) : Api.NativeBookApi {

    override fun getNativeBookSearch(keyword: String?): MutableList<Api.Book> {
        val book = Api.Book().apply {
            title = "android"
            author = "xys$keyword"
        }
        return Collections.singletonList(book)
    }

    override fun doMethodCall() {
        context.startActivity(Intent(context, FlutterMainActivity::class.java))
    }
}
复制代码
这里顺便提一下，engine使用FlutterEngineGroup的方式进行创建，如果是其它方式，按照不同的方法获取engine对象即可。
class SingleFlutterActivity : FlutterActivity() {

    val engine: FlutterEngine by lazy {
        val app = activity.applicationContext as QDApplication
        val dartEntrypoint =
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "main"
            )
        app.engines.createAndRunEngine(activity, dartEntrypoint)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Api.NativeBookApi.setup(flutterEngine.dartExecutor, NativeBookApiImp(this))
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return engine
    }

    override fun onDestroy() {
        super.onDestroy()
        engine.destroy()
    }
}
复制代码
初始化Pigeon的核心方法就是NativeBookApi中的setup方法，传入engine和协议的实现即可。
接下来，我们来看下如何在Flutter中调用这个方法，在有Pigeon之前，我们都是通过Channel，创建String类型的协议名来通信的，现在有了Pigeon之后，这些容易出错的String就都被隐藏起来了，全部变成了正常的方法调用。
在Flutter中，Pigeon自动创建了NativeBookApi类，而不是Android中的接口，在类中已经生成了getNativeBookSearch和doMethodCall这些协议中定义的方法。
List<Book?> list = await api.getNativeBookSearch("xxx");
setState(() => _counter = "${list[0]?.title} ${list[0]?.author}");
复制代码
通过await就可以很方便的进行调用了。可见，通过Pigeon进行封装后，跨端通信完全被协议所封装了，同时也隐藏了各种String的处理，这样就进一步降低了人工出错的可能性。
优化
在实际的使用中，Flutter调用原生方法来获取数据，原生侧处理好数据后回传给Flutter，所以在Pigeon生成的Android代码中，协议函数的实现是一个带返回值的方法，如下所示。
override fun getNativeBookSearch(keyword: String?): MutableList<Api.Book> {
    val book = Api.Book().apply {
        title = "android"
        author = "xys$keyword"
    }
    return Collections.singletonList(book)
}
复制代码
这个方法本身没有什么问题，假如是网络请求，可以使用OKHttp的success和fail回调来进行处理，但是，如果要使用协程呢？
由于协程破除了回调，所以无法在Pigeon生成的函数中使用，这时候，就需要修改协议，给方法增加一个@async注解，将它标记为一个异步函数。
我们修改协议，并重新生成代码。
@HostApi()
abstract class NativeBookApi {
  @async
  List<Book?> getNativeBookSearch(String keyword);

  void doMethodCall();
}
复制代码
这时候你会发现，NativeBookApi的实现函数中，带返回值的函数已经变成了void，同时提供了一个result变量来处理返回值的传递。
override fun getNativeBookSearch(keyword: String?, result: Api.Result<MutableList<Api.Book>>?)
复制代码
这样使用就非常简单了，将返回值通过result塞回去就好了。
有了这个方法，我们就可以将Pigeon和协程配合起来使用，开发体验瞬间上升。
private class NativeBookApiImp(val context: Context, val lifecycleScope: LifecycleCoroutineScope) : Api.NativeBookApi {
    override fun getNativeBookSearch(keyword: String?, result: Api.Result<MutableList<Api.Book>>?) {
        lifecycleScope.launch {
            try {
                val data = RetrofitClient.getCommonApi().getXXXXList().data
                val book = Api.Book().apply {
                    title = data.tagList.toString()
                    author = "xys$keyword"
                }
                result?.success(Collections.singletonList(book))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun doMethodCall() {
        context.startActivity(Intent(context, FlutterMainActivity::class.java))
    }
}
复制代码
协程+Pigeon YYDS。

这里只介绍了Flutter调用Android的场景，实际上Android调用Flutter也只是换了个方向而已，代码都是类似的，这里不赘述了，那iOS呢？——我写Flutter，关iOS什么事。

拆解
在了解了Pigeon如何使用之后，我们来看下，这只「鸽子」到底做了些什么。
从宏观上来看，不管是Dart端还是Android端，都是生成了三类东西。

数据实体类，例如上面的Book类
StandardMessageCodec，这是BasicMessageChannel的传输编码类
协议接口\类，例如上面的NativeBookApi

在Dart中，数据实体会自动帮你生成encode和decode的代码，这样你获取出来的数据就不再是Channel中的Object类型了，而是协议中定义的类型，极大的方便了开发者。
class Book {
  String? title;
  String? author;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['title'] = title;
    pigeonMap['author'] = author;
    return pigeonMap;
  }

  static Book decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return Book()
      ..title = pigeonMap['title'] as String?
      ..author = pigeonMap['author'] as String?;
  }
}
复制代码
在Android中，也是做的类似的操作，可以理解为用Java翻译了一遍。
下面是Codec，StandardMessageCodec是BasicMessageChannel的标准编解码器，传输的数据需要实现它的writeValue和readValueOfType方法。
class _NativeBookApiCodec extends StandardMessageCodec {
  const _NativeBookApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is Book) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return Book.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);

    }
  }
}
复制代码
同样的，Dart和Android代码几乎一致，也很好理解，毕竟是一套协议，规则是一样的。
下面就是Pigeon的核心了，我们来看具体的协议是如何实现的，首先来看下Dart中是如何实现的，由于我们是从Flutter中调用Android中的代码，所以按照Channel的原理来说，我们需要在Dart中申明一个Channel，并处理其返回的数据。

如果你熟悉Channel的使用，那么这段代码应该是比较清晰的。
下面再来看看Android中的实现。Android侧是事件的处理者，所以需要实现协议的具体内容，这就是我们前面实现的接口，另外，还需要添加setMessageHandler来处理具体的协议。

这里有点意思的地方是那个Reply类的封装。
public interface Result<T> {
  void success(T result);
  void error(Throwable error);
}
复制代码
前面我们说了，在Pigeon中可以通过@async来生成异步接口，这个异步接口的实现，实际上就是这里处理的。
看到这里，你应该几乎就了解了Pigeon到底是如何工作的了，说白了实际上就是通过build_runner来生成这些代码，把脏活累活都自己吞下去了，我们看见的，实际上就是具体协议类的实现和调用。
题外话
所以说，Pigeon并不是什么非常高深的内容，但却是Flutter混编的一个非常重要的思想，或者说是Flutter团队的一个指导思想，那就是通过「协议」「模板」来生成相关的代码，类似的还有JSON解析的例子，实际上也是如此。
再讲的多一点，Android模块之间的解耦、模块化操作，实际上是不是也能通过这种方式来处理呢？所以说，大道至简，殊途同归，软件工程做到最后，实际上思想都是类似的，万物斗转星移，唯有思想永恒。
向大家推荐下我的网站 xuyisheng.top/ 专注 Android-Kotlin-Flutter 欢迎大家访问

作者：xuyisheng
链接：https://juejin.cn/post/7065570838782672910
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
######