import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/account_lifecycle.dart';
import '../../data/app_data.dart' as data;
import '../../data/currency_localized_names.dart';
import '../../data/data_repository.dart';
import '../../data/user_settings.dart' as settings;
import '../../l10n/app_localizations.dart';
import '../../models/account.dart';
import '../../utils/balance_correction.dart';
import '../../utils/fx.dart' as fx;
import '../../utils/minor_units_amount_formatter.dart';
import '../../utils/persistence_guard.dart';
import '../../widgets/account_avatar.dart';

// ─── Account icon / color presets ─────────────────────────────────────────────
// Curated for personal finance, household, business, investing, and major spend.

class _AccountPickIconDef {
  const _AccountPickIconDef(this.icon, this.materialName);
  final IconData icon;
  final String materialName;
}

String _accountPickIconSearchHaystack(_AccountPickIconDef d) {
  final spaced = d.materialName.replaceAll('_', ' ');
  return '${d.materialName} $spaced';
}

bool _accountPickIconMatchesQuery(_AccountPickIconDef d, String queryRaw) {
  final q = queryRaw.toLowerCase().trim();
  if (q.isEmpty) return true;
  final hay = _accountPickIconSearchHaystack(d).toLowerCase();
  if (hay.contains(q)) return true;
  final parts =
      q.split(RegExp(r'\s+')).where((String s) => s.isNotEmpty).toList();
  if (parts.isEmpty) return true;
  for (final w in parts) {
    if (!hay.contains(w)) return false;
  }
  return true;
}

