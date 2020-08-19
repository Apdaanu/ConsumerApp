import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/constants/connection.dart';
import '../../../../core/constants/measure.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/token/token_provider.dart';
import '../../../../data/models/chat/chat_model.dart';
import '../../../../domain/entities/chat/chat.dart';
import '../../../../domain/usecases/chat/get_chat_messages.dart';
import '../../../../domain/usecases/chat/send_chat_message.dart';
import '../../../../injection_container.dart';
import '../../../widgets/display_screen.dart';
import '../../../widgets/regular_text.dart';
import '../../../widgets/top_bar.dart';
import '../../bottom_nav_holder/blocs/user_details_bloc/user_details_bloc.dart';
import '../chat_bloc/chat_bloc.dart';

class CustomerSupportChatScreen extends StatefulWidget {
  final int code;
  const CustomerSupportChatScreen({Key key, this.code}) : super(key: key);

  @override
  _CustomerSupportChatScreenState createState() =>
      _CustomerSupportChatScreenState();
}

class _CustomerSupportChatScreenState extends State<CustomerSupportChatScreen> {
  UserDetailsBloc _userDetailsBloc;
  GlobalKey stickyKey = GlobalKey();
  TokenProvider tokenProvider;
  Socket socket;
  List<dynamic> messages = List<dynamic>();
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  GetChatMessages getChatMessages;
  SendChatMessage sendChatMessage;

  @override
  void initState() {
    super.initState();
    tokenProvider = sl<TokenProvider>();
    getChatMessages = sl<GetChatMessages>();
    sendChatMessage = sl<SendChatMessage>();
    _userDetailsBloc = context.bloc<UserDetailsBloc>();

    _initSocket();
  }

  @override
  void dispose() {
    socket.close();
    messages.clear();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    // print('[dbg] : ${stickyKey.currentContext}');
    return DisplayScreen(
      topBar: CustomTopBar(title: 'Chat Support'),
      body: Container(
        height: measure.bodyHeight,
        color: AppTheme.greyF5,
        child: Stack(
          children: <Widget>[
            Container(
              height: measure.bodyHeight - 20,
              width: measure.width,
              padding: EdgeInsets.only(bottom: measure.topBarHeight),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: renderChat(measure),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              key: stickyKey,
              child: ChatBottomTextField(
                controller: controller,
                focusNode: focusNode,
                sendMessage: () {
                  _sendChatMessage();
                },
                scroll: () {
                  _scrollToBottom();
                },
              ),
            ),
          ],
        ),
      ),
      failure: false,
      failureCode: 0,
    );
  }

  void _initSocket() async {
    final String token = await tokenProvider.getToken();
    final connectionParams = {
      'token': token,
      'id': _userDetailsBloc.userDetails.userId,
    };
    socket = IO.io(Connection.endpoint, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) {
      print('connect');
      socket.emit(
        'customer_support_chat_join',
        connectionParams,
      );
    });
    socket.on('room_join_success', (response) {
      print(response);
    });
    socket.on('message_for_support', (message) {
      print(message);
      final Chat chat = ChatModel.fromJson(message);
      setState(() {
        messages.add(chat);
      });
      _scrollToBottom();
    });
    socket.on('room_join_error', (error) {
      print(error);
    });

    print('[sys] : fetching chats');

    final failureOrChats = await getChatMessages(
      ChatParams(
        _userDetailsBloc.userDetails.userId,
      ),
    );
    failureOrChats.fold(
      (failure) {
        print('[err] : ${failure.code}');
      },
      (chats) async {
        print('[sys] : chats fetched');
        setState(() {
          messages = chats;
        });
        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() async {
    print('[dbg] : hi');
    await Future.delayed(Duration(milliseconds: 100));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  List<Widget> renderChat(Measure measure) {
    List<Widget> list = List<Widget>();

    list.add(SizedBox(height: 15));
    messages.forEach((element) {
      list.add(ChatBox(element: element));
    });
    list.add(SizedBox(height: 15));

    return list;
  }

  void _sendChatMessage() async {
    sendChatMessage(
      SendChatParams(
        userId: _userDetailsBloc.userDetails.userId,
        message: controller.text,
      ),
    ).then((_) {
      controller.text = '';
      focusNode.unfocus();
    });
  }

  double getHeight() {
    final keyContext = stickyKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      print('[dbg] : ${box.size.height}');
      return box.size.height;
    }
    return 0;
  }
}

class ChatBox extends StatelessWidget {
  final Chat element;

  const ChatBox({Key key, this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    CrossAxisAlignment crossAlignment = element.status == 'admin'
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;
    Alignment alignment = element.status == 'admin'
        ? Alignment.centerLeft
        : Alignment.centerRight;
    int turns = element.status == 'admin' ? 1 : 3;

    return Container(
      alignment: alignment,
      // margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: LimitedBox(
              maxWidth: measure.width * 0.6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppTheme.cartOrange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: element.status == 'admin'
                        ? Radius.zero
                        : Radius.circular(5),
                    bottomRight: element.status == 'admin'
                        ? Radius.circular(5)
                        : Radius.zero,
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  // borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: crossAlignment,
                  children: <Widget>[
                    SizedBox(height: 15),
                    // RegularText(
                    //   text: element.status,
                    //   color: Colors.grey[100],
                    //   fontSize: AppTheme.smallTextSize,
                    // ),
                    RegularText(
                      text: element.message,
                      color: Colors.white,
                      fontSize: AppTheme.regularTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: element.status == 'admin' ? null : 20,
            left: element.status == 'admin' ? 20 : null,
            bottom: 1,
            child: RotatedBox(
              quarterTurns: 0,
              child: ClipPath(
                clipper: element.status == 'admin'
                    ? TriangleClipperAdmin()
                    : TriangleClipperCustomer(),
                child: Container(
                  color: AppTheme.cartOrange,
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TriangleClipperCustomer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipperCustomer oldClipper) => false;
}

class TriangleClipperAdmin extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipperAdmin oldClipper) => false;
}

class ChatBottomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final sendMessage;
  final scroll;

  const ChatBottomTextField({
    Key key,
    this.controller,
    this.sendMessage,
    this.focusNode,
    this.scroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      width: measure.width,
      // height: measure.topBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: 5 + measure.width * 0.02,
        vertical: 5 + measure.screenHeight * 0.01,
      ),
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.insert_photo,
            color: AppTheme.black7,
            size: 24 * measure.fontRatio,
          ),
          SizedBox(width: 10),
          Expanded(
            // width: measure.width * 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(0, 0),
                    color: Color(0x29000000),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  print('[dbg] : hi');
                  scroll();
                },
                cursorColor: AppTheme.black3,
                controller: controller,
                focusNode: focusNode,
                cursorWidth: 2,
                maxLines: 8,
                minLines: 1,
                enabled: true,
                decoration: new InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0.1,
                      color: AppTheme.cartOrange,
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  hintText: 'Type...',
                  hintStyle: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: AppTheme.regularTextSize * measure.fontRatio,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.black7,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: AppTheme.regularTextSize * measure.fontRatio,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.black2,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              sendMessage();
            },
            child: CircleAvatar(
              backgroundColor: AppTheme.cartOrange,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 15 * measure.fontRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
