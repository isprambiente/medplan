// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// ########################################
// #    NECESSARIE
// ########################################
//= require jquery3
//= require jquery.purr
//= require jquery-ui
//= require jquery_ujs
//= require jquery-ui/i18n/datepicker-it
//= require jquery.datetimepicker
//= require best_in_place
//= require best_in_place.jquery-ui
//= require activestorage
// ########################################
// #    FOUNDATION
// ########################################
//= require foundation

// ########################################
// #    CUSTOM
// ########################################
//= require custom
//= require moment
//= require fullcalendar
//= require fullcalendar/locale-all
//= require users
//= require events
//= require multi-select
//= require news
//= require confirm


//= require turbolinks

$.datepicker.setDefaults( $.datepicker.regional[ "it" ] );

$(function(){ $(document).foundation(); });
