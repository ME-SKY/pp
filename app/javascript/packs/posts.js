/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import Vue from 'vue/dist/vue.esm'
// import Vue from 'vue'
import PostsList from '../components/PostsList.vue'
// import NewPost from '../components/NewPost.vue'
// import App from '../app.vue';


document.addEventListener('DOMContentLoaded', () => {
   
    var posts_block = document.querySelector('#posts-block');
    
    if (posts_block != undefined) {
        const app = new Vue({
            el: posts_block,
            data: {
                posts: JSON.parse(posts_block.dataset.posts)
            },
            template: "<posts-list :original_posts='posts' />",
            components: {
                'posts-list': PostsList
            }
        });
    }
});