const List<_AccountPickIconDef> _kAccountPickIconDefs = <_AccountPickIconDef>[
  // People & relationships
  _AccountPickIconDef(Icons.person_rounded, 'person_rounded'),
  _AccountPickIconDef(Icons.people_alt_rounded, 'people_alt_rounded'),
  _AccountPickIconDef(Icons.groups_rounded, 'groups_rounded'),
  _AccountPickIconDef(Icons.diversity_3_rounded, 'diversity_3_rounded'),
  _AccountPickIconDef(Icons.child_care_rounded, 'child_care_rounded'),
  _AccountPickIconDef(Icons.elderly_rounded, 'elderly_rounded'),
  _AccountPickIconDef(Icons.badge_rounded, 'badge_rounded'),
  _AccountPickIconDef(Icons.support_agent_rounded, 'support_agent_rounded'),
  // Cash, cards & everyday banking
  _AccountPickIconDef(Icons.account_balance_wallet_rounded, 'account_balance_wallet_rounded'),
  _AccountPickIconDef(Icons.account_balance_rounded, 'account_balance_rounded'),
  _AccountPickIconDef(Icons.savings_outlined, 'savings_outlined'),
  _AccountPickIconDef(Icons.savings_rounded, 'savings_rounded'),
  _AccountPickIconDef(Icons.credit_card_rounded, 'credit_card_rounded'),
  _AccountPickIconDef(Icons.credit_score_rounded, 'credit_score_rounded'),
  _AccountPickIconDef(Icons.payments_rounded, 'payments_rounded'),
  _AccountPickIconDef(Icons.point_of_sale_rounded, 'point_of_sale_rounded'),
  _AccountPickIconDef(Icons.local_atm_rounded, 'local_atm_rounded'),
  _AccountPickIconDef(Icons.smartphone_rounded, 'smartphone_rounded'),
  _AccountPickIconDef(Icons.attach_money_rounded, 'attach_money_rounded'),
  _AccountPickIconDef(Icons.paid_rounded, 'paid_rounded'),
  _AccountPickIconDef(Icons.currency_exchange_rounded, 'currency_exchange_rounded'),
  _AccountPickIconDef(Icons.currency_bitcoin_rounded, 'currency_bitcoin_rounded'),
  // Trust & access
  _AccountPickIconDef(Icons.shield_rounded, 'shield_rounded'),
  _AccountPickIconDef(Icons.gpp_good_rounded, 'gpp_good_rounded'),
  _AccountPickIconDef(Icons.lock_rounded, 'lock_rounded'),
  _AccountPickIconDef(Icons.vpn_key_rounded, 'vpn_key_rounded'),
  // Work & business
  _AccountPickIconDef(Icons.business_rounded, 'business_rounded'),
  _AccountPickIconDef(Icons.business_center_rounded, 'business_center_rounded'),
  _AccountPickIconDef(Icons.work_outline_rounded, 'work_outline_rounded'),
  _AccountPickIconDef(Icons.cases_rounded, 'cases_rounded'),
  _AccountPickIconDef(Icons.handshake_rounded, 'handshake_rounded'),
  _AccountPickIconDef(Icons.laptop_rounded, 'laptop_rounded'),
  _AccountPickIconDef(Icons.storefront_outlined, 'storefront_outlined'),
  // Markets & analytics
  _AccountPickIconDef(Icons.show_chart_rounded, 'show_chart_rounded'),
  _AccountPickIconDef(Icons.candlestick_chart_rounded, 'candlestick_chart_rounded'),
  _AccountPickIconDef(Icons.bar_chart_rounded, 'bar_chart_rounded'),
  _AccountPickIconDef(Icons.pie_chart_rounded, 'pie_chart_rounded'),
  _AccountPickIconDef(Icons.stacked_bar_chart_rounded, 'stacked_bar_chart_rounded'),
  _AccountPickIconDef(Icons.trending_up_rounded, 'trending_up_rounded'),
  _AccountPickIconDef(Icons.trending_down_rounded, 'trending_down_rounded'),
  // Invoices, tax & paperwork
  _AccountPickIconDef(Icons.receipt_long_rounded, 'receipt_long_rounded'),
  _AccountPickIconDef(Icons.description_rounded, 'description_rounded'),
  _AccountPickIconDef(Icons.request_quote_rounded, 'request_quote_rounded'),
  _AccountPickIconDef(Icons.calculate_rounded, 'calculate_rounded'),
  _AccountPickIconDef(Icons.percent_rounded, 'percent_rounded'),
  // Property & mobility
  _AccountPickIconDef(Icons.apartment_rounded, 'apartment_rounded'),
  _AccountPickIconDef(Icons.holiday_village_rounded, 'holiday_village_rounded'),
  _AccountPickIconDef(Icons.home_outlined, 'home_outlined'),
  _AccountPickIconDef(Icons.real_estate_agent_rounded, 'real_estate_agent_rounded'),
  _AccountPickIconDef(Icons.flight_takeoff_rounded, 'flight_takeoff_rounded'),
  _AccountPickIconDef(Icons.train_rounded, 'train_rounded'),
  _AccountPickIconDef(Icons.directions_car_filled_rounded, 'directions_car_filled_rounded'),
  _AccountPickIconDef(Icons.electric_car_rounded, 'electric_car_rounded'),
  _AccountPickIconDef(Icons.directions_boat_rounded, 'directions_boat_rounded'),
  _AccountPickIconDef(Icons.two_wheeler_rounded, 'two_wheeler_rounded'),
  // Living, health & discretionary
  _AccountPickIconDef(Icons.shopping_bag_outlined, 'shopping_bag_outlined'),
  _AccountPickIconDef(Icons.restaurant_rounded, 'restaurant_rounded'),
  _AccountPickIconDef(Icons.local_hospital_rounded, 'local_hospital_rounded'),
  _AccountPickIconDef(Icons.school_outlined, 'school_outlined'),
  _AccountPickIconDef(Icons.fitness_center_rounded, 'fitness_center_rounded'),
  _AccountPickIconDef(Icons.movie_rounded, 'movie_rounded'),
  _AccountPickIconDef(Icons.pets_rounded, 'pets_rounded'),
  _AccountPickIconDef(Icons.volunteer_activism_rounded, 'volunteer_activism_rounded'),
  // Utilities & transfers
  _AccountPickIconDef(Icons.electric_bolt_rounded, 'electric_bolt_rounded'),
  _AccountPickIconDef(Icons.water_drop_rounded, 'water_drop_rounded'),
  _AccountPickIconDef(Icons.wifi_rounded, 'wifi_rounded'),
  _AccountPickIconDef(Icons.local_gas_station_rounded, 'local_gas_station_rounded'),
  _AccountPickIconDef(Icons.swap_horiz_rounded, 'swap_horiz_rounded'),
  // More money, cards & tools (still finance-adjacent)
  _AccountPickIconDef(Icons.monetization_on_rounded, 'monetization_on_rounded'),
  _AccountPickIconDef(Icons.account_tree_rounded, 'account_tree_rounded'),
  _AccountPickIconDef(Icons.price_change_rounded, 'price_change_rounded'),
  _AccountPickIconDef(Icons.price_check_rounded, 'price_check_rounded'),
  _AccountPickIconDef(Icons.wallet_rounded, 'wallet_rounded'),
  _AccountPickIconDef(Icons.money_off_rounded, 'money_off_rounded'),
  _AccountPickIconDef(Icons.call_split_rounded, 'call_split_rounded'),
  _AccountPickIconDef(Icons.account_circle_rounded, 'account_circle_rounded'),
  _AccountPickIconDef(Icons.add_card_rounded, 'add_card_rounded'),
  _AccountPickIconDef(Icons.atm_rounded, 'atm_rounded'),
  _AccountPickIconDef(Icons.token_rounded, 'token_rounded'),
  _AccountPickIconDef(Icons.diamond_rounded, 'diamond_rounded'),
  _AccountPickIconDef(Icons.interests_rounded, 'interests_rounded'),
  _AccountPickIconDef(Icons.rocket_launch_rounded, 'rocket_launch_rounded'),
  // Food & drink
  _AccountPickIconDef(Icons.restaurant_menu_rounded, 'restaurant_menu_rounded'),
  _AccountPickIconDef(Icons.local_cafe_rounded, 'local_cafe_rounded'),
  _AccountPickIconDef(Icons.local_drink_rounded, 'local_drink_rounded'),
  _AccountPickIconDef(Icons.cake_rounded, 'cake_rounded'),
  _AccountPickIconDef(Icons.icecream_rounded, 'icecream_rounded'),
  _AccountPickIconDef(Icons.local_pizza_rounded, 'local_pizza_rounded'),
  _AccountPickIconDef(Icons.fastfood_rounded, 'fastfood_rounded'),
  _AccountPickIconDef(Icons.breakfast_dining_rounded, 'breakfast_dining_rounded'),
  _AccountPickIconDef(Icons.lunch_dining_rounded, 'lunch_dining_rounded'),
  _AccountPickIconDef(Icons.dinner_dining_rounded, 'dinner_dining_rounded'),
  _AccountPickIconDef(Icons.ramen_dining_rounded, 'ramen_dining_rounded'),
  _AccountPickIconDef(Icons.local_bar_rounded, 'local_bar_rounded'),
  _AccountPickIconDef(Icons.wine_bar_rounded, 'wine_bar_rounded'),
  _AccountPickIconDef(Icons.liquor_rounded, 'liquor_rounded'),
  _AccountPickIconDef(Icons.emoji_food_beverage_rounded, 'emoji_food_beverage_rounded'),
  _AccountPickIconDef(Icons.set_meal_rounded, 'set_meal_rounded'),
  _AccountPickIconDef(Icons.takeout_dining_rounded, 'takeout_dining_rounded'),
  _AccountPickIconDef(Icons.rice_bowl_rounded, 'rice_bowl_rounded'),
  _AccountPickIconDef(Icons.soup_kitchen_rounded, 'soup_kitchen_rounded'),
  _AccountPickIconDef(Icons.bakery_dining_rounded, 'bakery_dining_rounded'),
  // Travel, maps & places
  _AccountPickIconDef(Icons.flight_rounded, 'flight_rounded'),
  _AccountPickIconDef(Icons.flight_land_rounded, 'flight_land_rounded'),
  _AccountPickIconDef(Icons.explore_rounded, 'explore_rounded'),
  _AccountPickIconDef(Icons.map_rounded, 'map_rounded'),
  _AccountPickIconDef(Icons.public_rounded, 'public_rounded'),
  _AccountPickIconDef(Icons.language_rounded, 'language_rounded'),
  _AccountPickIconDef(Icons.flag_rounded, 'flag_rounded'),
  _AccountPickIconDef(Icons.beach_access_rounded, 'beach_access_rounded'),
  _AccountPickIconDef(Icons.spa_rounded, 'spa_rounded'),
  _AccountPickIconDef(Icons.pool_rounded, 'pool_rounded'),
  _AccountPickIconDef(Icons.weekend_rounded, 'weekend_rounded'),
  _AccountPickIconDef(Icons.bed_rounded, 'bed_rounded'),
  _AccountPickIconDef(Icons.hotel_rounded, 'hotel_rounded'),
  _AccountPickIconDef(Icons.room_service_rounded, 'room_service_rounded'),
  _AccountPickIconDef(Icons.luggage_rounded, 'luggage_rounded'),
  _AccountPickIconDef(Icons.no_transfer_rounded, 'no_transfer_rounded'),
  _AccountPickIconDef(Icons.tram_rounded, 'tram_rounded'),
  _AccountPickIconDef(Icons.subway_rounded, 'subway_rounded'),
  _AccountPickIconDef(Icons.bus_alert_rounded, 'bus_alert_rounded'),
  _AccountPickIconDef(Icons.airport_shuttle_rounded, 'airport_shuttle_rounded'),
  _AccountPickIconDef(Icons.pedal_bike_rounded, 'pedal_bike_rounded'),
  _AccountPickIconDef(Icons.electric_scooter_rounded, 'electric_scooter_rounded'),
  _AccountPickIconDef(Icons.moped_rounded, 'moped_rounded'),
  _AccountPickIconDef(Icons.rv_hookup_rounded, 'rv_hookup_rounded'),
  _AccountPickIconDef(Icons.sailing_rounded, 'sailing_rounded'),
  _AccountPickIconDef(Icons.festival_rounded, 'festival_rounded'),
  _AccountPickIconDef(Icons.museum_rounded, 'museum_rounded'),
  _AccountPickIconDef(Icons.attractions_rounded, 'attractions_rounded'),
  // Leisure & media
  _AccountPickIconDef(Icons.music_note_rounded, 'music_note_rounded'),
  _AccountPickIconDef(Icons.piano_rounded, 'piano_rounded'),
  _AccountPickIconDef(Icons.mic_rounded, 'mic_rounded'),
  _AccountPickIconDef(Icons.headphones_rounded, 'headphones_rounded'),
  _AccountPickIconDef(Icons.radio_rounded, 'radio_rounded'),
  _AccountPickIconDef(Icons.podcasts_rounded, 'podcasts_rounded'),
  _AccountPickIconDef(Icons.newspaper_rounded, 'newspaper_rounded'),
  _AccountPickIconDef(Icons.menu_book_rounded, 'menu_book_rounded'),
  _AccountPickIconDef(Icons.auto_stories_rounded, 'auto_stories_rounded'),
  _AccountPickIconDef(Icons.camera_alt_rounded, 'camera_alt_rounded'),
  _AccountPickIconDef(Icons.photo_camera_rounded, 'photo_camera_rounded'),
  _AccountPickIconDef(Icons.photo_library_rounded, 'photo_library_rounded'),
  _AccountPickIconDef(Icons.image_rounded, 'image_rounded'),
  _AccountPickIconDef(Icons.videocam_rounded, 'videocam_rounded'),
  _AccountPickIconDef(Icons.movie_filter_rounded, 'movie_filter_rounded'),
  _AccountPickIconDef(Icons.theater_comedy_rounded, 'theater_comedy_rounded'),
  _AccountPickIconDef(Icons.casino_rounded, 'casino_rounded'),
  _AccountPickIconDef(Icons.games_rounded, 'games_rounded'),
  _AccountPickIconDef(Icons.sports_esports_rounded, 'sports_esports_rounded'),
  // Sports & outdoor activities
  _AccountPickIconDef(Icons.sports_soccer_rounded, 'sports_soccer_rounded'),
  _AccountPickIconDef(Icons.sports_basketball_rounded, 'sports_basketball_rounded'),
  _AccountPickIconDef(Icons.sports_football_rounded, 'sports_football_rounded'),
  _AccountPickIconDef(Icons.sports_tennis_rounded, 'sports_tennis_rounded'),
  _AccountPickIconDef(Icons.sports_golf_rounded, 'sports_golf_rounded'),
  _AccountPickIconDef(Icons.sports_hockey_rounded, 'sports_hockey_rounded'),
  _AccountPickIconDef(Icons.sports_baseball_rounded, 'sports_baseball_rounded'),
  _AccountPickIconDef(Icons.sports_volleyball_rounded, 'sports_volleyball_rounded'),
  _AccountPickIconDef(Icons.sports_martial_arts_rounded, 'sports_martial_arts_rounded'),
  _AccountPickIconDef(Icons.sports_mma_rounded, 'sports_mma_rounded'),
  _AccountPickIconDef(Icons.surfing_rounded, 'surfing_rounded'),
  _AccountPickIconDef(Icons.skateboarding_rounded, 'skateboarding_rounded'),
  _AccountPickIconDef(Icons.snowboarding_rounded, 'snowboarding_rounded'),
  _AccountPickIconDef(Icons.kayaking_rounded, 'kayaking_rounded'),
  _AccountPickIconDef(Icons.hiking_rounded, 'hiking_rounded'),
  _AccountPickIconDef(Icons.paragliding_rounded, 'paragliding_rounded'),
  _AccountPickIconDef(Icons.kitesurfing_rounded, 'kitesurfing_rounded'),
  _AccountPickIconDef(Icons.scuba_diving_rounded, 'scuba_diving_rounded'),
  _AccountPickIconDef(Icons.downhill_skiing_rounded, 'downhill_skiing_rounded'),
  _AccountPickIconDef(Icons.nordic_walking_rounded, 'nordic_walking_rounded'),
  _AccountPickIconDef(Icons.sledding_rounded, 'sledding_rounded'),
  _AccountPickIconDef(Icons.ice_skating_rounded, 'ice_skating_rounded'),
  _AccountPickIconDef(Icons.roller_skating_rounded, 'roller_skating_rounded'),
  _AccountPickIconDef(Icons.emoji_events_rounded, 'emoji_events_rounded'),
  _AccountPickIconDef(Icons.military_tech_rounded, 'military_tech_rounded'),
  _AccountPickIconDef(Icons.workspace_premium_rounded, 'workspace_premium_rounded'),
  _AccountPickIconDef(Icons.emoji_emotions_rounded, 'emoji_emotions_rounded'),
  _AccountPickIconDef(Icons.emoji_objects_rounded, 'emoji_objects_rounded'),
  _AccountPickIconDef(Icons.emoji_nature_rounded, 'emoji_nature_rounded'),
  _AccountPickIconDef(Icons.emoji_transportation_rounded, 'emoji_transportation_rounded'),
  // Nature, weather & environment
  _AccountPickIconDef(Icons.nature_people_rounded, 'nature_people_rounded'),
  _AccountPickIconDef(Icons.forest_rounded, 'forest_rounded'),
  _AccountPickIconDef(Icons.park_rounded, 'park_rounded'),
  _AccountPickIconDef(Icons.yard_rounded, 'yard_rounded'),
  _AccountPickIconDef(Icons.grass_rounded, 'grass_rounded'),
  _AccountPickIconDef(Icons.local_florist_rounded, 'local_florist_rounded'),
  _AccountPickIconDef(Icons.eco_rounded, 'eco_rounded'),
  _AccountPickIconDef(Icons.recycling_rounded, 'recycling_rounded'),
  _AccountPickIconDef(Icons.energy_savings_leaf_rounded, 'energy_savings_leaf_rounded'),
  _AccountPickIconDef(Icons.compost_rounded, 'compost_rounded'),
  _AccountPickIconDef(Icons.thermostat_rounded, 'thermostat_rounded'),
  _AccountPickIconDef(Icons.wb_sunny_rounded, 'wb_sunny_rounded'),
  _AccountPickIconDef(Icons.nights_stay_rounded, 'nights_stay_rounded'),
  _AccountPickIconDef(Icons.umbrella_rounded, 'umbrella_rounded'),
  _AccountPickIconDef(Icons.ac_unit_rounded, 'ac_unit_rounded'),
  _AccountPickIconDef(Icons.fireplace_rounded, 'fireplace_rounded'),
  _AccountPickIconDef(Icons.tsunami_rounded, 'tsunami_rounded'),
  _AccountPickIconDef(Icons.volcano_rounded, 'volcano_rounded'),
  _AccountPickIconDef(Icons.thunderstorm_rounded, 'thunderstorm_rounded'),
  _AccountPickIconDef(Icons.air_rounded, 'air_rounded'),
  _AccountPickIconDef(Icons.water_rounded, 'water_rounded'),
  // Tech & devices
  _AccountPickIconDef(Icons.light_rounded, 'light_rounded'),
  _AccountPickIconDef(Icons.flashlight_on_rounded, 'flashlight_on_rounded'),
  _AccountPickIconDef(Icons.bolt_rounded, 'bolt_rounded'),
  _AccountPickIconDef(Icons.battery_charging_full_rounded, 'battery_charging_full_rounded'),
  _AccountPickIconDef(Icons.power_rounded, 'power_rounded'),
  _AccountPickIconDef(Icons.outlet_rounded, 'outlet_rounded'),
  _AccountPickIconDef(Icons.router_rounded, 'router_rounded'),
  _AccountPickIconDef(Icons.devices_rounded, 'devices_rounded'),
  _AccountPickIconDef(Icons.tv_rounded, 'tv_rounded'),
  _AccountPickIconDef(Icons.computer_rounded, 'computer_rounded'),
  _AccountPickIconDef(Icons.tablet_mac_rounded, 'tablet_mac_rounded'),
  _AccountPickIconDef(Icons.watch_rounded, 'watch_rounded'),
  _AccountPickIconDef(Icons.headset_mic_rounded, 'headset_mic_rounded'),
  _AccountPickIconDef(Icons.keyboard_rounded, 'keyboard_rounded'),
  _AccountPickIconDef(Icons.mouse_rounded, 'mouse_rounded'),
  _AccountPickIconDef(Icons.print_rounded, 'print_rounded'),
  _AccountPickIconDef(Icons.scanner_rounded, 'scanner_rounded'),
  _AccountPickIconDef(Icons.fax_rounded, 'fax_rounded'),
  _AccountPickIconDef(Icons.phone_rounded, 'phone_rounded'),
  _AccountPickIconDef(Icons.tablet_android_rounded, 'tablet_android_rounded'),
  _AccountPickIconDef(Icons.contact_phone_rounded, 'contact_phone_rounded'),
  _AccountPickIconDef(Icons.contact_mail_rounded, 'contact_mail_rounded'),
  _AccountPickIconDef(Icons.alternate_email_rounded, 'alternate_email_rounded'),
  _AccountPickIconDef(Icons.forward_to_inbox_rounded, 'forward_to_inbox_rounded'),
  _AccountPickIconDef(Icons.mark_email_read_rounded, 'mark_email_read_rounded'),
  _AccountPickIconDef(Icons.chat_rounded, 'chat_rounded'),
  _AccountPickIconDef(Icons.forum_rounded, 'forum_rounded'),
  _AccountPickIconDef(Icons.rss_feed_rounded, 'rss_feed_rounded'),
  _AccountPickIconDef(Icons.cast_rounded, 'cast_rounded'),
  _AccountPickIconDef(Icons.speaker_rounded, 'speaker_rounded'),
  _AccountPickIconDef(Icons.memory_rounded, 'memory_rounded'),
  _AccountPickIconDef(Icons.storage_rounded, 'storage_rounded'),
  _AccountPickIconDef(Icons.sim_card_rounded, 'sim_card_rounded'),
  _AccountPickIconDef(Icons.nfc_rounded, 'nfc_rounded'),
  _AccountPickIconDef(Icons.bluetooth_rounded, 'bluetooth_rounded'),
  _AccountPickIconDef(Icons.wifi_tethering_rounded, 'wifi_tethering_rounded'),
  _AccountPickIconDef(Icons.phonelink_ring_rounded, 'phonelink_ring_rounded'),
  // Time, calendar & tasks
  _AccountPickIconDef(Icons.calendar_month_rounded, 'calendar_month_rounded'),
  _AccountPickIconDef(Icons.event_rounded, 'event_rounded'),
  _AccountPickIconDef(Icons.event_available_rounded, 'event_available_rounded'),
  _AccountPickIconDef(Icons.event_note_rounded, 'event_note_rounded'),
  _AccountPickIconDef(Icons.schedule_rounded, 'schedule_rounded'),
  _AccountPickIconDef(Icons.alarm_rounded, 'alarm_rounded'),
  _AccountPickIconDef(Icons.alarm_on_rounded, 'alarm_on_rounded'),
  _AccountPickIconDef(Icons.hourglass_bottom_rounded, 'hourglass_bottom_rounded'),
  _AccountPickIconDef(Icons.timer_rounded, 'timer_rounded'),
  _AccountPickIconDef(Icons.more_time_rounded, 'more_time_rounded'),
  _AccountPickIconDef(Icons.update_rounded, 'update_rounded'),
  _AccountPickIconDef(Icons.history_rounded, 'history_rounded'),
  _AccountPickIconDef(Icons.today_rounded, 'today_rounded'),
  _AccountPickIconDef(Icons.date_range_rounded, 'date_range_rounded'),
  _AccountPickIconDef(Icons.checklist_rounded, 'checklist_rounded'),
  _AccountPickIconDef(Icons.task_alt_rounded, 'task_alt_rounded'),
  _AccountPickIconDef(Icons.rule_rounded, 'rule_rounded'),
  _AccountPickIconDef(Icons.gavel_rounded, 'gavel_rounded'),
  _AccountPickIconDef(Icons.balance_rounded, 'balance_rounded'),
  // Home, furniture & family
  _AccountPickIconDef(Icons.chair_rounded, 'chair_rounded'),
  _AccountPickIconDef(Icons.bedroom_child_rounded, 'bedroom_child_rounded'),
  _AccountPickIconDef(Icons.bathroom_rounded, 'bathroom_rounded'),
  _AccountPickIconDef(Icons.kitchen_rounded, 'kitchen_rounded'),
  _AccountPickIconDef(Icons.dining_rounded, 'dining_rounded'),
  _AccountPickIconDef(Icons.living_rounded, 'living_rounded'),
  _AccountPickIconDef(Icons.single_bed_rounded, 'single_bed_rounded'),
  _AccountPickIconDef(Icons.stroller_rounded, 'stroller_rounded'),
  _AccountPickIconDef(Icons.toys_rounded, 'toys_rounded'),
  _AccountPickIconDef(Icons.cottage_rounded, 'cottage_rounded'),
  _AccountPickIconDef(Icons.chalet_rounded, 'chalet_rounded'),
  _AccountPickIconDef(Icons.bungalow_rounded, 'bungalow_rounded'),
  _AccountPickIconDef(Icons.villa_rounded, 'villa_rounded'),
  _AccountPickIconDef(Icons.castle_rounded, 'castle_rounded'),
  _AccountPickIconDef(Icons.church_rounded, 'church_rounded'),
  _AccountPickIconDef(Icons.temple_hindu_rounded, 'temple_hindu_rounded'),
  _AccountPickIconDef(Icons.temple_buddhist_rounded, 'temple_buddhist_rounded'),
  _AccountPickIconDef(Icons.mosque_rounded, 'mosque_rounded'),
  _AccountPickIconDef(Icons.synagogue_rounded, 'synagogue_rounded'),
  _AccountPickIconDef(Icons.fort_rounded, 'fort_rounded'),
  _AccountPickIconDef(Icons.cabin_rounded, 'cabin_rounded'),
  _AccountPickIconDef(Icons.fence_rounded, 'fence_rounded'),
  _AccountPickIconDef(Icons.door_front_door_rounded, 'door_front_door_rounded'),
  _AccountPickIconDef(Icons.window_rounded, 'window_rounded'),
  _AccountPickIconDef(Icons.garage_rounded, 'garage_rounded'),
  _AccountPickIconDef(Icons.roofing_rounded, 'roofing_rounded'),
  _AccountPickIconDef(Icons.foundation_rounded, 'foundation_rounded'),
  _AccountPickIconDef(Icons.construction_rounded, 'construction_rounded'),
  _AccountPickIconDef(Icons.plumbing_rounded, 'plumbing_rounded'),
  _AccountPickIconDef(Icons.format_paint_rounded, 'format_paint_rounded'),
  _AccountPickIconDef(Icons.hardware_rounded, 'hardware_rounded'),
  _AccountPickIconDef(Icons.agriculture_rounded, 'agriculture_rounded'),
  _AccountPickIconDef(Icons.anchor_rounded, 'anchor_rounded'),
  // Learning, science & ideas
  _AccountPickIconDef(Icons.school_rounded, 'school_rounded'),
  _AccountPickIconDef(Icons.science_rounded, 'science_rounded'),
  _AccountPickIconDef(Icons.biotech_rounded, 'biotech_rounded'),
  _AccountPickIconDef(Icons.psychology_rounded, 'psychology_rounded'),
  _AccountPickIconDef(Icons.self_improvement_rounded, 'self_improvement_rounded'),
  _AccountPickIconDef(Icons.auto_fix_high_rounded, 'auto_fix_high_rounded'),
  _AccountPickIconDef(Icons.auto_awesome_rounded, 'auto_awesome_rounded'),
  _AccountPickIconDef(Icons.lightbulb_rounded, 'lightbulb_rounded'),
  _AccountPickIconDef(Icons.tips_and_updates_rounded, 'tips_and_updates_rounded'),
  _AccountPickIconDef(Icons.quiz_rounded, 'quiz_rounded'),
  _AccountPickIconDef(Icons.extension_rounded, 'extension_rounded'),
  _AccountPickIconDef(Icons.functions_rounded, 'functions_rounded'),
  _AccountPickIconDef(Icons.data_object_rounded, 'data_object_rounded'),
  _AccountPickIconDef(Icons.hub_rounded, 'hub_rounded'),
  _AccountPickIconDef(Icons.polyline_rounded, 'polyline_rounded'),
  _AccountPickIconDef(Icons.shape_line_rounded, 'shape_line_rounded'),
  _AccountPickIconDef(Icons.auto_graph_rounded, 'auto_graph_rounded'),
  _AccountPickIconDef(Icons.multiline_chart_rounded, 'multiline_chart_rounded'),
  _AccountPickIconDef(Icons.ssid_chart_rounded, 'ssid_chart_rounded'),
  // Rewards, gifts & social
  _AccountPickIconDef(Icons.star_rounded, 'star_rounded'),
  _AccountPickIconDef(Icons.star_half_rounded, 'star_half_rounded'),
  _AccountPickIconDef(Icons.grade_rounded, 'grade_rounded'),
  _AccountPickIconDef(Icons.favorite_rounded, 'favorite_rounded'),
  _AccountPickIconDef(Icons.favorite_border_rounded, 'favorite_border_rounded'),
  _AccountPickIconDef(Icons.celebration_rounded, 'celebration_rounded'),
  _AccountPickIconDef(Icons.card_giftcard_rounded, 'card_giftcard_rounded'),
  _AccountPickIconDef(Icons.redeem_rounded, 'redeem_rounded'),
  _AccountPickIconDef(Icons.recommend_rounded, 'recommend_rounded'),
  _AccountPickIconDef(Icons.thumb_up_rounded, 'thumb_up_rounded'),
  _AccountPickIconDef(Icons.diversity_1_rounded, 'diversity_1_rounded'),
  _AccountPickIconDef(Icons.diversity_2_rounded, 'diversity_2_rounded'),
  _AccountPickIconDef(Icons.transgender_rounded, 'transgender_rounded'),
  _AccountPickIconDef(Icons.waving_hand_rounded, 'waving_hand_rounded'),
  _AccountPickIconDef(Icons.front_hand_rounded, 'front_hand_rounded'),
  _AccountPickIconDef(Icons.back_hand_rounded, 'back_hand_rounded'),
  // Creative & editing
  _AccountPickIconDef(Icons.create_rounded, 'create_rounded'),
  _AccountPickIconDef(Icons.draw_rounded, 'draw_rounded'),
  _AccountPickIconDef(Icons.brush_rounded, 'brush_rounded'),
  _AccountPickIconDef(Icons.palette_rounded, 'palette_rounded'),
  _AccountPickIconDef(Icons.color_lens_rounded, 'color_lens_rounded'),
  _AccountPickIconDef(Icons.design_services_rounded, 'design_services_rounded'),
  _AccountPickIconDef(Icons.architecture_rounded, 'architecture_rounded'),
  _AccountPickIconDef(Icons.animation_rounded, 'animation_rounded'),
  _AccountPickIconDef(Icons.gif_box_rounded, 'gif_box_rounded'),
  _AccountPickIconDef(Icons.sticky_note_2_rounded, 'sticky_note_2_rounded'),
  _AccountPickIconDef(Icons.article_rounded, 'article_rounded'),
  _AccountPickIconDef(Icons.feed_rounded, 'feed_rounded'),
  _AccountPickIconDef(Icons.style_rounded, 'style_rounded'),
  // Security, privacy & health (extra)
  _AccountPickIconDef(Icons.admin_panel_settings_rounded, 'admin_panel_settings_rounded'),
  _AccountPickIconDef(Icons.verified_user_rounded, 'verified_user_rounded'),
  _AccountPickIconDef(Icons.privacy_tip_rounded, 'privacy_tip_rounded'),
  _AccountPickIconDef(Icons.health_and_safety_rounded, 'health_and_safety_rounded'),
  _AccountPickIconDef(Icons.medical_services_rounded, 'medical_services_rounded'),
  _AccountPickIconDef(Icons.medication_rounded, 'medication_rounded'),
  _AccountPickIconDef(Icons.vaccines_rounded, 'vaccines_rounded'),
  _AccountPickIconDef(Icons.coronavirus_rounded, 'coronavirus_rounded'),
  _AccountPickIconDef(Icons.bloodtype_rounded, 'bloodtype_rounded'),
  _AccountPickIconDef(Icons.monitor_heart_rounded, 'monitor_heart_rounded'),
  _AccountPickIconDef(Icons.hearing_rounded, 'hearing_rounded'),
  _AccountPickIconDef(Icons.visibility_rounded, 'visibility_rounded'),
  _AccountPickIconDef(Icons.visibility_off_rounded, 'visibility_off_rounded'),
  _AccountPickIconDef(Icons.fingerprint_rounded, 'fingerprint_rounded'),
  // Animals & plants
  _AccountPickIconDef(Icons.cruelty_free_rounded, 'cruelty_free_rounded'),
  _AccountPickIconDef(Icons.filter_vintage_rounded, 'filter_vintage_rounded'),
  _AccountPickIconDef(Icons.pest_control_rounded, 'pest_control_rounded'),
  _AccountPickIconDef(Icons.bug_report_rounded, 'bug_report_rounded'),
  // Misc & playful (least “finance” — end of picker)
  _AccountPickIconDef(Icons.rocket_rounded, 'rocket_rounded'),
  _AccountPickIconDef(Icons.hive_rounded, 'hive_rounded'),
  _AccountPickIconDef(Icons.auto_awesome_motion_rounded, 'auto_awesome_motion_rounded'),
  _AccountPickIconDef(Icons.bubble_chart_rounded, 'bubble_chart_rounded'),
  _AccountPickIconDef(Icons.scatter_plot_rounded, 'scatter_plot_rounded'),
  _AccountPickIconDef(Icons.hexagon_rounded, 'hexagon_rounded'),
  _AccountPickIconDef(Icons.pentagon_rounded, 'pentagon_rounded'),
  _AccountPickIconDef(Icons.change_history_rounded, 'change_history_rounded'),
  _AccountPickIconDef(Icons.all_inclusive_rounded, 'all_inclusive_rounded'),
  _AccountPickIconDef(Icons.flutter_dash_rounded, 'flutter_dash_rounded'),
  _AccountPickIconDef(Icons.sentiment_satisfied_rounded, 'sentiment_satisfied_rounded'),
  _AccountPickIconDef(Icons.sentiment_very_satisfied_rounded, 'sentiment_very_satisfied_rounded'),
  _AccountPickIconDef(Icons.mood_rounded, 'mood_rounded'),
  _AccountPickIconDef(Icons.face_rounded, 'face_rounded'),
  _AccountPickIconDef(Icons.cyclone_rounded, 'cyclone_rounded'),
  _AccountPickIconDef(Icons.whatshot_rounded, 'whatshot_rounded'),
  _AccountPickIconDef(Icons.local_fire_department_rounded, 'local_fire_department_rounded'),
  _AccountPickIconDef(Icons.dangerous_rounded, 'dangerous_rounded'),
  _AccountPickIconDef(Icons.warning_rounded, 'warning_rounded'),
  _AccountPickIconDef(Icons.new_releases_rounded, 'new_releases_rounded'),
  _AccountPickIconDef(Icons.loyalty_rounded, 'loyalty_rounded'),
  _AccountPickIconDef(Icons.card_membership_rounded, 'card_membership_rounded'),
  _AccountPickIconDef(Icons.confirmation_number_rounded, 'confirmation_number_rounded'),
  _AccountPickIconDef(Icons.local_activity_rounded, 'local_activity_rounded'),
  _AccountPickIconDef(Icons.local_play_rounded, 'local_play_rounded'),
  _AccountPickIconDef(Icons.nightlife_rounded, 'nightlife_rounded'),
  _AccountPickIconDef(Icons.party_mode_rounded, 'party_mode_rounded'),
  _AccountPickIconDef(Icons.android_rounded, 'android_rounded'),
  _AccountPickIconDef(Icons.apple_rounded, 'apple_rounded'),
  _AccountPickIconDef(Icons.cookie_rounded, 'cookie_rounded'),
  _AccountPickIconDef(Icons.egg_rounded, 'egg_rounded'),
  _AccountPickIconDef(Icons.coffee_maker_rounded, 'coffee_maker_rounded'),
  _AccountPickIconDef(Icons.wb_cloudy_rounded, 'wb_cloudy_rounded'),
  _AccountPickIconDef(Icons.cloud_rounded, 'cloud_rounded'),
  _AccountPickIconDef(Icons.cloud_queue_rounded, 'cloud_queue_rounded'),
  _AccountPickIconDef(Icons.storm_rounded, 'storm_rounded'),
  _AccountPickIconDef(Icons.blur_on_rounded, 'blur_on_rounded'),
  _AccountPickIconDef(Icons.blur_circular_rounded, 'blur_circular_rounded'),
  _AccountPickIconDef(Icons.traffic_rounded, 'traffic_rounded'),
  _AccountPickIconDef(Icons.emoji_flags_rounded, 'emoji_flags_rounded'),
  _AccountPickIconDef(Icons.waves_rounded, 'waves_rounded'),
];
const List<int> _kAccountPickColorArgb = <int>[
  0xFF1565C0,
  0xFF2E7D32,
  0xFF6A1B9A,
  0xFFC62828,
  0xFFEF6C00,
  0xFF00838F,
  0xFF5D4037,
  0xFF455A64,
  0xFFAD1457,
  0xFF283593,
  0xFFF9A825,
  0xFF00695C,
];

