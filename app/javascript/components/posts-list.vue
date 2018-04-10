<template>
    <div class="postslistclass">

        <!--<rich-editor/>-->

        <div v-for="post in all_posts" class="one_post">
            <one-post :content="post.text" />
        </div>
    </div>
</template>

<script>

  import OnePost from './one-post'

  export default {
        components: {
          'one-post': OnePost
        },
        data: function(){
          return {
              all_posts: []
          }
        },
        methods: {
            post_header_image_url: function(postik) {
                if(postik.attachments.length != 0){
                    return postik['attachments']['0']['file']['url'];
                }},
            get_posts: function(){
                this.$http.get('/posts').then(function(responce) {
                    this.all_posts = responce.body
                }, function(error){
                    console.log('error')
                })
            },
            add_new_post: function(post){
               this.all_posts.push(post)
            }
        },
        created: function() {
            this.get_posts()
        },
        mounted: function(){
            var vc = this
            vc.$root.$on('newPostIsCreated', function (post) {
              console.log('new post is created!!!')
              console.log(post)
              console.log(vc.all_posts)
              vc.all_posts.unshift(post)
            })
        }
  }

</script>

<style lang="scss" scoped >

</style>
