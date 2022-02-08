#!/usr/bin/env bats

load ../test_helper
load ../test_helper_libs
load ../../lib/theme

@test 'theme: battery_percentage should not exist' {
  run type -a battery_percentage &> /dev/null
  assert_failure
}

@test 'theme: battery_percentage should exist if battery plugin loaded' {
  load ../../plugins/available/battery.plugin

  run type -a battery_percentage &> /dev/null
  assert_success
}

@test 'theme: battery_char should exist' {
  run type -t battery_char
  assert_success
  assert_line "function"

  run battery_char
  assert_line -n 0 ""
}

@test 'theme: battery_char should exist if battery plugin loaded' {
  unset -f battery_char

  load ../../plugins/available/battery.plugin
  run type -t battery_percentage
  assert_success
  assert_line "function"

  load ../../lib/theme
  run type -t battery_char
  assert_success
  assert_line "function"

  run battery_char
  assert_success

  run type -a battery_char
  assert_output --partial 'THEME_BATTERY_PERCENTAGE_CHECK'
}

@test 'theme: battery_charge should exist' {
  run type -a battery_charge &> /dev/null
  assert_success

  run battery_charge
  assert_success
  assert_line -n 0 ""
}

@test 'theme: battery_charge should exist if battery plugin loaded' {
  unset -f battery_charge
  load ../../plugins/available/battery.plugin
  load ../../lib/theme

  run type -a battery_charge &> /dev/null
  assert_success

  run battery_charge
  assert_success

  run type -a battery_charge
  assert_line '        no)'
}
