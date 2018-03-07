<template>
  <div class="postslistclass">
    <!--{{ all_posts }}-->
    <div v-for="post in all_posts" class="one_post">
      <article class="post-block">
        <div class="post-wrapper">
          <header class="post-header">
            <h3 class="hmg"></h3>
            <img :src= "post_header_image_url(post)" >
          </header>
          <section class="post">
            <div class="post-content">
              <h3 class="title">{{ post.theme }}</h3>
              <p class="border post_text"> {{ post.description }}</p>
            </div>
          </section>
          <section class="additional-post-info"></section>
          <footer class="post-footer"></footer>
        </div>
      </article>
    </div>
  </div>
</template>

<script>

export default {
  data: function(){
    return {
      all_posts: []
    }
  },
  methods: {
   post_header_image_url: function(postik) {
//     console.log(postik)
     if(postik.attachments.length != 0){
//       console.log(postik);
       return postik['attachments']['0']['file']['url'];
     }
   },
//   post_info: function(post){
//     return post
//   },
   get_posts: function(){
     this.$http.get('/posts').then(function(responce) {
//       console.log(responce)
       this.all_posts = responce.body
//       return responce[]
//       return { responce_body: responce.body }
     }, function(error){
       // error
     })
   }
 },
 created: function() {
   this.get_posts()
 }
}

</script>

<style lang="scss" scoped >

/*.one_post{*/
  /*width: 30px;*/
  /*height: 20px;*/
/*}*/
.title {
  font: 1em "Source Code Pro", Monaco, monospace;
  color: #de5c35;
  text-align: center;
}

article{
  margin-bottom: 30px;
  position: relative;
  display: flex;
  flex-direction: row;
  justify-content: center;
}


.post-header{
    img {
      width: 400px;
      max-width: 300px !important;
    }
}

.post{
  p{
    font-family: "Helvetica Neue",HelveticaNeue,Arial,sans-serif;
  }

  margin: 5px;
  padding: 10px;
  display: block;
  overflow-wrap: normal;
  word-wrap: normal;
  word-break: break-all;
  box-sizing: content-box;

  .post_text{
    font-family: "Helvetica Neue",HelveticaNeue,Arial,sans-serif !important;
    text-align: justify;
  }
}

.post-wrapper{
  background: #fff;
  border-radius: 6px;
  overflow: hidden;
  padding: 0;
  position: relative;
  background-clip: padding-box;
  border: 1px solid #eee;
}
</style>
