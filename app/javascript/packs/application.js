/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
import '../stylesheets/application';

require.context("images", true, /\.(png|svg|jpg|gif|ico)$/);

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

import "controllers"
require("trix")
require("@rails/actiontext")
require("./loader.js")
require("./awesome.js")
