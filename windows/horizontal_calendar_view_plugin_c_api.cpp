#include "include/horizontal_calendar_view/horizontal_calendar_view_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "horizontal_calendar_view_plugin.h"

void HorizontalCalendarViewPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  horizontal_calendar_view::HorizontalCalendarViewPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
