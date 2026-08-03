import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class RemoteClassroomPage extends StatefulWidget {
  const RemoteClassroomPage({super.key});

  @override
  State<RemoteClassroomPage> createState() => _RemoteClassroomPageState();
}

class _RemoteClassroomPageState extends State<RemoteClassroomPage>
    with SingleTickerProviderStateMixin {
  final List<String> _students = ['李小明', '王芳芳', '张伟', '陈亮亮', '赵子涵', '孙悦'];

  // Simulated video playback state
  bool _isSimVideoPlaying = false;
  String? _simVideoName;
  Duration _simPosition = Duration.zero;
  final Duration _simDuration = const Duration(minutes: 12, seconds: 34);
  Timer? _simTimer;

  // Simulated camera state
  bool _isSimCameraOn = false;

  late AnimationController _pulseController;

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
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleSimCamera() {
    if (_isSimVideoPlaying) {
      _stopSimVideo();
    }
    setState(() {
      _isSimCameraOn = !_isSimCameraOn;
    });
  }

  void _startSimVideo(String name) {
    if (_isSimCameraOn) {
      setState(() => _isSimCameraOn = false);
    }
    _simTimer?.cancel();
    setState(() {
      _isSimVideoPlaying = true;
      _simVideoName = name;
      _simPosition = Duration.zero;
    });
    _simTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _simPosition += const Duration(seconds: 1);
        if (_simPosition >= _simDuration) {
          _simPosition = Duration.zero; // loop
        }
      });
    });
  }

  void _stopSimVideo() {
    _simTimer?.cancel();
    setState(() {
      _isSimVideoPlaying = false;
      _simVideoName = null;
      _simPosition = Duration.zero;
    });
  }

  void _toggleSimPlayPause() {
    if (_simTimer?.isActive == true) {
      _simTimer?.cancel();
      setState(() {});
    } else if (_isSimVideoPlaying) {
      _simTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _simPosition += const Duration(seconds: 1);
          if (_simPosition >= _simDuration) {
            _simPosition = Duration.zero;
          }
        });
      });
      setState(() {});
    }
  }

  bool get _isSimPlaying => _simTimer?.isActive == true;

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
                            label: _isSimVideoPlaying
                                ? '学生观看模式: 本地MP4播放中'
                                : (appState.isStudentFocused
                                    ? '聚焦中: ${appState.focusedStudentName} 站立发言'
                                    : '名师视角全景监控'),
                            color: _isSimVideoPlaying
                                ? AppColors.accentOrange
                                : (appState.isStudentFocused
                                    ? AppColors.accentGreen
                                    : AppColors.primary),
                            icon: _isSimVideoPlaying
                                ? Icons.play_circle_fill
                                : (appState.isStudentFocused
                                    ? Icons.center_focus_strong
                                    : Icons.videocam),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSimVideoPlaying
                            ? '当前播放文件: ${_simVideoName ?? "本地课程MP4"} • 支持实时进度拉拽与播放控制'
                            : '多端音画实时同步传输 • 自动视频追焦与本地 MP4 视频演示支持',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Play Local MP4 Button (simulated)
                TechButton(
                  label: _isSimVideoPlaying ? '切换MP4课件' : '播放本地MP4视频',
                  icon: Icons.folder_open,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
                  ),
                  onPressed: () {
                    _startSimVideo('校本教研课件_物理光学_v2.mp4');
                  },
                ),
                const SizedBox(width: 8),

                // Play Sample MP4 Stream Button
                if (!_isSimVideoPlaying)
                  TechButton(
                    label: '演示示例MP4',
                    icon: Icons.play_arrow,
                    isSecondary: true,
                    onPressed: () {
                      _startSimVideo('示例智慧公开课_物理演示.mp4');
                    },
                  ),
                const SizedBox(width: 8),

                // Camera Toggle Button (simulated)
                TechButton(
                  label: _isSimCameraOn ? '切回仿真流' : '开启摄像头',
                  icon: _isSimCameraOn ? Icons.camera_alt : Icons.videocam,
                  isSecondary: !_isSimCameraOn,
                  onPressed: _toggleSimCamera,
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
                  // Main Video Stage
                  Expanded(
                    flex: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isSimVideoPlaying
                              ? AppColors.accentOrange
                              : (appState.isStudentFocused
                                  ? AppColors.accentGreen
                                  : AppColors.primary),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isSimVideoPlaying
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
                          // 1. Simulated MP4 Video Player Mode
                          if (_isSimVideoPlaying)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: _buildSimulatedVideoView(),
                              ),
                            )
                          // 2. Simulated Webcam Preview Mode
                          else if (_isSimCameraOn)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: _buildSimulatedCameraView(),
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
                                    '实时分辨率: 4K 60FPS • 音视频抖动率 < 0.1% • 支持点击右上角"播放本地MP4视频"',
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
                                    color: _isSimVideoPlaying
                                        ? AppColors.accentOrange
                                        : (_isSimCameraOn
                                            ? AppColors.primary
                                            : (appState.isStudentFocused
                                                ? AppColors.accentGreen
                                                : AppColors.accentRed)),
                                    size: 10,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isSimVideoPlaying
                                        ? '学生听课视角 (本地 MP4 视频播放中)'
                                        : (_isSimCameraOn
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

                          // MP4 Video Scrub Bar & Floating Player Controls
                          if (_isSimVideoPlaying)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Container(
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
                                        max: _simDuration.inMilliseconds.toDouble(),
                                        value: _simPosition.inMilliseconds
                                            .clamp(0, _simDuration.inMilliseconds)
                                            .toDouble(),
                                        onChanged: (v) {
                                          setState(() {
                                            _simPosition =
                                                Duration(milliseconds: v.toInt());
                                          });
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // Play / Pause Button
                                        IconButton(
                                          icon: Icon(
                                            _isSimPlaying
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_filled,
                                            color: AppColors.accentOrange,
                                            size: 32,
                                          ),
                                          onPressed: _toggleSimPlayPause,
                                        ),
                                        const SizedBox(width: 8),

                                        // Time Display
                                        Text(
                                          '${_formatDuration(_simPosition)} / ${_formatDuration(_simDuration)}',
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
                                          onPressed: _stopSimVideo,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                                    _BoardToolIcon(Icons.auto_graph, '课堂注意力统计'),
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

  /// Simulated video playback view with animated gradient
  Widget _buildSimulatedVideoView() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1a1a2e),
                Color.lerp(
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                  _pulseController.value,
                )!,
                const Color(0xFF1a1a2e),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 72,
                  color: AppColors.accentOrange.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _simVideoName ?? '课件视频播放中',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '分辨率: 1920×1080 • 编码: H.264/AAC • 码率: 8Mbps',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Simulated camera view with scan line animation
  Widget _buildSimulatedCameraView() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0d1117),
                Color.lerp(
                  const Color(0xFF161b22),
                  const Color(0xFF0d1117),
                  _pulseController.value,
                )!,
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 72,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '物理摄像头实时采集中',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '设备: HD WebCam • 采集帧率: 30FPS • 延迟: <50ms',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Scan line effect
              Positioned(
                top: MediaQuery.of(context).size.height * _pulseController.value * 0.4,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
