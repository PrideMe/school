#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <fstream>
#include <iostream>
#include <chrono>
#include <iomanip>
#include <sstream>

#include "flutter_window.h"
#include "utils.h"

static void WriteLog(const std::string& message) {
  std::ofstream log_file("error.log", std::ios::app);
  if (log_file.is_open()) {
    auto now = std::chrono::system_clock::now();
    auto in_time_t = std::chrono::system_clock::to_time_t(now);
    std::tm time_info;
    localtime_s(&time_info, &in_time_t);
    log_file << "[" << std::puttime(&time_info, "%Y-%m-%d %H:%M:%S") << "] " << message << "\n";
    log_file.flush();
  }
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Clear or start fresh error.log
  {
    std::ofstream log_file("error.log", std::ios::trunc);
    log_file << "==================== SCHOOL APP STARTUP LOG ====================\n";
  }

  WriteLog("[MAIN] Application wWinMain starting...");

  // Attach console when parent CMD is present or redirect stdout/stderr to error.log
  if (::AttachConsole(ATTACH_PARENT_PROCESS)) {
    FILE* unused;
    freopen_s(&unused, "CONOUT$", "w", stdout);
    freopen_s(&unused, "CONOUT$", "w", stderr);
    WriteLog("[MAIN] Attached to parent console.");
  } else if (::IsDebuggerPresent()) {
    CreateAndAttachConsole();
    WriteLog("[MAIN] Created and attached debugger console.");
  } else {
    FILE* unused;
    freopen_s(&unused, "error.log", "a", stdout);
    freopen_s(&unused, "error.log", "a", stderr);
    WriteLog("[MAIN] Redirected stdout/stderr to error.log.");
  }

  try {
    WriteLog("[MAIN] Initializing COM...");
    HRESULT hr = ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    if (FAILED(hr)) {
      std::stringstream ss;
      ss << "[MAIN ERROR] CoInitializeEx failed with HRESULT: 0x" << std::hex << hr;
      WriteLog(ss.str());
    } else {
      WriteLog("[MAIN] COM initialized successfully.");
    }

    WriteLog("[MAIN] Initializing DartProject(L\"data\")...");
    flutter::DartProject project(L"data");

    std::vector<std::string> command_line_arguments = GetCommandLineArguments();
    project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

    WriteLog("[MAIN] Creating FlutterWindow...");
    FlutterWindow window(project);
    Win32Window::Point origin(10, 10);
    Win32Window::Size size(1280, 720);

    if (!window.Create(L"school", origin, size)) {
      DWORD last_error = ::GetLastError();
      std::stringstream ss;
      ss << "[MAIN ERROR] window.Create() returned false! GetLastError: " << last_error;
      WriteLog(ss.str());

      std::string msg = "应用启动初始化失败！详细信息已写入目录下的 error.log。\nWin32 错误码: " + std::to_string(last_error);
      ::MessageBoxA(nullptr, msg.c_str(), "启动失败", MB_ICONERROR | MB_OK);
      return EXIT_FAILURE;
    }

    WriteLog("[MAIN] Window created successfully. Setting QuitOnClose...");
    window.SetQuitOnClose(true);

    WriteLog("[MAIN] Entering Win32 message loop...");
    ::MSG msg;
    while (::GetMessage(&msg, nullptr, 0, 0)) {
      ::TranslateMessage(&msg);
      ::DispatchMessage(&msg);
    }

    WriteLog("[MAIN] Message loop exited. Uninitializing COM...");
    ::CoUninitialize();
    WriteLog("[MAIN] Application exiting cleanly.");
    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::string err = std::string("[MAIN EXCEPTION] Caught std::exception: ") + e.what();
    WriteLog(err);
    ::MessageBoxA(nullptr, err.c_str(), "Uncaught Exception", MB_ICONERROR | MB_OK);
    return EXIT_FAILURE;
  } catch (...) {
    WriteLog("[MAIN EXCEPTION] Caught unknown exception!");
    ::MessageBoxA(nullptr, "Caught unknown C++ exception during startup!", "Uncaught Exception", MB_ICONERROR | MB_OK);
    return EXIT_FAILURE;
  }
}