class _AccountIconPickerBottomSheet extends StatefulWidget {
  const _AccountIconPickerBottomSheet({required this.currentCodePoint});

  final int currentCodePoint;

  @override
  State<_AccountIconPickerBottomSheet> createState() =>
      _AccountIconPickerBottomSheetState();
}

class _AccountIconPickerBottomSheetState
    extends State<_AccountIconPickerBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) => setState(() {});

  List<_AccountPickIconDef> get _filtered {
    final q = _searchController.text;
    return _kAccountPickIconDefs
        .where((d) => _accountPickIconMatchesQuery(d, q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);
    final filtered = _filtered;
    return Padding(
      padding: EdgeInsets.only(
        bottom: mq.viewPadding.bottom + mq.viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
            child: Text(
              l10n.accountIconSheetTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_fields_rounded, color: cs.primary),
            title: Text(l10n.accountUseInitialLetter),
            onTap: () => Navigator.pop(context, 0),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchAccountIcons,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: (mq.size.height * 0.5).clamp(300, 480),
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        l10n.accountIconSearchNoMatches,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final def = filtered[i];
                      final icon = def.icon;
                      final cp = icon.codePoint;
                      final sel =
                          widget.currentCodePoint != 0 &&
                              widget.currentCodePoint == cp;
                      return Material(
                        color: sel
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context, cp),
                          child: Icon(icon, color: cs.onSurface),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Future<int?> _pickAccountIconCodePoint(
  BuildContext context, {
  required int current,
}) async {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _AccountIconPickerBottomSheet(currentCodePoint: current),
  );
}

Future<int?> _pickAccountColorArgb(
  BuildContext context, {
  required int? current,
}) async {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewPadding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              child: Text(
                l10n.accountColorSheetTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.palette_outlined, color: cs.primary),
              title: Text(l10n.accountUseDefaultColor),
              onTap: () => Navigator.pop(ctx, -1),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final argb in _kAccountPickColorArgb)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, argb),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(argb),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: current == argb
                                ? cs.primary
                                : cs.outlineVariant,
                            width: current == argb ? 2.5 : 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _accountAppearanceEditorBlock(
  BuildContext context, {
  required Account previewAccount,
  required VoidCallback onPickIcon,
  required VoidCallback onPickColor,
}) {
  final l10n = AppLocalizations.of(context);
  final tt = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        l10n.accountAppearanceSection,
        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AccountAvatar(account: previewAccount, size: 52, borderRadius: 14),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: onPickIcon,
                  child: Text(l10n.accountPickIcon),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: onPickColor,
                  child: Text(l10n.accountPickColor),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

Future<void> _showBalanceCorrectionDialog(
  BuildContext context, {
  required double previousBook,
  required double newBook,
  required Account account,
  required BalanceCorrectionResult correction,
}) async {
  final sym = fx.currencySymbol(account.currencyCode);
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.balanceAdjustedTitle),
      content: Text(
        l10n.balanceAdjustedBody(
          previousBook.toStringAsFixed(2),
          newBook.toStringAsFixed(2),
          sym,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

/// Overdraft / advance limit applies only to personal accounts.
bool _accountGroupAllowsOverdraft(AccountGroup g) =>
    g == AccountGroup.personal;

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  final _balanceMinorFormatter =
      MinorUnitsAmountInputFormatter(allowNegative: true);
  final _overdraftMinorFormatter = MinorUnitsAmountInputFormatter();
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  /// Value that would be persisted (zero when group ≠ personal).
  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.account?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.account != null &&
              widget.account!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.account!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.account?.iconCodePoint ?? 0;
    _colorArgb = widget.account?.colorArgb;
    _balanceMinorFormatter.syncFromDisplay(_balanceController.text);
    _overdraftMinorFormatter.syncFromDisplay(_overdraftController.text);
  }

  String _trimmedInstitution() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForSheet() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitution();
    return Account(
      id: widget.account?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForSheet() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForSheet() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  bool get _isDirty {
    final inst = _trimmedInstitution();
    final instExisting = widget.account?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.account!.overdraftLimit ||
          _currencyCode != widget.account!.currencyCode ||
          _iconCodePoint != widget.account!.iconCodePoint ||
          _colorArgb != widget.account!.colorArgb;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null) setState(() => _currencyCode = result);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitution();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: widget.account?.id,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (widget.account != null) {
      final acc = widget.account!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, acc);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          institution: institution,
          group: _group,
          iconCodePoint: _iconCodePoint,
          colorArgb: _colorArgb,
          balance: balance,
          overdraftLimit: overdraft,
          currencyCode: _currencyCode,
        ),
      );
    }
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _confirmArchiveSheet() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finish() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, acc);
    }
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, acc);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finish();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _delete() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(l10n.cannotDeleteBodyHistory),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.account != null;

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(isEdit ? l10n.editAccountTitle : l10n.newAccountTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      if (_isDirty) {
                        _showDiscardDialog();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SegmentedButton<AccountGroup>(
                segments: [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: const Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text(l10n.accountGroupPersonal),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: const Icon(Icons.person_outline_rounded, size: 16),
                    label: Text(l10n.accountGroupIndividual),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: const Icon(Icons.business_outlined, size: 16),
                    label: Text(l10n.accountGroupEntity),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) {
                  final ng = s.first;
                  setState(() {
                    _group = ng;
                    if (!_accountGroupAllowsOverdraft(ng)) {
                      _overdraftController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescriptionL10n(context),
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountName,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _institutionController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountIdentifier,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _accountAppearanceEditorBlock(
                context,
                previewAccount: _previewAccountForSheet(),
                onPickIcon: _pickIconForSheet,
                onPickColor: _pickColorForSheet,
              ),
              const SizedBox(height: 16),

              // Currency — editable only when creating
              if (!isEdit)
                _CurrencyTile(
                  currencyCode: _currencyCode,
                  onTap: _pickCurrency,
                )
              else
                _CurrencyTile(currencyCode: _currencyCode, onTap: null),
              const SizedBox(height: 12),

              TextField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: true),
                inputFormatters: [_balanceMinorFormatter],
                decoration: InputDecoration(
                  labelText: l10n.labelRealBalance,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_accountGroupAllowsOverdraft(_group)) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _overdraftController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  inputFormatters: [_overdraftMinorFormatter],
                  decoration: InputDecoration(
                    labelText: l10n.labelOverdraftLimit,
                    suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _save(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                      widget.account!.archived ? null : _confirmArchiveSheet,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(l10n.archiveAction),
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: Text(l10n.deletePermanently),
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Account Form Screen (full-screen push) ──────────────────────────────────

class AccountFormScreen extends StatefulWidget {
  final Account? existing;
  final AccountGroup? initialGroup;
  const AccountFormScreen({super.key, this.existing, this.initialGroup});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  final _balanceMinorFormatter =
      MinorUnitsAmountInputFormatter(allowNegative: true);
  final _overdraftMinorFormatter = MinorUnitsAmountInputFormatter();
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.existing?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.existing?.group ??
        widget.initialGroup ??
        AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.existing != null &&
              widget.existing!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.existing!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.existing?.iconCodePoint ?? 0;
    _colorArgb = widget.existing?.colorArgb;
    _balanceMinorFormatter.syncFromDisplay(_balanceController.text);
    _overdraftMinorFormatter.syncFromDisplay(_overdraftController.text);
  }

  String _trimmedInstitutionScreen() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForScreen() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitutionScreen();
    return Account(
      id: widget.existing?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForScreen() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForScreen() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final inst = _trimmedInstitutionScreen();
    final instExisting = widget.existing?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.existing!.overdraftLimit ||
          _iconCodePoint != widget.existing!.iconCodePoint ||
          _colorArgb != widget.existing!.colorArgb;
    }
    final defaultGroup = widget.initialGroup ?? AccountGroup.personal;
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != defaultGroup ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitutionScreen();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: _isEdit ? widget.existing!.id : null,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance =
        double.tryParse(_balanceController.text.trim().replaceAll(',', '.')) ??
            0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (_isEdit) {
      final acc = widget.existing!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } else {
      final ok = await guardPersist(context, () => DataRepository.addAccount(
            Account(
              name: name,
              institution: institution,
              group: _group,
              iconCodePoint: _iconCodePoint,
              colorArgb: _colorArgb,
              balance: balance,
              overdraftLimit: overdraft,
              currencyCode: _currencyCode,
            ),
          ));
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _restoreArchived() async {
    final acc = widget.existing!;
    final wasArchived = acc.archived;
    acc.archived = false;
    if (!await guardPersist(context, () => DataRepository.persistAccountFields(acc))) {
      acc.archived = wasArchived;
      if (mounted) setState(() {});
      return;
    }
    setState(() {});
  }

  void _confirmArchive() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBodyAdjust),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finishArchive() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, true);
    }

    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, true);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finishArchive();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(
            acc.archived
                ? l10n.cannotDeleteBodyShort
                : l10n.cannotDeleteBodySuggestArchive,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
            if (!acc.archived)
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmArchive();
                },
                child: Text(l10n.archiveInstead),
              ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null && mounted) setState(() => _currencyCode = result);
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _showRemoveAccountSheet() {
    HapticFeedback.lightImpact();
    final acc = widget.existing!;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.removeAccountSheetTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: cs.error),
                title: Text(
                  l10n.deletePermanently,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.error,
                  ),
                ),
                subtitle: Text(l10n.deletePermanentlySubtitle),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete();
                },
              ),
              if (!acc.archived)
                ListTile(
                  leading: Icon(Icons.inventory_2_outlined, color: cs.primary),
                  title: Text(
                    l10n.archiveAction,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.archiveOptionSubtitle),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmArchive();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(_isEdit ? l10n.editAccountTitle : l10n.newAccountTitle),
          centerTitle: false,
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          actions: _isEdit
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                    tooltip: l10n.tooltipRemoveAccount,
                    onPressed: _showRemoveAccountSheet,
                  ),
                ]
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEdit && widget.existing!.archived)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: cs.secondaryContainer
                              .withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 22, color: cs.onSecondaryContainer),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.archivedBannerText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.35,
                                      color: cs.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _restoreArchived(),
                                  child: Text(l10n.restore),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SegmentedButton<AccountGroup>(
                      segments: [
                        ButtonSegment(
                          value: AccountGroup.personal,
                          icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
                          label: Text(l10n.accountGroupPersonal),
                        ),
                        ButtonSegment(
                          value: AccountGroup.individuals,
                          icon: const Icon(Icons.person_outline_rounded, size: 16),
                          label: Text(l10n.accountGroupIndividual),
                        ),
                        ButtonSegment(
                          value: AccountGroup.entities,
                          icon: const Icon(Icons.business_outlined, size: 16),
                          label: Text(l10n.accountGroupEntity),
                        ),
                      ],
                      selected: {_group},
                      onSelectionChanged: (s) {
                        final ng = s.first;
                        setState(() {
                          _group = ng;
                          if (!_accountGroupAllowsOverdraft(ng)) {
                            _overdraftController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _groupDescriptionL10n(context),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      autofocus: !_isEdit,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          InputDecoration(labelText: l10n.labelAccountName),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _institutionController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: l10n.labelAccountIdentifier,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _accountAppearanceEditorBlock(
                      context,
                      previewAccount: _previewAccountForScreen(),
                      onPickIcon: _pickIconForScreen,
                      onPickColor: _pickColorForScreen,
                    ),
                    const SizedBox(height: 16),
                    if (!_isEdit)
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: _pickCurrency)
                    else
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: null),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: false, signed: true),
                      inputFormatters: [_balanceMinorFormatter],
                      decoration: InputDecoration(
                        labelText: l10n.labelRealBalance,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_accountGroupAllowsOverdraft(_group)) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _overdraftController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        inputFormatters: [_overdraftMinorFormatter],
                        decoration: InputDecoration(
                          labelText: l10n.labelOverdraftLimit,
                          suffixText:
                              '  ${fx.currencySymbol(_currencyCode)}',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                    top: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                        width: 0.5)),
              ),
              child: FilledButton(
                onPressed: _canSave ? () => _save() : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Currency picker tile ────────────────────────────────────────────────────

class _CurrencyTile extends StatelessWidget {
  final String currencyCode;
  final VoidCallback? onTap;

  const _CurrencyTile({required this.currencyCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final name =
        currencyDisplayName(currencyCode, Localizations.localeOf(context));
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.labelCurrency,
          suffixIcon: enabled
              ? const Icon(Icons.arrow_drop_down_rounded)
              : Icon(Icons.lock_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
          enabled: enabled,
        ),
        child: Text(
          '$currencyCode  ·  $symbol  ·  $name',
          style: TextStyle(
            fontSize: 14,
            color: enabled ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Currency picker bottom sheet ───────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selected;
  const _CurrencyPickerSheet({required this.selected});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _filtered = settings.supportedCurrencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    final locale = Localizations.localeOf(context);
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name = currencyDisplayName(code, locale).toLowerCase();
              return code.toLowerCase().contains(q) || name.contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchCurrencies,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final code = _filtered[i];
                  final name = currencyDisplayName(
                      code, Localizations.localeOf(ctx));
                  final symbol = fx.currencySymbol(code);
                  final isSelected = code == widget.selected;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      child: Text(
                        symbol.length <= 2 ? symbol : code.substring(0, 1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? cs.onPrimaryContainer
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      '$code  —  $name',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      symbol,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
