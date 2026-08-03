import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class RemoteClassroomPage extends StatefulWidget {
  const RemoteClassroomPage({super.key});

  @override
  State<RemoteClassroomPage> createState() => _RemoteClassroomPageState();
}

class _RemoteClassroomPageState extends State<RemoteClassroomPage> {
  final List<String> _students = ['李小明', '王芳芳', '张伟', '陈亮亮', '赵子涵', '孙悦'];

  // Real Webcam Controller
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraLoading = false;

  // MP4 Local/Sample Video Player Controller
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isVideoLoading = false;
  String? _loadedVideoName;

  static const List<String> _localModes = [
    '数字课堂',
    '分组教学',
    '分层教学',
    '翻转课堂',
    'PBL教学',
  ];

  static const List<String> _interactiveModes = [
    '智慧课堂',
    '融合课堂',
    '三个课堂',
    '在线课堂',
    '网络研修',
    '听课评课',
    '集体磨课',
    '家校互动',
  ];

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  // Toggle Real Webcam
  Future<void> _toggleCamera() async {
    // Turn off video player if active
    if (_isVideoInitialized) {
      await _videoPlayerController?.pause();
      await _videoPlayerController?.dispose();
      _videoPlayerController = null;
      _isVideoInitialized = false;
    }

    if (_isCameraInitialized) {
      await _cameraController?.dispose();
      _cameraController = null;
      setState(() {
        _isCameraInitialized = false;
      });
    } else {
      setState(() => _isCameraLoading = true);
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          _cameraController = CameraController(
            cameras.first,
            ResolutionPreset.high,
            enableAudio: false,
          );
          await _cameraController!.initialize();
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
              _isCameraLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() => _isCameraLoading = false);
            showTechNoticeDialog(
              context,
              title: '物理摄像头状态',
              message: '未检测到可用物理摄像头，已自动切换为全景 4K 仿真画质。',
              icon: Icons.videocam_off,
            );
          }
        }
      } catch (e) {
        debugPrint('Camera initialization error: $e');
        if (mounted) {
          setState(() => _isCameraLoading = false);
          showTechNoticeDialog(
            context,
            title: '摄像头初始化异常',
            message: '摄像头初始化状态: $e，系统已无缝回退至高清仿真流。',
            icon: Icons.error_outline,
          );
        }
      }
    }
  }

  // Pick and Play Local MP4 Video File
  Future<void> _pickAndPlayLocalMp4() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'm4v', 'mkv', 'avi'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        await _initializeMp4File(File(filePath), fileName);
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      if (mounted) {
        showTechNoticeDialog(
          context,
          title: '文件选择提示',
          message: '选择本地 MP4 视频出错: $e',
          icon: Icons.error_outline,
        );
      }
    }
  }

  // Play Sample MP4 Stream
  Future<void> _playSampleMp4() async {
    const sampleUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    await _initializeMp4Url(sampleUrl, '示例智慧公开课_物理演示.mp4');
  }

  Future<void> _initializeMp4File(File file, String name) async {
    setState(() => _isVideoLoading = true);
    // Turn off camera if active
    if (_isCameraInitialized) {
      await _cameraController?.dispose();
      _cameraController = null;
      _isCameraInitialized = false;
    }

    await _videoPlayerController?.dispose();

    try {
      _videoPlayerController = VideoPlayerController.file(file);
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      await _videoPlayerController!.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _isVideoLoading = false;
          _loadedVideoName = name;
        });
      }
    } catch (e) {
      debugPrint('Error loading local MP4: $e');
      if (mounted) {
        setState(() => _isVideoLoading = false);
        showTechNoticeDialog(
          context,
          title: '视频解析状态',
          message: '解析本地 MP4 文件失败: $e',
          icon: Icons.error_outline,
        );
      }
    }
  }

  Future<void> _initializeMp4Url(String url, String name) async {
    setState(() => _isVideoLoading = true);
    if (_isCameraInitialized) {
      await _cameraController?.dispose();
      _cameraController = null;
      _isCameraInitialized = false;
    }

    await _videoPlayerController?.dispose();

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      await _videoPlayerController!.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _isVideoLoading = false;
          _loadedVideoName = name;
        });
      }
    } catch (e) {
      debugPrint('Error loading online MP4: $e');
      if (mounted) {
        setState(() => _isVideoLoading = false);
        showTechNoticeDialog(
          context,
          title: '网络 MP4 视频加载提示',
          message: '加载示例 MP4 视频网络流失败: $e',
          icon: Icons.error_outline,
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Top Interactive Control Bar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              '远程互动教学空间 (学生观看/录播演示)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TechBadge(
                            label: _isVideoInitialized
                                ? '学生观看模式: 本地MP4播放中'
                                : (appState.isStudentFocused
                                    ? '聚焦中: ${appState.focusedStudentName} 站立发言'
                                    : '名师视角全景监控'),
                            color: _isVideoInitialized
                                ? AppColors.accentOrange
                                : (appState.isStudentFocused
                                    ? AppColors.accentGreen
                                    : AppColors.primary),
                            icon: _isVideoInitialized
                                ? Icons.play_circle_fill
                                : (appState.isStudentFocused
                                    ? Icons.center_focus_strong
                                    : Icons.videocam),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isVideoInitialized
                            ? '当前播放文件: ${_loadedVideoName ?? "本地课程MP4"} • 支持实时进度拉拽与播放控制'
                            : '多端音画实时同步传输 • AI 自动视频聚焦与本地 MP4 视频演示支持',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Play Local MP4 Button
                TechButton(
                  label: _isVideoLoading
                      ? '加载MP4中...'
                      : (_isVideoInitialized ? '选择其他本地MP4' : '播放本地MP4视频'),
                  icon: Icons.folder_open,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
                  ),
                  onPressed: _isVideoLoading ? () {} : _pickAndPlayLocalMp4,
                ),
                const SizedBox(width: 8),

                // Play Sample MP4 Stream Button
                if (!_isVideoInitialized)
                  TechButton(
                    label: '演示示例MP4',
                    icon: Icons.play_arrow,
                    isSecondary: true,
                    onPressed: _playSampleMp4,
                  ),
                const SizedBox(width: 8),

                // Real Camera Toggle Button
                TechButton(
                  label: _isCameraLoading
                      ? '启动中...'
                      : (_isCameraInitialized ? '切回仿真流' : '开启摄像头'),
                  icon: _isCameraInitialized ? Icons.camera_alt : Icons.videocam,
                  isSecondary: !_isCameraInitialized,
                  onPressed: _isCameraLoading ? () {} : _toggleCamera,
                ),
                const SizedBox(width: 8),

                // Recording Control Button
                TechButton(
                  label: appState.isRecording ? '结束录播' : '开启录播',
                  icon: appState.isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
                  gradient: appState.isRecording
                      ? const LinearGradient(colors: [Colors.red, Colors.redAccent])
                      : AppColors.primaryGradient,
                  onPressed: () => appState.toggleRecording(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Teaching Mode Quick Select Ribbon
            TechCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              bgColor: AppColors.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      '互动教学应用:',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._interactiveModes.map((mode) {
                      final isSelected = appState.activeTeachingMode == mode;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(mode),
                          selected: isSelected,
                          onSelected: (_) => appState.setTeachingMode(mode),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.cardBg,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.cardBorder,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 16),
                    const Text(
                      '本地教学应用:',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._localModes.map((mode) {
                      final isSelected = appState.activeTeachingMode == mode;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(mode),
                          selected: isSelected,
                          onSelected: (_) => appState.setTeachingMode(mode),
                          selectedColor: AppColors.secondary,
                          backgroundColor: AppColors.cardBg,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.secondary : AppColors.cardBorder,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Video Wall Stage
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Video Stage (Supports Local MP4 Video Player / Real Webcam / Simulation)
                  Expanded(
                    flex: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isVideoInitialized
                              ? AppColors.accentOrange
                              : (appState.isStudentFocused
                                  ? AppColors.accentGreen
                                  : AppColors.primary),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isVideoInitialized
                                    ? AppColors.accentOrange
                                    : (appState.isStudentFocused
                                        ? AppColors.accentGreen
                                        : AppColors.primary))
                                .withOpacity(0.3),
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // 1. MP4 Local Video Player Mode
                          if (_isVideoInitialized && _videoPlayerController != null)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: AspectRatio(
                                  aspectRatio: _videoPlayerController!.value.aspectRatio > 0
                                      ? _videoPlayerController!.value.aspectRatio
                                      : 16 / 9,
                                  child: VideoPlayer(_videoPlayerController!),
                                ),
                              ),
                            )
                          // 2. Real Webcam Video Preview Mode
                          else if (_isCameraInitialized && _cameraController != null)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: CameraPreview(_cameraController!),
                              ),
                            )
                          // 3. High-Tech Simulated Master Class Video Mode
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    appState.isStudentFocused
                                        ? Icons.person_pin
                                        : Icons.cast_for_education,
                                    size: 80,
                                    color: (appState.isStudentFocused
                                            ? AppColors.accentGreen
                                            : AppColors.primary)
                                        .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    appState.isStudentFocused
                                        ? '【站立发言聚焦中】学生：${appState.focusedStudentName}'
                                        : '【名师主讲画面】张正平 特级教师 - 都市阳台东组团主教室',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '实时分辨率: 4K 60FPS • 音视频抖动率 < 0.1% • 支持点击右上角“播放本地MP4视频”',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                          // Top Stream Overlay info Badge
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                children: [
                                  PulseIndicator(
                                    color: _isVideoInitialized
                                        ? AppColors.accentOrange
                                        : (_isCameraInitialized
                                            ? AppColors.primary
                                            : (appState.isStudentFocused
                                                ? AppColors.accentGreen
                                                : AppColors.accentRed)),
                                    size: 10,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isVideoInitialized
                                        ? '学生听课视角 (本地 MP4 视频播放中)'
                                        : (_isCameraInitialized
                                            ? '真实物理摄像头画面 (实时采集)'
                                            : (appState.isStudentFocused
                                                ? '智能追焦镜头已启用'
                                                : '主讲画面 LIVE')),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // MP4 Video Scrub Bar & Floating Player Controls (When MP4 is active)
                          if (_isVideoInitialized && _videoPlayerController != null)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: ValueListenableBuilder(
                                valueListenable: _videoPlayerController!,
                                builder: (context, VideoPlayerValue val, child) {
                                  final position = val.position;
                                  final duration = val.duration;

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.cardBorder),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Video Scrub Slider
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 4,
                                            thumbShape: const RoundSliderThumbShape(
                                                enabledThumbRadius: 6),
                                            overlayShape: const RoundSliderOverlayShape(
                                                overlayRadius: 12),
                                            activeTrackColor: AppColors.accentOrange,
                                            inactiveTrackColor: Colors.white24,
                                            thumbColor: AppColors.accentOrange,
                                          ),
                                          child: Slider(
                                            min: 0.0,
                                            max: duration.inMilliseconds > 0
                                                ? duration.inMilliseconds.toDouble()
                                                : 1.0,
                                            value: position.inMilliseconds
                                                .clamp(0, duration.inMilliseconds)
                                                .toDouble(),
                                            onChanged: (v) {
                                              _videoPlayerController!
                                                  .seekTo(Duration(milliseconds: v.toInt()));
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            // Play / Pause Button
                                            IconButton(
                                              icon: Icon(
                                                val.isPlaying
                                                    ? Icons.pause_circle_filled
                                                    : Icons.play_circle_filled,
                                                color: AppColors.accentOrange,
                                                size: 32,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  val.isPlaying
                                                      ? _videoPlayerController!.pause()
                                                      : _videoPlayerController!.play();
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 8),

                                            // Time Display
                                            Text(
                                              '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'monospace',
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Spacer(),

                                            // Close MP4 Player
                                            TextButton.icon(
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white70, size: 16),
                                              label: const Text('退出MP4演示',
                                                  style: TextStyle(
                                                      color: Colors.white70, fontSize: 12)),
                                              onPressed: () {
                                                _videoPlayerController?.pause();
                                                _videoPlayerController?.dispose();
                                                _videoPlayerController = null;
                                                setState(() {
                                                  _isVideoInitialized = false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          // Electronic Whiteboard Toolbar (When MP4 is not active)
                          else
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.cardBorder),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: const [
                                    _BoardToolIcon(Icons.edit, '电子画笔'),
                                    _BoardToolIcon(Icons.crop_square, '板书批注'),
                                    _BoardToolIcon(Icons.touch_app, '抢答点名'),
                                    _BoardToolIcon(Icons.poll, '随堂测验'),
                                    _BoardToolIcon(Icons.auto_graph, 'AI注意力打分'),
                                    _BoardToolIcon(Icons.share, '屏幕共享'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Sidebar: Student Grid & Speaker Focus Controls
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        TechCard(
                          bgColor: AppColors.surface,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '远端听课教室学生镜头 (支持点击聚焦)',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.grid_view, color: AppColors.primary, size: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Grid of student interactive windows
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: _students.length,
                            itemBuilder: (context, index) {
                              final studentName = _students[index];
                              final isFocused =
                                  appState.isStudentFocused && appState.focusedStudentName == studentName;

                              return InkWell(
                                onTap: () => appState.toggleStudentFocus(studentName),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isFocused ? AppColors.accentGreen : AppColors.cardBorder,
                                      width: isFocused ? 2 : 1,
                                    ),
                                    boxShadow: isFocused
                                        ? [
                                            BoxShadow(
                                              color: AppColors.accentGreen.withOpacity(0.4),
                                              blurRadius: 10,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      // If student is focused & video is playing, overlay thumbnail
                                      if (isFocused && _isVideoInitialized && _videoPlayerController != null)
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: VideoPlayer(_videoPlayerController!),
                                          ),
                                        )
                                      else
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: isFocused
                                                    ? AppColors.accentGreen.withOpacity(0.2)
                                                    : AppColors.primary.withOpacity(0.15),
                                                child: Icon(
                                                  Icons.person,
                                                  color: isFocused
                                                      ? AppColors.accentGreen
                                                      : AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                studentName,
                                                style: TextStyle(
                                                  color: isFocused
                                                      ? AppColors.accentGreen
                                                      : AppColors.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                index % 2 == 0 ? '举手请求发言' : '专注听课中',
                                                style: TextStyle(
                                                  color: index % 2 == 0
                                                      ? AppColors.accentOrange
                                                      : AppColors.textMuted,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      // Focus Status Badge on thumbnail
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: isFocused
                                            ? const TechBadge(
                                                label: '聚焦中',
                                                color: AppColors.accentGreen,
                                              )
                                            : Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  '点击发言聚焦',
                                                  style: TextStyle(
                                                      color: AppColors.textMuted, fontSize: 9),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardToolIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BoardToolIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
        ),
      ],
    );
  }
}
