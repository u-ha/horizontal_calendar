#ifndef FLUTTER_PLUGIN_HORIZONTAL_CALENDAR_VIEW_PLUGIN_H_
#define FLUTTER_PLUGIN_HORIZONTAL_CALENDAR_VIEW_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace horizontal_calendar_view {

class HorizontalCalendarViewPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HorizontalCalendarViewPlugin();

  virtual ~HorizontalCalendarViewPlugin();

  // Disallow copy and assign.
  HorizontalCalendarViewPlugin(const HorizontalCalendarViewPlugin&) = delete;
  HorizontalCalendarViewPlugin& operator=(const HorizontalCalendarViewPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace horizontal_calendar_view

#endif  // FLUTTER_PLUGIN_HORIZONTAL_CALENDAR_VIEW_PLUGIN_H_
