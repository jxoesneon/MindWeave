#!/bin/bash
# Rename Stitch screen images with descriptive names

cd /Users/mey/MindWeave/assets/images/app

# Remove the old numbered files without descriptive names
rm -f 01_desktop_crypto_payment.png

# Rename files based on screen titles from MCP output
# Format: ##_descriptive_name.png

mv 01.png "01_desktop_crypto_payment.png" 2>/dev/null
mv 02.png "02_financial_transparency_ledger.png" 2>/dev/null
mv 03.png "03_crypto_faq_dashboard.png" 2>/dev/null
mv 04.png "04_digital_wallets_management.png" 2>/dev/null
mv 05.png "05_crypto_payment_screen.png" 2>/dev/null
mv 06.png "06_notifications_center.png" 2>/dev/null
mv 07.png "07_support_sanctuary.png" 2>/dev/null
mv 08.png "08_learn_about_flow.png" 2>/dev/null
mv 09.png "09_explore_resonance_search.png" 2>/dev/null
mv 10.png "10_favorite_nodes_dashboard.png" 2>/dev/null
mv 11.png "11_open_finances_transparency.png" 2>/dev/null
mv 12.png "12_main_player_screen.png" 2>/dev/null
mv 13.png "13_deep_flow_immersion.png" 2>/dev/null
mv 14.png "14_desktop_community_hub.png" 2>/dev/null
mv 15.png "15_credit_card_payment.png" 2>/dev/null
mv 16.png "16_desktop_settings_support.png" 2>/dev/null
mv 17.png "17_fund_usage_transparency.png" 2>/dev/null
mv 18.png "18_settings_donation.png" 2>/dev/null
mv 19.png "19_documentation_hub.png" 2>/dev/null
mv 20.png "20_celestial_journal.png" 2>/dev/null
mv 21.png "21_desktop_player_dashboard.png" 2>/dev/null
mv 22.png "22_frequency_deep_dive.png" 2>/dev/null
mv 23.png "23_mindweave_manifesto.png" 2>/dev/null
mv 24.png "24_payment_method_selection.png" 2>/dev/null
mv 25.png "25_payment_success.png" 2>/dev/null
mv 26.png "26_profile_account_settings.png" 2>/dev/null
mv 27.png "27_purchase_success.png" 2>/dev/null
mv 28.png "28_resonance_discoveries.png" 2>/dev/null
mv 29.png "29_session_end_summary.png" 2>/dev/null
mv 30.png "30_soul_nourishment.png" 2>/dev/null
mv 31.png "31_stitch_mobile_variants.png" 2>/dev/null
mv 32.png "32_tech_stack_transparency.png" 2>/dev/null
mv 33.png "33_tier_management.png" 2>/dev/null
mv 34.png "34_tier_upgrade.png" 2>/dev/null
mv 35.png "35_timer_session_active.png" 2>/dev/null
mv 36.png "36_welcome_onboarding.png" 2>/dev/null
mv 37.png "37_your_resonance_archive.png" 2>/dev/null
mv 38.png "38_mobile_player_main.png" 2>/dev/null

echo "Renamed files:"
ls -la *.png 2>/dev/null | wc -l
echo "Total PNG files"
