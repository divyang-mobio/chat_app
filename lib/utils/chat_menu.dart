import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeepMenus extends StatefulWidget {
  final Widget child;
  final Widget? bodyMenu;
  final Widget? headMenu;
  final bool vibration;

  const DeepMenus({
    required this.child,
    this.bodyMenu,
    this.headMenu,
    this.vibration = true,
    Key? key,
  }) : super(key: key);

  @override
  _DeepMenusState createState() => _DeepMenusState();
}

class _DeepMenusState extends State<DeepMenus>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Key uniqKey;

  Size? headMenuSize;
  bool _prepare = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );
    animation = Tween(begin: 1.0, end: 0.97)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(controller);
    uniqKey = UniqueKey();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  RenderBox get _renderBox {
    return context.findRenderObject() as RenderBox;
  }

  _openMenu() async {
    if (widget.vibration) {
      HapticFeedback.lightImpact();
    }
    await Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 0),
          reverseTransitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
                opacity: animation,
                child: DeepMenuDetails(
                  uniqKey: uniqKey,
                  bodyMenu: widget.bodyMenu,
                  headMenu: widget.headMenu,
                  headMenuSize: headMenuSize,
                  content: widget.child,
                  renderBox: _renderBox,
                  animation: animation,
                ));
          },
          fullscreenDialog: true,
          opaque: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onLongPress: () {
              // controller.reverse();
              _openMenu();
            },
            onTapDown: (_) {
              // controller.forward();
              setState(() {
                _prepare = true;
              });
            },
            onTapUp: (_) {
              // controller.reverse();
            },
            child:  Hero(
              tag: uniqKey,
              child: widget.child,
            )),
        if (_prepare && widget.headMenu != null)
          MeasureWidget(
              child: widget.headMenu!,
              onRender: (renderBox) {
                setState(() {
                  headMenuSize = renderBox.size;
                });
              }),
      ],
    );
  }
}

class DeepMenuDetails extends StatefulWidget {
  final Widget content;
  final Widget? bodyMenu;
  final Color color;
  final Widget? headMenu;
  final Size? headMenuSize;
  final RenderBox renderBox;
  late final Animation<double> animation;

  final double spacing;
  final Key uniqKey;

  DeepMenuDetails({
    required this.bodyMenu,
    required this.content,
    required this.renderBox,
    required animation,
    required this.uniqKey,
    this.headMenu,
    this.headMenuSize,
    this.color = Colors.black,
    this.spacing = 10.0,
    Key? key,
  }) : super(key: key) {
    this.animation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(animation);
  }

  @override
  State<DeepMenuDetails> createState() => _DeepMenuDetailsState();
}

class _DeepMenuDetailsState extends State<DeepMenuDetails> {
  late ScrollController scrollController;
  final _offstageKey = GlobalKey();

  Size get contentSize {
    return widget.renderBox.size;
  }

  Offset get contentOffset {
    return widget.renderBox.localToGlobal(Offset.zero);
  }

  double get _headMenuSize {
    return widget.headMenuSize != null
        ? widget.headMenuSize!.height + widget.spacing
        : 0;
  }

  double get _paddingTop {
    final topPadding = MediaQuery.of(context).padding.top;
    return contentOffset.dy > topPadding
        ? contentOffset.dy - _headMenuSize
        : topPadding + 20;
  }

  double get _paddingBottom {
    return MediaQuery.of(context).padding.bottom + 20;
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void _onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: _onBack,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: _buildBackdrop(context)),
              SingleChildScrollView(
                  padding:
                  EdgeInsets.only(top: _paddingTop, bottom: _paddingBottom),
                  controller: scrollController,
                  child: _buildScrollBody()),
            ],
          ),
        ));
  }

  Widget _buildScrollBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headMenu != null)
          Container(
            key: _offstageKey,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                bottom: widget.spacing,
                left: widget.spacing,
                right: widget.spacing),
            child: _buildHeadMenu(),
          ),
        Center(
          child: _buildContent(),
        ),
        if (widget.bodyMenu != null)
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
                top: widget.spacing,
                left: widget.spacing,
                right: widget.spacing),
            child: _buildBodyMenu(),
          ),
      ],
    );
  }

  Widget _buildBackdrop(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: (widget.color).withOpacity(0.2),
      ),
    );
  }

  Widget _buildContent() {
    return AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          width: contentSize.width,
          height: contentSize.height,
          child: Hero(
            tag: widget.uniqKey,
            child: widget.content,
          ),
        ));
  }

  Widget _buildBodyMenu() {
    return ScaleTransition(
      scale: widget.animation,
      alignment: Alignment.topCenter,
      child: widget.bodyMenu,
    );
  }

  Widget _buildHeadMenu() {
    return ScaleTransition(
      scale: widget.animation,
      alignment: Alignment.bottomCenter,
      child: widget.headMenu,
    );
  }
}

class MeasureWidget extends StatefulWidget {
  final Widget child;
  final void Function(RenderBox) onRender;

  const MeasureWidget({
    required this.child,
    required this.onRender,
    Key? key,
  }) : super(key: key);

  @override
  State<MeasureWidget> createState() => _MeasureWidgetState();
}

class _MeasureWidgetState extends State<MeasureWidget> {
  bool _initialized = false;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _key.currentContext!;
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      widget.onRender(renderBox);
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: true,
        child: Container(
          key: _key,
          child: _initialized ? null : widget.child,
        ));
  }
}


class DeepMenuItem extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final void Function() onTap;

  const DeepMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: kMinInteractiveDimension,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [label, if (icon != null) icon!],
            ),
          ),
        ),
      ),
    );
  }
}

class DeepMenuList extends StatelessWidget {
  final List<DeepMenuItem> items;

  const DeepMenuList({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            ...items
                .sublist(0, items.length - 1)
                .map((e) => Container(
              decoration: _dividerDecoration(context),
              child: e,
            ))
                .toList(),
            items.last
          ],
        ));
  }

  Decoration _dividerDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: theme.dividerColor, width: 1.0),
      ),
    );
  }
}

