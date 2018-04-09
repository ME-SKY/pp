<template>
    <div class="postslistclass">

        <!--<rich-editor/>-->

        <div v-for="post in all_posts" class="one_post">
            <one-post :content="post.text" :image_post_url="post_header_image_url(post)"
                           :theme="post.theme"
                           :description="post.description" :post="post"/>
        </div>
    </div>
</template>

<script>

  import OnePost from './one-post'
//  import RichTextEditor from './rich-text-editor'

  export default {
        components: {
          'one-post': OnePost
//          'rich-editor': RichTextEditor
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
            }
        },
        created: function() {
            this.get_posts()
        }
  }

</script>

<style lang="scss" scoped >

</style>
