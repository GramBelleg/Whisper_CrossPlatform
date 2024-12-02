import 'package:flutter/material.dart';

class VisibilitySettingsKeys {
  
  // in the settings page under Privacy settings section
  static const visibilitySettingsTile = Key('visibilitySettingsTile');
  static const blockedUsersTile = Key('blockedUsersTile');
  static const addMeToGroupsTile = Key('addMeToGroupsTile');
  

  // inside VisibilitySettingsPage
  static const profilePictureTile = Key('profilePictureTile');
  static const lastSeenTile = Key('lastSeenTile');
  static const storiesTile = Key('storiesTile');
  static const readReceiptsSwitch = Key('readReceiptsSwitch');
  
  // options in the visibility settings
  static const everyoneRadio = Key('everyoneRadio');
  static const contactsRadio = Key('contactsRadio');
  static const nobodyRadio = Key('nobodyRadio');
}
