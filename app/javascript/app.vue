<template>
  <div id="app">
    <div v-for="post in original_posts">
      {{ post }}
      <article class="post-block">
        <div class="post-wrapper">
          <header class="post-header">
            <h3 class="hmg">{{ post.header_img }}</h3>
            <img :src= "post.header_img" >
          </header>
          <section class="post">
            <div class="post-content">
              <h3 class="title">{{ post.theme }}</h3>
              <p class="border post_text"> {{ post.description_crop }}</p>
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
 props: ["original_posts"]
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
