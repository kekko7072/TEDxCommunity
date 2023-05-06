import 'package:flutter/cupertino.dart';
import 'package:tedxcommunity/services/imports.dart';

class IntroAlertDialog extends StatefulWidget {
  const IntroAlertDialog({Key? key}) : super(key: key);

  @override
  State<IntroAlertDialog> createState() => _IntroAlertDialogState();
}

class _IntroAlertDialogState extends State<IntroAlertDialog> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 8,
                horizontal: MediaQuery.of(context).size.width / 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CupertinoPageScaffold(
                resizeToAvoidBottomInset: false,
                navigationBar: CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  middle: Text(
                      AppLocalizations.of(context)!.welcomeToTEDxCommunity),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: _controller.value.isInitialized
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: VideoPlayer(_controller))
                                : Container(),
                          ),
                          Visibility(
                            visible: !_controller.value.isPlaying,
                            child: Center(
                              child: CupertinoButton(
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                                child: Icon(
                                  CupertinoIcons.play_circle_fill,
                                  color: Style.primaryColor,
                                  size: 100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: _controller.value.isPlaying,
                        child: IconButton(
                            onPressed: () =>
                                setState(() => _controller.pause()),
                            icon: Icon(
                              CupertinoIcons.stop_circle_fill,
                              color: Style.primaryColor,
                            )),
                      ),
                      Text(
                        AppLocalizations.of(context)!.whatIsTEDxCommunity,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Style.textColor(context)),
                      ),
                      /* Text(AppLocalizations.of(context)!.learnMoreAboutTEDxCommunity),
            Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SelectableText(
                        kGitHubReadmeLink,
                        style: const TextStyle(color: CupertinoColors.link),
                        onTap: () => launchUrlString(kGitHubReadmeLink),
                      ),
            ),*/
                      const SizedBox(height: 16.0),
                      Text(
                        '${AppLocalizations.of(context)!.developedWithLoveBy} ${AppLocalizations.of(context)!.developerName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Style.textColor(context)),
                      ),
                      CupertinoDialogAction(
                        child: Text(AppLocalizations.of(context)!.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
