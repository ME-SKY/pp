/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import Vue from 'vue/dist/vue.esm'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

import VueRouter from 'vue-router'
import VueResource from 'vue-resource'




import App from '../app.vue'

Vue.use(VueRouter)
Vue.use(VueResource)

Vue.component('font-awesome-icon', FontAwesomeIcon)
// Vue.use(FontAwesomeIcon)
// Vue.use(Trumbo)
// Vue.use(VueMaterial)
// UIkit.use(Icons)

// const routes = [
//     { path: '/posts', component: PostsList }
// ]

// const router = new VueRouter({
//     routes
// })

// const el = document.body.appendChild(document.createElement('application'))

new Vue({
    // router,
    ...App
    // created: function(){
    //     this.getAllPosts()
    // }
    // template: '<app/>',
    // components: { App }
}).$mount('#app')
