/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Vue from 'vue/dist/vue'

import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/antd.css';

import 'font-awesome/css/font-awesome.css'

window.Vue = Vue;
Vue.use(ElementUI);
Vue.use(Antd);

console.log('Hello World from TianLuo')

// import jQuery from 'jquery/dist/jquery'
// window.$ = window.jQuery = jQuery

import axios from 'axios'
window.axios = axios

import echarts from 'echarts'
window.echarts = echarts

import QRCode from 'qrcodejs2'
window.QRCode = QRCode

export default window

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap.min'

import 'animate.css'


